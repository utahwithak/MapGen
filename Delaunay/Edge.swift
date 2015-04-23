import Foundation
/**
* The line segment connecting the two Sites is part of the Delaunay triangulation;
* the line segment connecting the two Vertices is part of the Voronoi diagram
* @author ashaw
*
*/
public final class Edge
{
    private static var pool = [Edge]()
    /**
    * This is the only way to create a new Edge
    * @param site0
    * @param site1
    * @return
    *
    */
    static func createBisectingEdge(site0:Site, site1:Site)->Edge
    {
        var dx:Double, dy:Double, absdx:Double, absdy:Double;
        var a:Double, b:Double, c:Double;
        
        dx = site1.x - site0.x;
        dy = site1.y - site0.y;
        absdx = dx > 0 ? dx : -dx;
        absdy = dy > 0 ? dy : -dy;
        c = site0.x * dx + site0.y * dy + (dx * dx + dy * dy) * 0.5;
        if (absdx > absdy)
        {
            a = 1.0; b = dy/dx; c /= dx;
        }
        else
        {
            b = 1.0; a = dx/dy; c /= dy;
        }
        
        var edge:Edge = Edge.create();
        
        edge.leftSite = site0;
        edge.rightSite = site1;
        site0.addEdge(edge);
        site1.addEdge(edge);
        
        edge.leftVertex = nil;
        edge.rightVertex = nil;
        
        edge.a = a;
        edge.b = b;
        edge.c = c;
        //trace("createBisectingEdge: a ", edge.a, "b", edge.b, "c", edge.c);
        
        return edge;
    }
    
    private static func create()->Edge
    {
        var edge:Edge;
        if (pool.count > 0)
        {
            edge = pool.removeLast()
            edge.refresh();
        }
        else
        {
            edge = Edge();
        }
        return edge;
    }
    
    //		private static let LINESPRITE:Sprite =  Sprite();
    //		private static let GRAPHICS:Graphics = LINESPRITE.graphics;
    //
    //		private var _delaunayLineBmp:BitmapData;
    //		func get delaunayLineBmp()->BitmapData
    //		{
    //			if (!_delaunayLineBmp)
    //			{
    //				_delaunayLineBmp = makeDelaunayLineBmp();
    //			}
    //			return _delaunayLineBmp;
    //		}
    //
    //		// making this available to Voronoi; running out of memory in AIR so I cannot cache the bmp
    //		func makeDelaunayLineBmp()->BitmapData
    //		{
    //			var p0:Point = leftSite.coord;
    //			var p1:Point = rightSite.coord;
    //
    //			GRAPHICS.clear();
    //			// clear() resets line style back to undefined!
    //			GRAPHICS.lineStyle(0, 0, 1.0, false, LineScaleMode.NONE, CapsStyle.NONE);
    //			GRAPHICS.moveTo(p0.x, p0.y);
    //			GRAPHICS.lineTo(p1.x, p1.y);
    //
    //			var w:Int = int(Math.ceil(Math.max(p0.x, p1.x)));
    //			if (w < 1)
    //			{
    //				w = 1;
    //			}
    //			var h:Int = int(Math.ceil(Math.max(p0.y, p1.y)));
    //			if (h < 1)
    //			{
    //				h = 1;
    //			}
    //			var bmp:BitmapData = new BitmapData(w, h, true, 0);
    //			bmp.draw(LINESPRITE);
    //			return bmp;
    //		}
    //
    public func delaunayLine()->LineSegment
    {
        // draw a line connecting the input Sites for which the edge is a bisector:
        return LineSegment(p0: leftSite!.coord, p1: rightSite!.coord);
    }
    
    public func voronoiEdge()->LineSegment
    {
        if (!visible){
            return LineSegment(p0: Point.zeroPoint, p1: Point.zeroPoint);
        }
        return  LineSegment(p0:clippedVertices[LR.LEFT]!, p1:clippedVertices[LR.RIGHT]!);
    }
    
    private static var nedges:Int = 0;
    
    static let DELETED:Edge = Edge();
    
    // the equation of the edge: ax + by = c
    var a:Double = 0, b:Double = 0, c:Double = 0;
    
    // the two Voronoi vertices that the edge connects
    //		(if one of them is nil, the edge extends to infinity)
    var leftVertex:Vertex? = nil;
    var rightVertex:Vertex? = nil;
    
    func vertex(leftRight:LR)->Vertex
    {
        assert(leftRight != .Unknown, "INVALID SET VERT!")

        return (leftRight == LR.LEFT) ? leftVertex! : rightVertex!;
    }
    func setVertex(leftRight:LR, v:Vertex)
    {
        assert(leftRight != .Unknown, "INVALID SET VERT!")
        if (leftRight == LR.LEFT)
        {
            leftVertex = v;
        }
        else
        {
            rightVertex = v;
        }
    }
    
    func isPartOfConvexHull()->Bool
    {
        return (leftVertex == nil || rightVertex == nil);
    }
    
    public func sitesDistance()->Double
    {
        return Point.distance(leftSite!.coord, rightSite!.coord);
    }
    //
    public static func compareSitesDistances_MAX(edge0:Edge, edge1:Edge)->Bool
    {
        var length0:Double = edge0.sitesDistance();
        var length1:Double = edge1.sitesDistance();
        if (length0 < length1)
        {
            return true;
        }
        if (length0 > length1)
        {
            return false;
        }
        return false;
    }
    
    public static func compareSitesDistances(edge0:Edge, edge1:Edge) ->Bool
    {
        return !compareSitesDistances_MAX(edge0, edge1:edge1);
    }
    //
    //		// Once clipVertices() is called, this Dictionary will hold two Points
    //		// representing the clipped coordinates of the left and right ends...
    public var clippedVertices = [LR:Point]()
    
    //		// unless the entire Edge is outside the bounds.
    //		// In that case visible will be false:
    var visible:Bool
        {
            return clippedVertices.count > 0;
    }
    //
    //		// the two input Sites for which this Edge is a bisector:
    private var sites = [LR:Site]();
    var leftSite:Site?{
        get{
            return sites[LR.LEFT]
        }
        set{
            sites[LR.LEFT] = newValue
        }
    }
    
    var rightSite:Site?{
        get{
            return sites[LR.RIGHT]
        }
        set{
            sites[LR.RIGHT] = newValue;
        }
    }
    
    func site(leftRight:LR)->Site
    {
        return sites[leftRight]!;
    }
    //
    private let edgeIndex:Int;
    //
    public func dispose()
    {
        //			if (_delaunayLineBmp)
        //			{
        //				_delaunayLineBmp.dispose();
        //				_delaunayLineBmp = nil;
        //			}
        leftVertex = nil;
        rightVertex = nil;
        if (clippedVertices.count > 0)
        {
            clippedVertices[LR.LEFT] = nil;
            clippedVertices[LR.RIGHT] = nil;
            
        }
        sites[LR.LEFT] = nil;
        sites[LR.RIGHT] = nil;
        
        Edge.pool.append(self);
    }
    
    public init()
    {
        edgeIndex = Edge.nedges++;
        refresh();
    }
    //
    private func refresh()
    {
        sites.removeAll(keepCapacity: true)
    }
    //
    //		public func toString()->String
    //		{
    //			return "Edge " + _edgeIndex + "; sites " + _sites[LR.LEFT] + ", " + _sites[LR.RIGHT]
    //					+ "; endVertices " + (_leftVertex ? _leftVertex.vertexIndex : "nil") + ", "
    //					 + (_rightVertex ? _rightVertex.vertexIndex : "nil") + "::";
    //		}
    //
    /**
    * Set _clippedVertices to contain the two ends of the portion of the Voronoi edge that is visible
    * within the bounds.  If no part of the Edge falls within the bounds, leave _clippedVertices nil.
    * @param bounds
    *
    */
    func clipVertices(bounds:Rectangle)
    {
        var xmin = Double(bounds.minX)
        var ymin = Double(bounds.minY)
        var xmax = Double(bounds.maxX)
        var ymax = Double(bounds.maxY)
        
        var vertex0:Vertex?, vertex1:Vertex?;
        var x0:Double, x1:Double, y0:Double, y1:Double;
        
        if (a == 1.0 && b >= 0.0)
        {
            vertex0 = rightVertex;
            vertex1 = leftVertex;
        }
        else
        {
            vertex0 = leftVertex;
            vertex1 = rightVertex;
        }
        
        if (a == 1.0)
        {
            y0 = ymin;
            if (vertex0 != nil && vertex0!.y > ymin)
            {
                y0 = vertex0!.y;
            }
            if (y0 > ymax)
            {
                return;
            }
            x0 = c - b * y0;
            
            y1 = ymax;
            if (vertex1 != nil && vertex1!.y < ymax)
            {
                y1 = vertex1!.y;
            }
            if (y1 < ymin)
            {
                return;
            }
            x1 = c - b * y1;
            
            if ((x0 > xmax && x1 > xmax) || (x0 < xmin && x1 < xmin))
            {
                return;
            }
            
            if (x0 > xmax)
            {
                x0 = xmax; y0 = (c - x0)/b;
            }
            else if (x0 < xmin)
            {
                x0 = xmin; y0 = (c - x0)/b;
            }
            
            if (x1 > xmax)
            {
                x1 = xmax; y1 = (c - x1)/b;
            }
            else if (x1 < xmin)
            {
                x1 = xmin; y1 = (c - x1)/b;
            }
        }
        else
        {
            x0 = xmin;
            if (vertex0 != nil && vertex0!.x > xmin)
            {
                x0 = vertex0!.x;
            }
            if (x0 > xmax)
            {
                return;
            }
            y0 = c - a * x0;
            
            x1 = xmax;
            if (vertex1 != nil && vertex1!.x < xmax)
            {
                x1 = vertex1!.x;
            }
            if (x1 < xmin)
            {
                return;
            }
            y1 = c - a * x1;
            
            if ((y0 > ymax && y1 > ymax) || (y0 < ymin && y1 < ymin))
            {
                return;
            }
            
            if (y0 > ymax)
            {
                y0 = ymax; x0 = (c - y0)/a;
            }
            else if (y0 < ymin)
            {
                y0 = ymin; x0 = (c - y0)/a;
            }
            
            if (y1 > ymax)
            {
                y1 = ymax; x1 = (c - y1)/a;
            }
            else if (y1 < ymin)
            {
                y1 = ymin; x1 = (c - y1)/a;
            }
        }
        
        clippedVertices = [LR:Point]()
        if (vertex0 === leftVertex)
        {
            clippedVertices[LR.LEFT] = Point(x: x0, y: y0);
            clippedVertices[LR.RIGHT] = Point(x: x1, y: y1);
        }
        else
        {
            clippedVertices[LR.RIGHT] = Point(x: x0, y: y0);
            clippedVertices[LR.LEFT] = Point(x: x1, y: y1);
        }
    }
}