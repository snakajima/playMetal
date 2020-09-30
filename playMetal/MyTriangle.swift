//
//  MyTriangle.swift
//  playMetal
//
//  Created by SATOSHI NAKAJIMA on 9/30/20.
//
import Metal
import simd
import SwiftUI // preview

class MyTriangle: MyRendererDelegate {
    var metalRenderPipelineState: MTLRenderPipelineState? = nil
    var vertexBuffer:MTLBuffer? = nil
    var vertexCount = 0
    
    func prepare(device:MTLDevice, pixelFormat:MTLPixelFormat) {
        self.metalRenderPipelineState = MyRenderer.createPipelineState(device: device, pixelFormat: pixelFormat, vertex:"vertexShader", fragment:"fragmentShader")

        var vertices:[simd_float2] = [
            [0,0],
            [1,0],
            [0,1],
            [-1,0],
            [0,-1],
            [1,0]
        ]
        vertices.append(vertices[0])

        self.vertexCount = vertices.count
        self.vertexBuffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<simd_float2>.stride, options: [])!
    }
}

struct MyTriangle_Previews: PreviewProvider {
    static var previews: some View {
        MyMetalView(shader:MyTriangle())
    }
}
