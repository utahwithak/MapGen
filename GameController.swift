//
//  GameController.swift
//  Map Generator
//
//  Created by v.prusakov on 10/5/20.
//  Copyright © 2020 Carl Wieland. All rights reserved.
//

import SceneKit
import ConvexHull

class GameController {
    
    let scene: SCNScene
    let sceneRenderer: SCNSceneRenderer
    
    init(scnView: SCNView, map: Map) {
        // create a new scene
        let scene = SCNScene()
        self.scene = scene
        
        let mapNode = SCNNode()
        let elevationScale = 2.0;
        for c in map.centers {
            var points = [Vector3]()
            if c.elevation.isNormal {
                points.append(Vector3(c.point.x, c.point.y, c.elevation * elevationScale))
            }
            for edge in c.borders {
                if  let v0 = edge.v0 , let v1 = edge.v1{
                    if v1.elevation.isNaN || v0.elevation.isNaN || v1.elevation.isInfinite || v0.elevation.isInfinite {
                        continue;
                    }
                    let vec1 = Vector3(v0.point.x, v0.point.y, v0.elevation * elevationScale)
                    let vec2 =  Vector3(v1.point.x, v1.point.y, v1.elevation * elevationScale)
                    
                    if vec1.z.isNaN || vec2.z.isNaN {
                        continue;
                    }
                    
                    points.append(vec1)
                    points.append(vec2)
                }
                
            }
            let filtered = points.filter{ $0.z != 0 && $0.z.isNormal }
            
            if filtered.count > 4 {
                let iscosphere = MeshUtils.convexHullOfPoints(points)
                mapNode.addChildNode(iscosphere)
            }
        }
        scene.rootNode.addChildNode(mapNode)
        
        let sphere = SCNNode()
        sphere.geometry = SCNSphere(radius: 1)
        sphere.simdPosition = .zero
        let mat = SCNMaterial()
        mat.diffuse.contents = SCNColor.red
        sphere.geometry!.materials = [mat]
        scene.rootNode.addChildNode(sphere)
        
        // set the scene to the view
        scnView.scene = scene
        
        scnView.isPlaying = true
        scnView.loops = true
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        scnView.autoenablesDefaultLighting = true
        
        scnView.debugOptions = [.showWireframe]
        
        
        // configure the view
        scnView.backgroundColor = SCNColor.black.withAlphaComponent(0.3)
        
        self.sceneRenderer = scnView
    }
}
