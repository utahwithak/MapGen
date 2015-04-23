//
//  Point.swift
//  Map Generator
//
//  Created by Carl Wieland on 4/22/15.
//  Copyright (c) 2015 Carl Wieland. All rights reserved.
//

import Foundation
public class Point{
    static let zeroPoint = Point(x: 0, y: 0)
    public var x:Double
    public var y:Double
    public init(x:Double, y:Double){
        self.x = x;
        self.y = y
    }
}