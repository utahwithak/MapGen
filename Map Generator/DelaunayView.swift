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
    var pointColor = NSColor.blue
    var lineColor = NSColor.black
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let context = NSGraphicsContext.current()!.cgContext
        pointColor.setFill()
        for p in positions{
            context.fillEllipse(in: DelaunayView.rectForPoint(p))
        }
        for region in regionPoints{
            lineColor.set()
            if region.count > 2{
                context.addLines(between: region)
                context.drawPath(using: .stroke)
            }
        }
        
    }
    static let radius:CGFloat = 5;
    static func rectForPoint(_ point:CGPoint)->CGRect{
        return CGRect(x: point.x - radius, y: point.y, width: 2 * radius, height: 2 * radius)
    }
}
