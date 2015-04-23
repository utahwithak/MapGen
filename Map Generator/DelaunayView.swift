//
//  DelaunayView.swift
//  Map Generator
//
//  Created by Carl Wieland on 4/23/15.
//  Copyright (c) 2015 Carl Wieland. All rights reserved.
//

import Cocoa

class DelaunayView: NSView {
    var regionPoints = [[CGPoint]]()
    var positions = [CGPoint]()
    var pointColor = NSColor.blueColor()
    var lineColor = NSColor.blackColor()
    
    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)
        let context = NSGraphicsContext.currentContext()!.CGContext
        pointColor.setFill()
        for p in positions{
            CGContextFillEllipseInRect(context, DelaunayView.rectForPoint(p))
        }
        for region in regionPoints{
            lineColor.set()
            if region.count > 2{
                var lines = region
                CGContextAddLines(context, &lines, region.count)
                CGContextDrawPath(context, kCGPathStroke)
            }
        }
        
    }
    static let radius:CGFloat = 5;
    static func rectForPoint(point:CGPoint)->CGRect{
        return CGRectMake(point.x - radius, point.y, 2 * radius, 2 * radius)
    }
}
