//
//  Center.swift
//  Map Generator
//
//  Created by Carl Wieland on 4/23/15.
//  Copyright (c) 2015 Carl Wieland. All rights reserved.
//

import Foundation
import Delaunay

open class Center {
    open var index: Int = 0
    open var point: Point!
    open var water: Bool = false
    open var ocean: Bool = false
    open var coast: Bool = false
    open var border: Bool = false
    open var biome = Biome.grassland
    open var elevation: Double = 0
    open var moisture: Double = 0
    
    open var neighbors = [Center]()
    open var borders = [Edge]()
    open var corners = [Corner]()
}
