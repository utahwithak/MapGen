//
//  ViewController.swift
//  Map Generator iOS
//
//  Created by Carl Wieland on 4/23/15.
//  Copyright (c) 2015 Carl Wieland. All rights reserved.
//

import UIKit
import DelaunayiOS
class ViewController: UIViewController,UIScrollViewDelegate {
    @IBOutlet var scrollView:UIScrollView!
    var voronoiView:DelaunayView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let map = Map(size: 2048, numPoints: 1000, varient: random())
        map.buildMap()

        self.voronoiView = DelaunayView(frame: CGRectMake(0, 0, 2048, 2048))
        self.voronoiView.backgroundColor = UIColor.clearColor()
        
        self.scrollView.addSubview(self.voronoiView)
        self.scrollView.maximumZoomScale = 10
        self.scrollView.minimumZoomScale = 0.01
        self.scrollView.delegate = self
        
        func converter(p:Point)->CGPoint{
            return CGPoint(x: p.x, y: p.y)
        }
        func cornerConverter(e:Corner)->CGPoint{
            return converter(e.point)
        }
        
        for c in map.centers {
            self.voronoiView.positions.append(converter(c.point))

            for edge in c.borders{
              
                if edge.v0 != nil && edge.v1 != nil{
                    var borders = [CGPoint]()
                    borders.append(converter(edge.v0.point))
                    borders.append(converter(edge.v1.point))
                    self.voronoiView.regionPoints.append(borders)
                }


            }
//            let region = voronoi.region(p);
        }

//        func siteToPoint(site:Site)->CGPoint{
//            return CGPoint(x:site.coord.x,y:site.coord.y)
//        }
//        for triangle in voronoi.triangles{
//            let points = triangle.sites.map(siteToPoint)
//            self.voronoiView.triangles.append(points)
//            
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.voronoiView
    }

}

