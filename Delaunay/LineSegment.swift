import Foundation

public class LineSegment
{

    
    public static func compareLengths_MAX(segment0:LineSegment, segment1:LineSegment) -> Bool
    {
        

        var length0 = CGPoint.distance(segment0.p0, segment0.p1);
        var length1 = CGPoint.distance(segment1.p0, segment1.p1);
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

    public var p0:CGPoint;
    public var p1:CGPoint;
    
    public init(p0:CGPoint, p1:CGPoint)
    {
        self.p0 = p0;
        self.p1 = p1;
    }
}