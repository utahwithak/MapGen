import Foundation

public final class Vertex: ICoord{
    public static let VERTEX_AT_INFINITY:Vertex = Vertex( x: CGFloat(Float.infinity),y: CGFloat( Float.infinity));
    
    private static var pool:[Vertex] = [Vertex]();
    private static func create(x:CGFloat, y:CGFloat)->Vertex
    {
        
        if (x.isNaN || y.isNaN)
        {
            return VERTEX_AT_INFINITY;
        }
        if (pool.count > 0)
        {
            return pool.removeLast().refresh(x,y: y);
        }
        else
        {
            return Vertex(x:x,y: y);
        }
    }
    
    
    private static var nvertices:Int = 0;
    
    public var coord:CGPoint = CGPoint.zeroPoint;
    private var vertexIndex:Int = 0;
    
    public init( x:CGFloat, y:CGFloat)
    {
        refresh(x, y:y);
    }
    
    private func refresh(x:CGFloat, y:CGFloat)->Vertex
    {
        coord = CGPoint(x:x, y:y);
        return self;
    }
    
    public func dispose()
    {
        Vertex.pool.append(self);
    }
    
    public func setIndex()
    {
        vertexIndex = Vertex.nvertices++;
    }
    
    public func toString()->String
    {
        return "Vertex (\(vertexIndex))";
    }
    
    /**
    * This is the only way to make a Vertex
    *
    * @param halfedge0
    * @param halfedge1
    * @return
    *
    */
    public static func intersect(halfedge0:Halfedge, halfedge1:Halfedge)->Vertex?
    {
        var edge0:Edge?, edge1:Edge?, edge:Edge;
        var halfedge:Halfedge;
        var determinant:CGFloat, intersectionX:CGFloat, intersectionY:CGFloat;
        var rightOfSite:Bool;
        
        edge0 = halfedge0.edge;
        edge1 = halfedge1.edge;
        if (edge0 == nil || edge1 == nil)
        {
            return nil;
        }
        if (edge0!.rightSite === edge1!.rightSite)
        {
            return nil;
        }
        
        determinant = edge0!.a * edge1!.b - edge0!.b * edge1!.a;
        if (-1.0e-10 < determinant && determinant < 1.0e-10)
        {
            // the edges are parallel
            return nil;
        }
        
        intersectionX = (edge0!.c * edge1!.b - edge1!.c * edge0!.b)/determinant;
        intersectionY = (edge1!.c * edge0!.a - edge0!.c * edge1!.a)/determinant;
        
        if (Voronoi.compareByYThenX(edge0!.rightSite!, s2: edge1!.rightSite!) < 0)
        {
            halfedge = halfedge0;
            edge = edge0!;
        }
        else
        {
            halfedge = halfedge1;
            edge = edge1!;
        }
        rightOfSite = intersectionX >= edge.rightSite!.x;
        if ((rightOfSite && halfedge.leftRight == LR.LEFT)
            ||  (!rightOfSite && halfedge.leftRight == LR.RIGHT))
        {
            return nil;
        }
        
        return Vertex.create(intersectionX, y: intersectionY);
    }
    
    
    public var x:CGFloat
        {
            return coord.x;
    }
    public var y:CGFloat
        {
            return coord.y;
    }
}