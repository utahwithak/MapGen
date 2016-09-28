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

open class Edge {
    open var index:Int = 0;
    open var d0:Center!, d1:Center!;  // Delaunay edge
    open var v0:Corner!, v1:Corner!;  // Voronoi edge
    open var midpoint:Point!;  // halfway between v0,v1
    open var river:Int = 0;  // volume of water, or 0
}
