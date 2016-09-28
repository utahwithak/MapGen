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
    
    var pointColor = UIColor.blue
    var lineColor = UIColor.black
    
    var triColor = UIColor.red
    
    override func draw(_ dirtyRect: CGRect) {
        super.draw(dirtyRect)
        let context = UIGraphicsGetCurrentContext()
        pointColor.setFill()
        for p in positions{
            context!.fillEllipse(in: DelaunayView.rectForPoint(point: p))
        }
        lineColor.set()
        for region in regionPoints{
            if region.count == 2{
                var lines = region
                context?.move(to: lines[0])
                context?.addLine(to: lines[1])
                context?.drawPath(using: .stroke)

            }
        }
  
    }
    static let radius:CGFloat = 3;
    static func rectForPoint(point:CGPoint)->CGRect{
        return CGRect(x: point.x - radius, y: point.y - radius, width: 2 * radius, height: 2 * radius)
    }
}
