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
    var mapShape:(q:Point)->Bool;
    
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
    var pointSelector:(numPoints:Int)->[Point];
    var numPoints:Int;
    
    var points = [Point]();  // Only useful during map construction
    var centers = [Center]();
    var corners = [Corner]()
    var edges = [Edge]()
    
    var seed:Int
    init(size:Double){
        Size = size
        numPoints = 1
        seed = random()
        pointSelector = Map.generateRelaxed(1024, seed: seed)
        mapShape = Map.makePerlin(seed)
        reset()
    }
    
    func reset(){
        points.removeAll(keepCapacity: true)
        centers.removeAll(keepCapacity: true)
        corners.removeAll(keepCapacity: true)
        edges.removeAll(keepCapacity: true)
    }
    
    
    
    // Generate points at random locations
    static func generateRandom(size:Int, seed:Int)->(numPoints:Int)->[Point] {
        func generator(numPoints:Int)->[Point] {
            var mapRandom = PM_PRNG();
            mapRandom.seed = UInt(seed)
            var p:Point
            var i:Int = 0
            var points = [Point]();
            for (i = 0; i < numPoints; i++) {
                p = Point(x:Double(mapRandom.nextDoubleRange(10.0, max: Double(size)-10.0)),
                    y:Double(mapRandom.nextDoubleRange(10.0,max: Double(size)-10.0)));
                points.append(p);
            }
            return points;
        }
        return generator
    }
    
    static func generateRelaxed(size:Int, seed:Int)->(Int)->[Point]{
        func relaxedGenerator(numPoints:Int)->[Point]{
            var i:Int
            var p:Point
            var q:Point
            var voronoi:Voronoi
            var region:[Point];
            var points = ViewController.generateRandom(size, seed: seed)(numPoints: numPoints);
            for (i = 0; i < 3; i++) {
                voronoi = Voronoi(points: points, colors: nil, plotBounds: Rectangle(x: 0, y: 0, width: size, height: size));
                for pIn in points {
                    var p = pIn
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
    static func makePerlin(seed:Int)->(q:Point)->Bool {
        let perlin = PerlinNoise(seed: seed)
        func perlShape(q:Point)->Bool {
            let c = perlin.perlin2DValueForPoint(((q.x+1)*1024), y: Double(Int((q.y+1)*128) & 0xffff))
            return c > (0.3+0.3*q.length*q.length);
        };
        return perlShape
    }

}