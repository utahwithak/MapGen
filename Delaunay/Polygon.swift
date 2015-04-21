import Foundation

public class Polygon
{
    private var vertices:[CGPoint];

    public init(vertices:[CGPoint])
    {
        self.vertices = vertices;
    }

    public func area() -> CGFloat
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

    private func signedDoubleArea()->CGFloat
    {

        var nextIndex:Int;
        var n = vertices.count;
        var point:CGPoint, next:CGPoint;
        var signedDoubleArea:CGFloat = 0;
        
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
