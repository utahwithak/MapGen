//
//  Edge.swift
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

public class Edge {
    public var index:Int = 0;
    public var d0:Center!, d1:Center!;  // Delaunay edge
    public var v0:Corner!, v1:Corner!;  // Voronoi edge
    public var midpoint:Point!;  // halfway between v0,v1
    public var river:Int = 0;  // volume of water, or 0
}