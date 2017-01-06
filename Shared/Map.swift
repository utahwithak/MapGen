//
//  Map.swift
//  Map Generator
//
//  Created by Carl Wieland on 4/27/15.
//  Copyright (c) 2015 Carl Wieland. All rights reserved.
//

import Foundation

#if os(iOS)
    import DelaunayiOS
    #elseif os(OSX)
    import Delaunay
#endif

class Map{
    
    static let LAKE_THRESHOLD = 0.3;  // 0 to 1, fraction of water corners for water polygon
    
    // Passed in by the caller:
    var Size:Double;

    // Island shape is controlled by the islandRandom seed and the
    // type of island, passed in when we set the island shape. The
    // islandShape function uses both of them to determine whether any
    // point should be water or land.
    var mapShape:(_ q:Point)->Bool;
    
    // Island details are controlled by this random generator. The
    // initial map upon loading is always deterministic, but
    // subsequent maps reset this random number generator with a
    // random seed.
    var mapRandom:PM_PRNG = PM_PRNG();

    // Point selection is random for the original article, with Lloyd
    // Relaxation, but there are other ways of choosing points. Grids
    // in particular can be much simpler to start with, because you
    // don't need Voronoi at all. HOWEVER for ease of implementation,
    // I continue to use Voronoi here, to reuse the graph building
    // code. If you're using a grid, generate the graph directly.
    var pointSelector:(_ numPoints:Int)->[Point];
    var numPoints:Int;
    
    var points = [Point]();  // Only useful during map construction
    var centers = [Center]();
    var corners = [Corner]()
    var edges = [Edge]()
    
    var seed:Int
    init(size:Int, numPoints:Int, seed:Int, varient:Int){
        Size = Double(size)
        self.numPoints = numPoints
        self.seed = seed
        pointSelector = Map.generateRelaxed(size, seed: seed)
        mapShape = Map.makePerlin(seed)
        mapRandom.seed = UInt(varient)
        reset()
    }
    
    func reset(){
        points.removeAll(keepingCapacity: true)
        centers.removeAll(keepingCapacity: true)
        corners.removeAll(keepingCapacity: true)
        edges.removeAll(keepingCapacity: true)
    }
    
    typealias StageStep = () -> Void

    func buildMap(){
        var stages = [(String,StageStep)]()
        // Generate the initial random set of points
        stages.append(("Placing Points...",{()->Void in
            self.reset()
            self.points = self.pointSelector(self.numPoints)
        }))
        
        // Create a graph structure from the Voronoi edge list. The
        // methods in the Voronoi object are somewhat inconvenient for
        // my needs, so I transform that data into the data I actually
        // need: edges connected to the Delaunay triangles and the
        // Voronoi polygons, a reverse map from those four points back
        // to the edge, a map from these four points to the points
        // they connect to (both along the edge and crosswise).
        stages.append(("Building Graph...",{()->Void in
            let voronoi = Voronoi(points: self.points, colors: nil, plotBounds: Rectangle(x: 0, y: 0, width: Double(self.Size),height: Double(self.Size)));
            self.buildGraph(self.points, voronoi: voronoi);
            self.improveCorners();
            voronoi.dispose();
            self.points.removeAll(keepingCapacity: true)
        }));
        
        stages.append(("Assign Elevations...",{()->Void in

            // Determine the elevations and water at Voronoi corners.
            self.assignCornerElevations();
            
            // Determine polygon and corner type: ocean, coast, land.
            self.assignOceanCoastAndLand();

            // Rescale elevations so that the highest is 1.0, and they're
            // distributed well. We want lower elevations to be more common
            // than higher elevations, in proportions approximately matching
            // concentric rings. That is, the lowest elevation is the
            // largest ring around the island, and therefore should more
            // land area than the highest elevation, which is the very
            // center of a perfectly circular island.
            var landCorners = self.landCorners(self.corners)
            self.redistributeElevations(&landCorners);
            
//            // Assign elevations to non-land corners
//            for q in self.corners {
//                if (q.ocean || q.coast) {
//                    q.elevation = 0.0;
//                }
//            }
            
            // Polygon elevations are the average of their corners
            self.assignPolygonElevations();
        }));
        
        
        
        
        
        stages.append(("Assign Moisture...",{()->Void in
            // Determine downslope paths.
            self.calculateDownslopes();
            
            // Determine watersheds: for every corner, where does it flow
            // out into the ocean?
            self.calculateWatersheds();
            
            // Create rivers.
            self.createRivers();
            
            // Determine moisture at corners, starting at rivers
            // and lakes, but not oceans. Then redistribute
            // moisture to cover the entire range evenly from 0.0
            // to 1.0. Then assign polygon moisture as the average
            // of the corner moisture.
            self.assignCornerMoisture();
            var landCorners = self.landCorners(self.corners)
            self.redistributeMoisture(&landCorners);
            self.assignPolygonMoisture();
            }));
        
        stages.append(("Decorate Map...",{()->Void in
            self.assignBiomes();
        }));

        
        func timeIt(_ name:String, step:StageStep){
            print("Starting \(name)")
            let start = Date()
            step()
            let end = Date();
            let timeInterval: Double = end.timeIntervalSince(start); // <<<<< Difference in seconds (double)
            print("Finished... \(timeInterval)")
        }
        
        for (name, stage) in stages {
            timeIt(name, step: stage);
        }
    }
    
    
    // Assign a biome type to each polygon. If it has
    // ocean/coast/water, then that's the biome; otherwise it depends
    // on low/high elevation and low/medium/high moisture. This is
    // roughly based on the Whittaker diagram but adapted to fit the
    // needs of the island map generator.
    static func getBiome(_ p:Center)->Biome {
        if (p.ocean) {
            return .ocean;
        }
        else if (p.water) {
            if (p.elevation < 0.1){ return .marsh};
            if (p.elevation > 0.8){return .ice};
            return .lake;
        }
        else if (p.coast) {
            return .beach;
        }
        else if (p.elevation > 0.8) {
            if (p.moisture > 0.50){ return .snow}
            else if (p.moisture > 0.33){return .tundra}
            else if (p.moisture > 0.16){return .bare}
            return Biome.scorched;

        }
        else if (p.elevation > 0.6) {
            if (p.moisture > 0.66){ return Biome.taiga}
            else if (p.moisture > 0.33){ return .shrubland}
            else{ return .temperateDesert}
        }
        else if (p.elevation > 0.3) {
            if (p.moisture > 0.83) {return Biome.temperateRainForest}
            else if (p.moisture > 0.50) {return Biome.temperateDeciduousForest}
            else if (p.moisture > 0.16){return .grassland};
            return .temperateDesert;
        } else {
            if (p.moisture > 0.66) {return Biome.tropicalRainForest }
            else if (p.moisture > 0.33) {return Biome.tropicalSeasonalForest }
            else if (p.moisture > 0.16) {return .grassland} ;
            return Biome.subtropicalDesert
        }
    }
    
    func assignBiomes() {
        for p in centers {
            p.biome = Map.getBiome(p);
        }
    }




    // Create rivers along edges. Pick a random corner point, then
    // move downslope. Mark the edges and corners as rivers.
    func createRivers() {
        for _ in 0..<Int(Size/2) {

            var q = corners[Int(mapRandom.nextIntRange(0, max: UInt(corners.count-1)))];
            if (q.ocean || q.elevation < 0.3 || q.elevation > 0.9){
                continue;
            }
            // Bias rivers to go west: if (q.downslope.x > q.x) continue;
            while (!q.coast) {
                if (q === q.downslope) {
                    break;
                }
                if let edge = lookupEdgeFromCorner(q, s: q.downslope){
                    edge.river = edge.river + 1;
                }
                q.river = q.river  + 1;
                q.downslope.river = q.downslope.river + 1;  // TODO: fix double count
                q = q.downslope;
            }
        }
    }
    
    
    // Calculate moisture. Freshwater sources spread moisture: rivers
    // and lakes (not oceans). Saltwater sources have moisture but do
    // not spread it (we set it at the end, after propagation).
    func assignCornerMoisture() {
        var queue = [Corner]();
        // Fresh water
        for q in corners {
            if ((q.water || q.river > 0) && !q.ocean) {
                q.moisture = q.river > 0 ? min(3.0, (0.2 * Double(q.river))) : 1.0;
                queue.append(q);
            }
            else {
                q.moisture = 0.0;
            }
        }
        while (queue.count > 0) {
            let q = queue.remove(at: 0)
    
            for r in q.adjacent {
                let newMoisture = q.moisture * 0.9;
                if (newMoisture > r.moisture) {
                    r.moisture = newMoisture;
                    queue.append(r);
                }
            }
        }
        // Salt water
        for q in corners {
            if (q.ocean || q.coast) {
                q.moisture = 1.0;
            }
        }
    }
    
    
    
    // Polygon moisture is the average of the moisture at corners
    func assignPolygonMoisture() {
        for p in centers {
            var sumMoisture = 0.0;
            for q in p.corners {
                if (q.moisture > 1.0) {
                    q.moisture = 1.0;
                }
                sumMoisture += q.moisture;
            }
            p.moisture = sumMoisture / Double(p.corners.count);
        }
    }
    
    
    // Change the overall distribution of moisture to be evenly distributed.
    func redistributeMoisture(_ locations:inout [Corner]){
        locations.sort(by: { $0.moisture < $1.moisture })
        for i in 0..<locations.count{
            locations[i].moisture = Double(i)/Double(locations.count-1);
        }
    }


    // Calculate downslope pointers.  At every point, we point to the
    // point downstream from it, or to itself.  This is used for
    // generating rivers and watersheds.
     func calculateDownslopes(){
        for q in corners {
            var r = q;
            for s in q.adjacent {
                if (s.elevation <= r.elevation) {
                    r = s;
                }
            }
            q.downslope = r;
        }
        
    }

    // Calculate the watershed of every land point. The watershed is
    // the last downstream land point in the downslope graph. TODO:
    // watersheds are currently calculated on corners, but it'd be
    // more useful to compute them on polygon centers so that every
    // polygon can be marked as being in one watershed.
    func calculateWatersheds() {
        var  changed = false;
    
        // Initially the watershed pointer points downslope one step.
        for q in corners {
            q.watershed = q;
            if (!q.ocean && !q.coast) {
                q.watershed = q.downslope;
            }
        }
        // Follow the downslope pointers to the coast. Limit to 100
        // iterations although most of the time with numPoints==2000 it
        // only takes 20 iterations because most points are not far from
        // a coast.  TODO: can run faster by looking at
        // p.watershed.watershed instead of p.downslope.watershed.
        for _ in 0..<100{
            changed = false;
            for q in corners {
                if (!q.ocean && !q.coast && !q.watershed.coast) {
                    let r = q.downslope.watershed;
                    if (!(r?.ocean)!) {
                        q.watershed = r;
                        changed = true;
                    }
                }
            }
            if (!changed) {break;}
        }
        // How big is each watershed?
        for q in corners {
            let r = q.watershed;
            r?.watershed_size = 1 + (r?.watershed_size)!;
        }
    }
    
    // Polygon elevations are the average of the elevations of their corners.
    func assignPolygonElevations() {
        for p in centers {
            var sumElevation = 0.0;
            for q in p.corners {
                sumElevation += q.elevation;
            }
            p.elevation = sumElevation / Double(p.corners.count);
        }
    }

    
    
    // Change the overall distribution of elevations so that lower
    // elevations are more common than higher
    // elevations. Specifically, we want elevation X to have frequency
    // (1-X).  To do this we will sort the corners, then set each
    // corner to its desired elevation.
    func redistributeElevations(_ locations:inout [Corner]) {
    // SCALE_FACTOR increases the mountain area. At 1.0 the maximum
    // elevation barely shows up on the map, so we set it to 1.1.
        let SCALE_FACTOR = 1.1;
        
    
        locations.sort{ $0.elevation < $1.elevation }
        for i in 0..<locations.count{
            // Let y(x) be the total area that we want at elevation <= x.
            // We want the higher elevations to occur less than lower
            // ones, and set the area to be y(x) = 1 - (1-x)^2.
            let y = Double(i) / Double(locations.count - 1);
            // Now we have to solve for x, given the known y.
            //  *  y = 1 - (1-x)^2
            //  *  y = 1 - (1 - 2x + x^2)
            //  *  y = 2x - x^2
            //  *  x^2 - 2x + y = 0
            // From this we can use the quadratic equation to get:
            var x = sqrt(SCALE_FACTOR) - sqrt(SCALE_FACTOR * Double(1 - y));
            if (x > 1.0){
                x = 1.0;  // TODO: does this break downslopes?
            }
            locations[i].elevation = x;
    }
}



    // Create an array of corners that are on land only, for use by
    // algorithms that work only on land.  We return an array instead
    // of a vector because the redistribution algorithms want to sort
    // this array using Array.sortOn.
    func landCorners(_ corners:[Corner])->[Corner] {
        var locations = [Corner]();
        for q in corners {
            if (!q.ocean && !q.coast) {
                locations.append(q);
            }
        }
        return locations;
    }
    
    
    
    
    // Determine elevations and water at Voronoi corners. By
    // construction, we have no local minima. This is important for
    // the downslope vectors later, which are used in the river
    // construction algorithm. Also by construction, inlets/bays
    // push low elevation areas inland, which means many rivers end
    // up flowing out through them. Also by construction, lakes
    // often end up on river paths because they don't raise the
    // elevation as much as other terrain does.
    func assignCornerElevations(){
        var queue = [Corner]();
        
        for q in corners {
            q.water = !inside(q.point);
        }
        
        for q in corners {
            // The edges of the map are elevation 0
            if (q.border) {
                q.elevation = 0.0;
                queue.append(q);
            }
            else {
                q.elevation = Double.infinity;
            }
        }
        // Traverse the graph and assign elevations to each point. As we
        // move away from the map border, increase the elevations. This
        // guarantees that rivers always have a way down to the coast by
        // going downhill (no local minima).
        while (queue.count > 0) {
            let q =  queue.remove(at: 0)

        
            for s in q.adjacent {
                // Every step up is epsilon over water or 1 over land. The
                // number doesn't matter because we'll rescale the
                // elevations later.
                var newElevation = 1 + q.elevation;
                if (!q.water && !s.water) {
                    newElevation += 1;
                }
                // If this point changed, we'll add it to the queue so
                // that we can process its neighbors too.
                if (newElevation < s.elevation) {
                    s.elevation = newElevation;
                    queue.append(s);
                }
            }
        }
    }
    
    
    // Determine polygon and corner types: ocean, coast, land.
    func assignOceanCoastAndLand() {
        // Compute polygon attributes 'ocean' and 'water' based on the
        // corner attributes. Count the water corners per
        // polygon. Oceans are all polygons connected to the edge of the
        // map. In the first pass, mark the edges of the map as ocean;
        // in the second pass, mark any water-containing polygon
        // connected an ocean as ocean.
        var queue = [Center]();

        var numWater  = 0
        for p in centers{
            numWater = 0;
            for q in p.corners {
                if (q.border) {
                    p.border = true;
                    p.ocean = true;
                    q.water = true;
                    queue.append(p);
                }
                if (q.water) {
                    numWater += 1;
                }
            }
            p.water = (p.ocean || Double(numWater) >= Double(p.corners.count) * Map.LAKE_THRESHOLD);
        }
        while (queue.count > 0) {
            let p = queue.remove(at: 0)
            for r in p.neighbors {
                if (r.water && !r.ocean) {
                    r.ocean = true;
                    queue.append(r);
                }
            }
        }
    
        // Set the polygon attribute 'coast' based on its neighbors. If
        // it has at least one ocean and at least one land neighbor,
        // then this is a coastal polygon.
        for p in centers{
            var numOcean = 0;
            var numLand = 0;
            for r in p.neighbors {
                numOcean += r.ocean ? 1 : 0;
                numLand += !r.water ? 1 : 0;
            }
            p.coast = (numOcean > 0) && (numLand > 0);
        }
    
    
        // Set the corner attributes based on the computed polygon
        // attributes. If all polygons connected to this corner are
        // ocean, then it's ocean; if all are land, then it's land;
        // otherwise it's coast.
        for q in corners {
            var numOcean = 0;
            var numLand = 0;
            for p in q.touches {
                numOcean += p.ocean ? 1 : 0;
                numLand += !p.water ? 1 : 0;
            }
            q.ocean = (numOcean == q.touches.count);
            q.coast = (numOcean > 0) && (numLand > 0);
            q.water = q.border || ((numLand != q.touches.count) && !q.coast);
        }
    }
    
    // Look up a Voronoi Edge object given two adjacent Voronoi
    // polygons, or two adjacent Voronoi corners
    func lookupEdgeFromCenter(_ p:Center, r:Center)->Edge? {
        for edge in p.borders {
            if (edge.d0 === r || edge.d1 === r){
                return edge;
            }
        }
        return nil;
    }
    
    func lookupEdgeFromCorner(_ q:Corner, s:Corner)->Edge? {
        for edge in q.protrudes {
            if (edge.v0 === s || edge.v1 === s){
                return edge;
            }
        }
        return nil;
    }

    
    
    // Determine whether a given point should be on the island or in the water.
    func inside(_ p:Point)->Bool {
        return mapShape(p);
    }

    
    // Although Lloyd relaxation improves the uniformity of polygon
    // sizes, it doesn't help with the edge lengths. Short edges can
    // be bad for some games, and lead to weird artifacts on
    // rivers. We can easily lengthen short edges by moving the
    // corners, but **we lose the Voronoi property**.  The corners are
    // moved to the average of the polygon centers around them. Short
    // edges become longer. Long edges tend to become shorter. The
    // polygons tend to be more uniform after this step.
    func improveCorners() {
        var newCorners = [Point]()

    
        // First we compute the average of the centers next to each corner.
        for q in corners {
            if (q.border) {
                newCorners.append(q.point)
            }
            else {
                let point =  Point(x: 0.0, y: 0.0);
                for r in q.touches {
                    point.x += r.point.x;
                    point.y += r.point.y;
                }
                point.x /= Double(q.touches.count);
                point.y /= Double(q.touches.count);
                newCorners.append(point);
            }
        }
    
        // Move the corners to the new locations.
        for i in 0..<corners.count{
            corners[i].point = newCorners[i];
        }
    
        // The edge midpoints were computed for the old corners and need
        // to be recomputed.
        for edge in edges {
            if let p1 = edge.v0, let p2 = edge.v1{
                edge.midpoint = Point.interpolate(p1.point, p2:p2.point, t: 0.5);
            }
        }
    }

    
    
    // Build graph data structure in 'edges', 'centers', 'corners',
    // based on information in the Voronoi results: point.neighbors
    // will be a list of neighboring points of the same type (corner
    // or center); point.edges will be a list of edges that include
    // that point. Each edge connects to four points: the Voronoi edge
    // edge.{v0,v1} and its dual Delaunay triangle edge edge.{d0,d1}.
    // For boundary polygons, the Delaunay edge will have one nil
    // point, and the Voronoi edge may be nil.
    func buildGraph(_ points:[Point], voronoi:Voronoi) {
    
        var libedges = voronoi.edges


        
        var centerLookup = [Point:Center]()
    
        // Build Center objects for each of the points, and a lookup map
        // to find those Center objects again as we build the graph
        for point in points {
            let p = Center();
            p.index = centers.count;
            p.point = point;
            centers.append(p);
            centerLookup[point] = p;
        }
    
        // Workaround for Voronoi lib bug: we need to call region()
        // before Edges or neighboringSites are available
        for p in centers {
            _ = voronoi.region(p.point);
        }
    
        // The Voronoi library generates multiple Point objects for
        // corners, and we need to canonicalize to one Corner object.
        // To make lookup fast, we keep an array of Points, bucketed by
        // x value, and then we only have to look at other Points in
        // nearby buckets. When we fail to find one, we'll create a new
        // Corner object.
        var cornerMap = [Int:[Corner]]();
        func makeCorner(_ point:Point?)->Corner? {
            if (point == nil){
                return nil;
            }
            for bucket in Int(point!.x) - 1...Int(point!.x)+1 {
                if let array = cornerMap[bucket]{
                    for q in array {
                        let dx = point!.x - q.point.x;
                        let dy = point!.y - q.point.y;
                        if (dx*dx + dy*dy < 1e-6) {
                            return q;
                        }
                    }
                }
            }
            let bucket = Int(point!.x);
            if (cornerMap[bucket] == nil){
                cornerMap[bucket] = [Corner]();
            }
            let q = Corner();
            q.index = corners.count;
            corners.append(q);
            q.point = point;
            q.border = (Int(point!.x) == 0 || Int(point!.x) == Int(Size) || Int(point!.y) == 0 || Int(point!.y) == Int(Size));
            cornerMap[bucket]?.append(q);
            return q;
        }
        
        // Helper functions for the following for loop; ideally these
        // would be inlined
        func addToCenterList(_ v:inout [Center], _ x:Center?){
            if x != nil{
                let filtered = v.filter{$0 === x!}
                if filtered.count == 0 {
                    v.append(x!);
                }
            }
        }
        func addToCornerList(_ v:inout [Corner], _ x:Corner?) {
            if x != nil{
                let filtered = v.filter{$0 === x!}
                if filtered.count == 0{
                    v.append(x!);
                }
            }
        }

        
        for libedge in libedges {
            let dedge = libedge.delaunayLine;
            let vedge = libedge.voronoiEdge();
        
            // Fill the graph data. Make an Edge object corresponding to
            // the edge from the voronoi library.
            let edge =  Edge();
            edge.index = edges.count
            edge.river = 0;
            edges.append(edge);
            if let p1 = vedge.p0, let p2 = vedge.p1{
                edge.midpoint = Point.interpolate(p1, p2:p2, t: 0.5);
            }
        
            // Edges point to corners. Edges point to centers.
            edge.v0 = makeCorner(vedge.p0);
            edge.v1 = makeCorner(vedge.p1);
            edge.d0 = centerLookup[dedge.p0];
            edge.d1 = centerLookup[dedge.p1];
        
            // Centers point to edges. Corners point to edges.
            if (edge.d0 != nil) { edge.d0.borders.append(edge); }
            if (edge.d1 != nil) { edge.d1.borders.append(edge); }
            if (edge.v0 != nil) { edge.v0.protrudes.append(edge); }
            if (edge.v1 != nil) { edge.v1.protrudes.append(edge); }
        
            // Centers point to centers.
            if (edge.d0 != nil && edge.d1 != nil) {
                addToCenterList(&edge.d0.neighbors, edge.d1);
                addToCenterList(&edge.d1.neighbors, edge.d0);
            }
        
            // Corners point to corners
            if (edge.v0 != nil && edge.v1 != nil) {
                addToCornerList(&edge.v0.adjacent, edge.v1);
                addToCornerList(&edge.v1.adjacent, edge.v0);
            }
            
            // Centers point to corners
            if (edge.d0 != nil) {
                addToCornerList(&edge.d0.corners, edge.v0);
                addToCornerList(&edge.d0.corners, edge.v1);
            }
            if (edge.d1 != nil) {
                addToCornerList(&edge.d1.corners, edge.v0);
                addToCornerList(&edge.d1.corners, edge.v1);
            }
            
            // Corners point to centers
            if (edge.v0 != nil) {
                addToCenterList(&edge.v0.touches, edge.d0);
                addToCenterList(&edge.v0.touches, edge.d1);
            }
            if (edge.v1 != nil) {
                addToCenterList(&edge.v1.touches, edge.d0);
                addToCenterList(&edge.v1.touches, edge.d1);
            }
        }
    }
    
    // Generate points at random locations
    static func generateRandom(_ size:Int, seed:Int)->(_ numPoints:Int)->[Point] {
        func generator(_ numPoints:Int)->[Point] {
            let mapRandom = PM_PRNG();
            mapRandom.seed = UInt(seed)
            var p:Point
            var points = [Point]();

            for _ in 0..<numPoints {
                p = Point(x:Double(mapRandom.nextDoubleRange(10.0, max: Double(size)-10.0)),
                    y:Double(mapRandom.nextDoubleRange(10.0,max: Double(size)-10.0)));
                points.append(p);
            }
            return points;
        }
        return generator
    }
    
    static func generateRelaxed(_ size:Int, seed:Int)->(Int)->[Point]{
        func relaxedGenerator(_ numPoints:Int)->[Point]{

            var voronoi:Voronoi
            var region:[Point];
            let points = self.generateRandom(size, seed: seed)(numPoints);
            for _ in 0..<3 {
                voronoi = Voronoi(points: points, colors: nil, plotBounds: Rectangle(x: 0, y: 0, width: size, height: size));
                for p in points {

                    region = voronoi.region(p);
                    p.x = 0.0;
                    p.y = 0.0;
                    for q in region{
                        p.x += q.x;
                        p.y += q.y;
                    }
                    p.x /= Double(region.count);
                    p.y /= Double(region.count);
                    
                }
                voronoi.dispose();
            }
            return points;
        }
        return relaxedGenerator
    }
    
    // The Perlin-based island combines perlin noise with the radius
    static func makePerlin(_ seed:Int)->(_ q:Point)->Bool {
        let perlin = PerlinNoise(seed: seed)
        func perlShape(_ q:Point)->Bool {

            let c = perlin.perlin2DValue(forPoint: q.x, y: q.y)
//            println("(\(q.x), \(q.y))c:\(c)")
            return c > (0);
        };
        return perlShape
    }

}
