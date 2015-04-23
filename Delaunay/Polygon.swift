import Foundation

public class Polygon
{
    private var vertices:[Point];

    public init(vertices:[Point])
    {
        self.vertices = vertices;
    }

    public func area() -> Double
    {
        return abs(signedDoubleArea() * 0.5);
    }

    public func winding()->Winding
    {
        var sDoubleArea = signedDoubleArea();
        if (sDoubleArea < 0)
        {
            return Winding.CLOCKWISE;
        }
        if (sDoubleArea > 0)
        {
            return Winding.COUNTERCLOCKWISE;
        }
        return Winding.NONE;
    }

    private func signedDoubleArea()->Double
    {

        var nextIndex:Int;
        var n = vertices.count;
        var point:Point, next:Point;
        var signedDoubleArea:Double = 0;
        
        var index:Int
        for (index = 0; index < n; ++index)
        {
            nextIndex = (index + 1) % n;
            point = vertices[index]
            next = vertices[nextIndex]
            signedDoubleArea += point.x * next.y - next.x * point.y;
        }
        return signedDoubleArea;
    }
}
