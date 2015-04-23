//
//  CGPointUtils.swift
//  Map Generator
//
//  Created by Carl Wieland on 4/21/15.
//  Copyright (c) 2015 Carl Wieland. All rights reserved.
//

import Foundation
extension Point :Hashable{
    static func distance( lhs:Point, _ rhs:Point)->Double{
        let dx = lhs.x - rhs.x;
        let dy = lhs.y - rhs.y;
        return sqrt((dx * dx) + (dy * dy))
    }
    
    public var hashValue : Int {
        get {
            return "\(self.x),\(self.y)".hashValue
        }
    }
}
public func ==(lhs: Point, rhs: Point) -> Bool {
    return lhs.hashValue == rhs.hashValue
}
