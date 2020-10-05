//
//  ViewController.swift
//  Map Generator
//
//  Created by Carl Wieland on 4/23/15.
//  Copyright (c) 2015 Carl Wieland. All rights reserved.
//

import Cocoa
import Delaunay
import ConvexHull

class ViewController: NSViewController {
    
    @IBOutlet weak var stackView: NSStackView!
    @IBOutlet weak var scrollView: NSScrollView!
    var voronoiView: DelaunayView!
    var map: Map!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.voronoiView = DelaunayView(frame: CGRect(x: 0, y: 0, width: 3000, height: 3000))
        self.scrollView.documentView = self.voronoiView
        
        self.generateMap()
    }

    func converter(_ p:Point)->CGPoint{
        return CGPoint(x: p.x, y: p.y)
    }
    
    private func generateMap() {
        self.map = nil
        self.voronoiView.positions = []
        self.voronoiView.regionPoints = []
        
        // Insert code here to initialize your application
        let size = 1000
        
        self.map = Map(size: size, numPoints: size, seed: Int.random(in: 0..<100), varient: 1)
        map.buildMap()
        
        for c in map.centers {
            self.voronoiView.positions.append(converter(c.point))

            for edge in c.borders {
              
                if edge.v0 != nil && edge.v1 != nil{
                    var borders = [CGPoint]()
                    borders.append(converter(edge.v0.point))
                    borders.append(converter(edge.v1.point))
                    self.voronoiView.regionPoints.append(borders)
                }
            }
        }
        
        self.voronoiView.setNeedsDisplay(self.voronoiView.bounds)
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        guard let vc = segue.destinationController as? GameViewController else { return }
        vc.map = map
    }
    
    
    // Generate points at random locations
    static func generateRandom(_ size:Int, seed:Int)->(_ numPoints:Int)->[Point] {
        func generator(_ numPoints:Int)->[Point] {
            let mapRandom = PM_PRNG();
            mapRandom.seed = UInt(seed)
            var points = [Point]();
            for _ in 0..<numPoints {
                let p = Point(x:Double(mapRandom.nextDoubleRange(10.0, max: Double(size)-10.0)),
                    y:Double(mapRandom.nextDoubleRange(10.0,max: Double(size)-10.0)));
                points.append(p);
            }
            return points;
        }
        return generator
    }
    
    @IBAction func onRefreshButtonPressed(_ sender: Any) {
        self.generateMap()
    }
    
    func generateRelaxed(_ size:Int, seed:Int)->(Int)->[Point]{
        func relaxedGenerator(_ numPoints:Int)->[Point]{

            var voronoi:Voronoi
            var region:[Point];
            let points = ViewController.generateRandom(size, seed: seed)(numPoints);
            for _ in 0..<10 {
                voronoi = Voronoi(points: points, colors: nil, plotBounds: Rectangle(x: 0, y: 0, width: size, height: size));
                for pIn in points {
                    let p = pIn
                    region = voronoi.region(p);
                    p.x = 0.0;
                    p.y = 0.0;
                    for q in region{
                        p.x += q.x;
                        p.y += q.y;
                    }
                    p.x /= Double(region.count);
                    p.y /= Double(region.count);
                    
                }
                voronoi.dispose();
            }
            return points;
        }
        return relaxedGenerator
    }
}
