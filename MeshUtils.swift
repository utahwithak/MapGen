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
    
    static func convexHullOfPoints(_ points:[Vector3])->SCNNode{
        var p3s = [Point3d]();
        for p in points{
            p3s.append(p.toPoint3d())
        }
        
        let hull = QuickHull3D();
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

            let normal = hull.normalOfFace(i).toVector3().normalized;
            for k in 0..<faceIndices[i].count
            {
                let position = vertices[faceIndices[i][k]].toVector3();

                
                let vert = Vertex(position:position,normal:normal, color:Vector3(0.5,0.5,0.5))
                verts.append(vert)
            }
            triangles.append(cur + 0)
            triangles.append(cur + 1)
            triangles.append(cur + 2)
            cur += 3
        }

        
        
        
        let node = SCNNode()
        let geometry = createGeometry(verts, triangles: triangles)
//        let material = SCNMaterial()
//        material.diffuse.contents = UIColor(red:0, green:0.55, blue:0.84, alpha:1)
//        geometry.materials = [material]
        node.geometry = geometry
        
        
        return node
    }
    
}

//
//var vertices: [Vertex] = [ /* ... vertex data ... */ ]
func createGeometry(_ vertices:[Vertex], triangles:[CInt])->SCNGeometry{
    let data = Data(bytes: vertices, count: vertices.count * MemoryLayout<Vertex>.size)
    let vertexSource = SCNGeometrySource(data: data,
        semantic: SCNGeometrySource.Semantic.vertex,
        vectorCount: vertices.count,
        usesFloatComponents: true,
        componentsPerVector: 3,
        bytesPerComponent: MemoryLayout<Float>.size,
        dataOffset: 0, // position is first member in Vertex
        dataStride: MemoryLayout<Vertex>.size)
    
    let normalSource = SCNGeometrySource(data: data,
        semantic: SCNGeometrySource.Semantic.normal,
        vectorCount: vertices.count,
        usesFloatComponents: true,
        componentsPerVector: 3,
        bytesPerComponent: MemoryLayout<Float>.size,
        dataOffset: MemoryLayout<Vector3>.size, // one Float3 before normal in Vertex
        dataStride: MemoryLayout<Vertex>.size)
    
    
    let colorSource = SCNGeometrySource(data: data,
        semantic: SCNGeometrySource.Semantic.color,
        vectorCount: vertices.count,
        usesFloatComponents: true,
        componentsPerVector: 3,
        bytesPerComponent: MemoryLayout<Float>.size,
        dataOffset: 2 * MemoryLayout<Vector3>.size , // 2 Float3s before tcoord in Vertex
        dataStride: MemoryLayout<Vertex>.size)
    
    let triData = Data(bytes: triangles, count: MemoryLayout<CInt>.size*triangles.count)
    
    let geometryElement = SCNGeometryElement(data: triData, primitiveType: .triangles , primitiveCount:vertices.count/3 , bytesPerIndex: MemoryLayout<CInt>.size)
    
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
