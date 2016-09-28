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
    var map:Map!
    override func viewDidLoad() {
        super.viewDidLoad()
        let size = 1000
        self.map = Map(size:size, numPoints: size ,seed:1, varient: 1)
        map.buildMap()
        arc4random_stir()
        self.voronoiView = DelaunayView(frame: CGRect(x: 0, y: 0, width: CGFloat(size), height: CGFloat(size)))
        self.voronoiView.backgroundColor = UIColor.clear
        
        self.scrollView.addSubview(self.voronoiView)
        self.scrollView.maximumZoomScale = 10
        self.scrollView.minimumZoomScale = 0.01
        self.scrollView.delegate = self
        
        func converter(_ p:Point)->CGPoint{
            return CGPoint(x: p.x, y: p.y)
        }
        func cornerConverter(_ e:Corner)->CGPoint{
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let dest = segue.destination as? GameViewController{
            dest.map = self.map
        }
        
    }
    


    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.voronoiView
    }

}

