import Foundation

public class LineSegment
{

    
    public static func compareLengths_MAX(segment0:LineSegment, segment1:LineSegment) -> Bool
    {
        

        var length0 = Point.distance(segment0.p0, segment0.p1);
        var length1 = Point.distance(segment1.p0, segment1.p1);
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
    
    public static func compareLengths(edge0:LineSegment, edge1:LineSegment) -> Bool
    {
        return !compareLengths_MAX(edge0, segment1: edge1);
    }

    public var p0:Point;
    public var p1:Point;
    
    public init(p0:Point, p1:Point)
    {
        self.p0 = p0;
        self.p1 = p1;
    }
}