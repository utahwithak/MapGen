//
//  MeshUtils.swift
//  QuickHull
//
//  Created by Carl Wieland on 4/20/15.
//  Copyright (c) 2015 Carl Wieland. All rights reserved.
//

import Foundation
import SceneKit
import ConvexHull

class MeshUtils {
    
    static func convexHullOfPoints(_ points: [Vector3]) -> SCNNode {
        let hull = ConvexHull.create(with: points, planeDistanceTolerance: 2)
        
        var triangles = [Int32]()
        var verts = [Vertex]()

        let faceIndices = hull.faces
        
        var cur: Int32 = 0;
        for i in 0..<faceIndices.count {
            assert(faceIndices[i].vertices.count == 3, "INVAID TRIANGLE!")
            
            let normal = faceIndices[i].normal
            for k in 0..<faceIndices[i].vertices.count {
                let position = faceIndices[i].vertices[k]
                
                let vert = Vertex(position: position, normal: normal, color: Vector3(1,1,1))
                verts.append(vert)
            }
            triangles.append(cur + 0)
            triangles.append(cur + 1)
            triangles.append(cur + 2)
            cur += 3
        }
        
        let node = SCNNode()
        let geometry = createGeometry(verts, triangles: triangles)
        node.geometry = geometry
        
        return node
    }
    
}

extension Vector3 {
    var simdVector: simd_float3 {
        simd_float3(x: Float(self.x), y: Float(self.y), z: Float(self.z))
    }
}

//
//var vertices: [Vertex] = [ /* ... vertex data ... */ ]
func createGeometry(_ vertices: [Vertex], triangles:[Int32]) -> SCNGeometry {
    let vertexSource = SCNGeometrySource(vertices: vertices.map { SCNVector3($0.position.simdVector) })
    
    let normalSource = SCNGeometrySource(normals: vertices.map { SCNVector3($0.normal.simdVector) })
    
    let colors = vertices.map { SCNVector3($0.color.simdVector) }
    let colorData = Data(bytes: colors, count: MemoryLayout<SCNVector3>.size * colors.count)
    let colorSource = SCNGeometrySource(data: colorData, semantic: .color, vectorCount: colors.count, usesFloatComponents: true, componentsPerVector: 3, bytesPerComponent: MemoryLayout<CGFloat>.size, dataOffset: 0, dataStride: MemoryLayout<SCNVector3>.size)
    
    let triData = Data(bytes: triangles, count: MemoryLayout<Int32>.size*triangles.count)
    
    let geometryElement = SCNGeometryElement(data: triData, primitiveType: .triangles, primitiveCount:vertices.count / 3 , bytesPerIndex: MemoryLayout<Int32>.size)
    
    return SCNGeometry(sources: [vertexSource, normalSource, colorSource], elements: [geometryElement])
}
