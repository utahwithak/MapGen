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
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = SCNLightTypeAmbient
        ambientLightNode.light!.color = UIColor.lightGrayColor()
        scene.rootNode.addChildNode(ambientLightNode)

        let mapNode = SCNNode()
        let elevationScale = 10.0;
        for c in map.centers {
            var points = [Vector3]()
            points.append(Vector3(Float(c.point.x), Float(c.point.y), Float(c.elevation * elevationScale)))
            for edge in c.borders{                
                if edge.v0 != nil && edge.v1 != nil{
                    points.append(Vector3(Float(edge.v0.point.x), Float(edge.v0.point.y), Float(edge.v0.elevation * elevationScale)))
                    points.append(Vector3(Float(edge.v1.point.x), Float(edge.v1.point.y), Float(edge.v1.elevation * elevationScale)))
                }
                
                
            }
            let filtered = points.filter{$0.z != 0 && $0.z.isNormal}
            if filtered.count != 0{
                let iscosphere = MeshUtils.convexHullOfPoints(points)
                mapNode.addChildNode(iscosphere)
            }
            //            let region = voronoi.region(p);
        }
        scene.rootNode.addChildNode(mapNode)
        
        
        

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
        if let camera = scene.rootNode.camera{
            camera.automaticallyAdjustsZRange = true
        }
        // show statistics such as fps and timing information
        self.gameView!.showsStatistics = true
        gameView.autoenablesDefaultLighting = true


        // configure the view
        self.gameView!.backgroundColor = UIColor.whiteColor()
        
       
    }

}
