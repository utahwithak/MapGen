//
//  Utils.swift
//  QuickHull
//
//  Created by Carl Wieland on 4/20/15.
//  Copyright (c) 2015 Carl Wieland. All rights reserved.
//

import Foundation
func clamp<T:Comparable>(val:T, min:T, max:T)->T{
    return val < max ? max : (val > min ? val : min)
}

func randomPointOnSphere()->Vector3{
    var x:Float = 0;
    var y:Float = 0
    var z:Float = 0
    do{
        x = Float.random(min:-1,max:1)
        y = Float.random(min:-1,max:1)
        z = Float.random(min:-1,max:1)
    }while(x*x + y*y + z*z > 1);
    let size = sqrt(x*x + y*y + z*z)
    return Vector3(x/size,y/size,z/size)
    
}
public extension Double {
    /**
    Returns a random floating point number between 0.0 and 1.0, inclusive.
    By DaRkDOG
    */
    public static func random() -> Double {
        return Double(arc4random()) / 0xFFFFFFFF
    }
    
    /**
    Create a random num Double
    :param: lower number Double
    :param: upper number Double
    :return: random number Double
    By DaRkDOG
    */
    public static func random(#min: Double, max: Double) -> Double {
        return Double.random() * (max - min) + min
    }
}
public extension Float {
    /**
    Returns a random floating point number between 0.0 and 1.0, inclusive.
    By DaRkDOG
    */
    public static func random() -> Float {
        return Float(arc4random()) / 0xFFFFFFFF
    }
    /**
    Create a random num Float
    :param: lower number Float
    :param: upper number Float
    :return: random number Float
    By DaRkDOG
    */
    public static func random(#min: Float, max: Float) -> Float {
        return Float.random() * (max - min) + min
    }
}