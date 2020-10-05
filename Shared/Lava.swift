//
//  Lava.swift
//  Map Generator
//
//  Created by Carl Wieland on 4/27/15.
//  Copyright (c) 2015 Carl Wieland. All rights reserved.
//

import Foundation
import Delaunay

class Lava {
    static let kLavaProbability = 0.2
    var lava = [Int:Bool]()
    
    func createLava(_ map: Map, randomDouble: () -> Double) {
        for edge in map.edges {
            if edge.river != 0 && edge.d0.water && edge.d1.water
                && edge.d0.elevation > 0.8 && edge.d1.elevation > 0.8
                && edge.d0.moisture < 0.3 && edge.d1.moisture < 0.3
                && randomDouble() < Lava.kLavaProbability {
                    lava[edge.index] = true
            }
        }
    }
}
