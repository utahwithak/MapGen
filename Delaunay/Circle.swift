import Foundation

public class Circle:Printable{
    public var center:CGPoint;
    public var radius:CGFloat;
    
    public init(centerX:CGFloat, centerY:CGFloat, radius:CGFloat)
    {
        self.center =  CGPoint(x:centerX, y:centerY);
        self.radius = radius;
    }
    
    public var description:String{
        return "Circle (center: \( center) + ; radius: \(radius))";
    }

}
