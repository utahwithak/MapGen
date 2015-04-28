//
//  MeshUtils.swift
//  QuickHull
//
//  Created by Carl Wieland on 4/20/15.
//  Copyright (c) 2015 Carl Wieland. All rights reserved.
//

import Foundation
import SceneKit
import QHull

class MeshUtils{
    
    static func convexHullOfPoints(points:[Vector3])->SCNNode{
        var p3s = [Point3d]();
        for p in points{
            p3s.append(p.toPoint3d())
        }
        
        var hull = QuickHull3D();
        hull.build (p3s);
        hull.triangulate()
//        println ("Vertices:");
        let vertices = hull.getVertices()
//        for i in 0..<vertices.count{
//            let pnt = vertices[i];
//            println("\(pnt.x) \(pnt.y) \(pnt.z)");
//        }
        
        
        var triangles = [CInt]();
        var verts = [Vertex]()

        let faceIndices = hull.getFaces();
        
        var cur:CInt = 0;
        for i in 0..<faceIndices.count{
            assert(faceIndices[i].count == 3, "INVAID TRIANGLE!")
            let normal = hull.normalOfFace(i).toVector3() ;
            for k in 0..<faceIndices[i].count
            {
                let position = vertices[faceIndices[i][k]].toVector3();

                
                let vert = Vertex(position:position,normal:normal, color:Vector3(0.5,0.5,0.5))
                verts.append(vert)
            }
            triangles.append(cur + 2)
            triangles.append(cur + 1)
            triangles.append(cur + 0)
            cur += 3
        }

        
        
        
        let node = SCNNode()
        let geometry = createGeometry(verts, triangles)
//        let material = SCNMaterial()
//        material.diffuse.contents = UIColor(red:0, green:0.55, blue:0.84, alpha:1)
//        geometry.materials = [material]
        node.geometry = geometry
        
        
        return node
    }
    
}

//
//var vertices: [Vertex] = [ /* ... vertex data ... */ ]
func createGeometry(vertices:[Vertex], triangles:[CInt])->SCNGeometry{
    let data = NSData(bytes: vertices, length: vertices.count * sizeof(Vertex))
    
    let vertexSource = SCNGeometrySource(data: data,
        semantic: SCNGeometrySourceSemanticVertex,
        vectorCount: vertices.count,
        floatComponents: true,
        componentsPerVector: 3,
        bytesPerComponent: sizeof(Float),
        dataOffset: 0, // position is first member in Vertex
        dataStride: sizeof(Vertex))
    
    let normalSource = SCNGeometrySource(data: data,
        semantic: SCNGeometrySourceSemanticNormal,
        vectorCount: vertices.count,
        floatComponents: true,
        componentsPerVector: 3,
        bytesPerComponent: sizeof(Float),
        dataOffset: sizeof(Vector3), // one Float3 before normal in Vertex
        dataStride: sizeof(Vertex))
    
    
    let colorSource = SCNGeometrySource(data: data,
        semantic: SCNGeometrySourceSemanticColor,
        vectorCount: vertices.count,
        floatComponents: true,
        componentsPerVector: 3,
        bytesPerComponent: sizeof(Float),
        dataOffset: 2 * sizeof(Vector3) , // 2 Float3s before tcoord in Vertex
        dataStride: sizeof(Vertex))
    
    let triData = NSData(bytes: triangles, length: sizeof(CInt)*triangles.count)
    
    let geometryElement = SCNGeometryElement(data: triData, primitiveType: .Triangles , primitiveCount:vertices.count/3 , bytesPerIndex: sizeof(CInt))
    
    return SCNGeometry(sources: [vertexSource,normalSource,colorSource], elements: [geometryElement])
}


extension Vector3d{
    func toVector3()->Vector3{
        return Vector3(Float(x),Float(y),Float(z))
    }
}

extension Vector3{
    func toPoint3d()->Point3d{
        return Point3d(x: Double(x), y: Double(y), z: Double(z))
    }
}