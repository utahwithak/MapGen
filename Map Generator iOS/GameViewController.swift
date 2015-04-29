//
//  GameViewController.swift
//  QuickHull
//
//  Created by Carl Wieland on 4/20/15.
//  Copyright (c) 2015 Carl Wieland. All rights reserved.
//

import SceneKit
import QuartzCore
import QHull

let NUMPOINTS = 64
let radius:Float = 5.0

class GameViewController: UIViewController {
    
    @IBOutlet weak var gameView: GameView!
    var map:Map!
    
    override func viewDidLoad() {
        // create a new scene
        let scene = SCNScene()

        
        
        let mapNode = SCNNode()
        let elevationScale = 2.0;
        for c in map.centers {
            var points = [Vector3]()
            if Float(c.elevation).isNormal{
                points.append(Vector3(Float(c.point.x), Float(c.point.y), Float(c.elevation * elevationScale)))
            }
            for edge in c.borders{
                if  let v0 = edge.v0 , let v1 = edge.v1{
                    if Float(v1.elevation).isNaN || Float(v0.elevation).isNaN || Float(v1.elevation).isInfinite || Float(v0.elevation).isInfinite{
                        continue;
                    }
                    let vec1 = Vector3(Float(v0.point.x), Float(v0.point.y), Float(v0.elevation * elevationScale))
                    let vec2 =  Vector3(Float(v1.point.x), Float(v1.point.y), Float(v1.elevation * elevationScale))
                    if vec1.z.isNaN || vec2.z.isNaN{
                        continue;
                    }
                    points.append(vec1)
                    points.append(vec2)
                }
                
                
            }
            let filtered = points.filter{$0.z != 0 && $0.z.isNormal}
            
            if filtered.count > 4{
                let iscosphere = MeshUtils.convexHullOfPoints(points)
                mapNode.addChildNode(iscosphere)
            }
            //            let region = voronoi.region(p);
        }
        scene.rootNode.addChildNode(mapNode)
        
        
        
        
//        var points = [Vector3]()
//        
//        
//        
//        for i in 0..<50{
//            points.append(randomPointOnSphere() * radius/2)
//        }
//        
//        
//        
//        let iscosphere = MeshUtils.convexHullOfPoints(points)
//        scene.rootNode.addChildNode(iscosphere)

        
        let sphere = SCNNode()
        sphere.geometry = SCNSphere(radius: 1)
        let mat = SCNMaterial()
        mat.diffuse.contents = UIColor.redColor()
        sphere.geometry!.materials = [mat]
        scene.rootNode.addChildNode(sphere);

//        // animate the 3d object
//        let animation = CABasicAnimation(keyPath: "rotation")
//        animation.toValue = NSValue(SCNVector4: SCNVector4(x: CGFloat(0), y: CGFloat(1), z: CGFloat(0), w: CGFloat(M_PI)*2))
//        animation.duration = 10
//        animation.repeatCount = MAXFLOAT //repeat forever
////        iscosphere.addAnimation(animation, forKey: nil)

        // set the scene to the view
        self.gameView!.scene = scene
        
        // allows the user to manipulate the camera
        self.gameView!.allowsCameraControl = true
//        if let camera = scene.rootNode.camera{
//            camera.automaticallyAdjustsZRange = true
//        }
        // show statistics such as fps and timing information
        self.gameView!.showsStatistics = true
        self.gameView.autoenablesDefaultLighting = true


        // configure the view
//        self.gameView!.backgroundColor = UIColor.whiteColor()
        
       
    }

}
