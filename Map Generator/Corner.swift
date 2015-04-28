//
//  Corner.swift
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

public class Corner{
    public var index:Int = 0;
    
    public var point:Point!;  // location
    public var ocean = false;  // ocean
    public var water = false;  // lake or ocean
    public var coast = false;  // touches ocean and land polygons
    public var border = false;  // at the edge of the map
    public var elevation:Double = 0;  // 0.0-1.0
    public var moisture:Double = 0;  // 0.0-1.0
    
    public var touches = [Center]();
    public var protrudes = [Edge]();
    public var adjacent = [Corner]();
    
    public var river:Int = 0;  // 0 if no river, or volume of water in river
    public var downslope:Corner!;  // pointer to adjacent corner most downhill
    public var watershed:Corner!;  // pointer to coastal corner, or null
    public var watershed_size:Int = 0;

}