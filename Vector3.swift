//
//  Vertex.swift
//  QuickHull
//
//  Created by Carl Wieland on 4/20/15.
//  Copyright (c) 2015 Carl Wieland. All rights reserved.
//

import Foundation
public struct Vector3:Printable, Hashable
{
    // Static Fields
    //
    public static let kEpsilon:Float = 1E-05;

    //
    // Fields
    //
    public var x:Float;
    public var y:Float;
    public var z:Float;



    //
    // Static Properties
    //
    public static let back = Vector3(0, 0, -1)
    

    public static let down = Vector3(0, -1, 0);
    

    public static let forward = Vector3(0, 0, 1);


    public static let left =  Vector3(-1, 0, 0)

    public static let one =  Vector3(1, 1, 1)

    public static let right =  Vector3 (1, 0, 0);
    
    public static let up =  Vector3 (0, 1, 0);
    public static let zero =  Vector3 (0, 0, 0);

    //
    // Properties
    //
    public var magnitude:Float{
        return sqrt(x * x + y * y + z * z);
    }

    public var normalized:Vector3{
        return Vector3.normalize(self);
    }

    public var sqrMagnitude:Float{
        return x * x + y * y + z * z;
    }

    //
    // Indexer
    //
    subscript(index:Int)->Float
    {
        get
            {
                switch (index)
                {
                case 0:
                    return x;
                case 1:
                    return y;
                case 2:
                    return z;
                default:
                    assert(false, "INVALID INDEX!")
                }
                return -1
        }
        set  {
                switch (index)
                {
                case 0:
                    x = newValue;
                case 1:
                    y = newValue;
                case 2:
                    z = newValue;
                    
                default:
                    assert(false, "INVALID INDEX!")
                }
        }
    }

    //
    // Constructors
    //
    public init(x:Float, y:Float)
    {
        self.x = x;
        self.y = y;
        self.z = 0;
    }

    public init(_ x:Float,_  y:Float,_  z:Float)
    {
        self.x = x;
        self.y = y;
        self.z = z;
    }
    public init(x:Float,  y:Float,  z:Float)
    {
        self.x = x;
        self.y = y;
        self.z = z;
    }

    //
    // Static Methods
    //
    public static func angle ( from:Vector3,  to:Vector3)->Float
    {
        return acos(clamp (Vector3.dot(from.normalized, rhs: to.normalized), -1, 1)) * 57.29578
    }

    public static func clampMagnitude ( vector:Vector3,  maxLength:Float)->Vector3
    {
        if (vector.sqrMagnitude > maxLength * maxLength)
        {
            return vector.normalized * maxLength;
        }
        return vector;
    }

    public static func cross (lhs:Vector3 , rhs:Vector3 )->Vector3{
        return Vector3 (lhs.y * rhs.z - lhs.z * rhs.y, lhs.z * rhs.x - lhs.x * rhs.z, lhs.x * rhs.y - lhs.y * rhs.x);
    }

    public static func distance ( a:Vector3, b:Vector3)->Float{
        let vector = Vector3 (a.x - b.x, a.y - b.y, a.z - b.z);
        return sqrt(vector.x * vector.x + vector.y * vector.y + vector.z * vector.z);
    }

    public static func dot (lhs:Vector3 , rhs:Vector3 )->Float{
        return lhs.x * rhs.x + lhs.y * rhs.y + lhs.z * rhs.z;
    }


    public static func lerp (from:Vector3 , to:Vector3 , t tin:Float)->Vector3
    {
        let t = clamp(tin,0,1);
        return Vector3 (from.x + (to.x - from.x) * t, from.y + (to.y - from.y) * t, from.z + (to.z - from.z) * t);
    }

    public static func magnitude (a:Vector3 )->Float
    {
        return sqrt(a.x * a.x + a.y * a.y + a.z * a.z);
    }

    public static func max ( lhs:Vector3,  rhs:Vector3)->Vector3
    {
        return Vector3 (Swift.max (lhs.x, rhs.x), Swift.max (lhs.y, rhs.y), Swift.max (lhs.z, rhs.z));
    }

    public static func min ( lhs:Vector3, rhs:Vector3)->Vector3
    {
        return  Vector3 (Swift.min (lhs.x, rhs.x), Swift.min (lhs.y, rhs.y), Swift.min (lhs.z, rhs.z));
    }

    public static func moveTowards ( current:Vector3,  target:Vector3,  maxDistanceDelta:Float)->Vector3
    {
        let a = target - current;
        let magnitude = a.magnitude;
        if (magnitude <= maxDistanceDelta || magnitude == 0)
        {
            return target;
        }
        return current + a / magnitude * maxDistanceDelta;
    }

    public static func normalize ( value:Vector3)->Vector3
    {
        let num = Vector3.magnitude (value);
        if (num > 1E-05)
        {
            return value / num;
        }
        return Vector3.zero;
    }

    public static func project ( vector:Vector3,  onNormal:Vector3)->Vector3
    {
        let num = Vector3.dot(onNormal, rhs: onNormal);
        if (num < 1.401298E-45)
        {
            return Vector3.zero;
        }
        return onNormal * Vector3.dot(vector, rhs:onNormal) / num;
    }

    public static func projectOnPlane ( vector:Vector3, planeNormal:Vector3 )->Vector3
    {
        return vector - Vector3.project (vector, onNormal:planeNormal);
    }

    public static func reflect (inDirection:Vector3 , inNormal:Vector3 )->Vector3
    {
        return -2 * Vector3.dot(inNormal,rhs: inDirection) * inNormal + inDirection;
    }

    public static func scale (a:Vector3 , b:Vector3 )->Vector3{
        return  Vector3 (a.x * b.x, a.y * b.y, a.z * b.z);
    }

    public static func sqrMagnitude (a:Vector3 )->Float
    {
        return a.x * a.x + a.y * a.y + a.z * a.z;
    }

    //
    // Methods
    //

    public var hashValue:Int
    {
        return Int(x * 19) ^ Int(y * 7) << 2 ^ Int(z * 31) >> 2;
    }

    public mutating func Normalize ()
    {
        let num = Vector3.magnitude (self);
        if (num > 1E-05)
        {
            self.scale(1.0/num)
        }
        else
        {
            self = Vector3.zero;
        }
    }
//
    public mutating func scale (scale:Vector3)
    {
        x = x * scale.x;
        y = y * scale.y;
        z = z * scale.z;
    }
    public mutating func scale (scale:Float)
    {
        x = x * scale;
        y = y * scale;
        z = z * scale;
    }

    public mutating func set ( new_x:Float, new_y:Float,  new_z:Float)
    {
        x = new_x;
        y = new_y;
        z = new_z;
    }

    public var description:String{
        return "(\(x), \(y), \(z))"
    }

}


//
// Operators
//
func + ( a:Vector3,  b:Vector3)->Vector3{
    return Vector3 (a.x + b.x, a.y + b.y, a.z + b.z);
}

func / ( a:Vector3,  d:Float)->Vector3{
    return Vector3 (a.x / d, a.y / d, a.z / d);
}
public func == ( lhs:Vector3,  rhs:Vector3)->Bool{
    return Vector3.sqrMagnitude (lhs - rhs) < 9.99999944E-11;
}

func != ( lhs:Vector3,  rhs:Vector3)->Bool{
    return Vector3.sqrMagnitude (lhs - rhs) >= 9.99999944E-11;
}

func * (d:Float,  a:Vector3)->Vector3{
    return Vector3 (a.x * d, a.y * d, a.z * d);
}

func * ( a:Vector3,  d:Float)->Vector3{
    return Vector3 (a.x * d, a.y * d, a.z * d);
}

func - ( a:Vector3, b:Vector3 )->Vector3{
    return Vector3 (a.x - b.x, a.y - b.y, a.z - b.z);
}

prefix func - (a:Vector3 )->Vector3{
    return  Vector3 (-a.x, -a.y, -a.z);
}