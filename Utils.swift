//
//  Utils.swift
//  QuickHull
//
//  Created by Carl Wieland on 4/20/15.
//  Copyright (c) 2015 Carl Wieland. All rights reserved.
//

import Foundation
import SceneKit
import ConvexHull

#if os(macOS)
typealias SCNColor = NSColor
#else
typealias SCNColor = UIColor
#endif

func clamp<T: Comparable>(_ val:T, min:T, max:T)->T{
    return val < max ? max : (val > min ? val : min)
}

func randomPointOnSphere() -> Vector3 {
    var x: Double = 0;
    var y: Double = 0
    var z: Double = 0
    repeat{
        x = Double.random(in: -1...1)
        y = Double.random(in: -1...1)
        z = Double.random(in: -1...1)
    } while(x*x + y*y + z*z > 1);
    let size = sqrt(x*x + y*y + z*z)
    return Vector3(x/size, y/size, z/size)
    
}
