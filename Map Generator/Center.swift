//
//  Center.swift
//  Map Generator
//
//  Created by Carl Wieland on 4/23/15.
//  Copyright (c) 2015 Carl Wieland. All rights reserved.
//

import Foundation
#if os(iOS)
    import DelaunayiOS
    #elseif os(OSX)
    import Delaunay
#endif

public class Center{
    public var index:Int = 0
    public var point:Point!
    public var water:Bool = false
    public var ocean:Bool = false
    public var coast:Bool = false
    public var boarder:Bool = false
    public var biome = Biome.Temperate
    public var elevation:Double = 0
    public var moisture:Double = 0
    
    public var neighbors = [Center]()
    public var borders = [Edge]()
    public var corners = [Corner]()
}