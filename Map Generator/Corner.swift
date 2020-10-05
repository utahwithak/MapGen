//
//  Corner.swift
//  Map Generator
//
//  Created by Carl Wieland on 4/23/15.
//  Copyright (c) 2015 Carl Wieland. All rights reserved.
//

import Foundation
import Delaunay

public final class Corner {
    final var index: Int = 0
    
    final var point: Point!  // location
    final var ocean = false  // ocean
    final var water = false  // lake or ocean
    final var coast = false  // touches ocean and land polygons
    final var border = false  // at the edge of the map
    final var elevation: Double = 0  // 0.0-1.0
    final var moisture: Double = 0  // 0.0-1.0
    
    final var touches = [Center]()
    final var protrudes = [Edge]()
    final var adjacent = [Corner]()
    
    final var river: Int = 0  // 0 if no river, or volume of water in river
    final var downslope: Corner!  // pointer to adjacent corner most downhill
    final var watershed: Corner!  // pointer to coastal corner, or null
    final var watershed_size: Int = 0

}
