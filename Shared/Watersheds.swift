//
//  Watersheds.swift
//  Map Generator
//
//  Created by Carl Wieland on 4/27/15.
//  Copyright (c) 2015 Carl Wieland. All rights reserved.
//

import Foundation
#if os(iOS)
    import DelaunayiOS
    #elseif os(OSX)
    import Delaunay
#endif

class Watersheds{
    var lowestCorner = [Int:Int]();  // polygon index -> corner index
    var watersheds = [Int:Int]();  // polygon index -> corner index
    
    // We want to mark each polygon with the corner where water would
    // exit the island.
    func createWatersheds(map:Map){
        var p:Center, q:Corner, s:Corner;
    
    // Find the lowest corner of the polygon, and set that as the
    // exit point for rain falling on this polygon
        for p in map.centers {
            var s:Corner? = nil
            for q in p.corners{
                if (s == nil || q.elevation < s!.elevation) {
                    s = q;
                }
            }
            lowestCorner[p.index] = (s == nil) ? -1 : s!.index;
            watersheds[p.index] = (s == nil) ? -1 : (s!.watershed == nil) ? -1 : s!.watershed.index;
        }
    }
    
}