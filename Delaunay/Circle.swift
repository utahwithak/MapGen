import Foundation

public class Circle:Printable{
    public var center:Point;
    public var radius:Double;
    
    public init(centerX:Double, centerY:Double, radius:Double)
    {
        self.center =  Point(x:centerX, y:centerY);
        self.radius = radius;
    }
    
    public var description:String{
        return "Circle (center: \( center) + ; radius: \(radius))";
    }

}
