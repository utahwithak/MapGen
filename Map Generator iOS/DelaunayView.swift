//
//  DelaunayView.swift
//  Map Generator
//
//  Created by Carl Wieland on 4/23/15.
//  Copyright (c) 2015 Carl Wieland. All rights reserved.
//

import UIKit

class DelaunayView: UIView {
    var regionPoints = [[CGPoint]]()
    var positions = [CGPoint]()
    var triangles = [[CGPoint]]()
    
    var pointColor = UIColor.blueColor()
    var lineColor = UIColor.blackColor()
    
    var triColor = UIColor.redColor()
    
    override func drawRect(dirtyRect: CGRect) {
        super.drawRect(dirtyRect)
        let context = UIGraphicsGetCurrentContext()
        pointColor.setFill()
        for p in positions{
            CGContextFillEllipseInRect(context, DelaunayView.rectForPoint(p))
        }
        lineColor.set()
        for region in regionPoints{
            if region.count == 2{
                var lines = region
                CGContextMoveToPoint(context, lines[0].x, lines[0].y)
                CGContextAddLineToPoint(context, lines[1].x, lines[1].y)
                CGContextDrawPath(context, kCGPathStroke)
            }
        }
  
    }
    static let radius:CGFloat = 3;
    static func rectForPoint(point:CGPoint)->CGRect{
        return CGRectMake(point.x - radius, point.y - radius, 2 * radius, 2 * radius)
    }
}
