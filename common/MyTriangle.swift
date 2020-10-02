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
    func getVertex(device: MTLDevice) -> (buffer: MTLBuffer, count: Int)? {
        let time = Float(CACurrentMediaTime() * .pi)
        var vertices:[simd_float2] = [
            simd_float2(0,0),
            simd_float2(sinf(time),cosf(time)),
            simd_float2(-cosf(time),sinf(time)),
            simd_float2(-sinf(time),-cosf(time)),
            simd_float2(cosf(time),-sinf(time)),
            simd_float2(sinf(time),cosf(time))
        ]
            
        vertices.append(vertices[0])
        if let buffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<simd_float2>.stride, options: []) {
            return (buffer, vertices.count)
        } else {
            return nil
        }
    }
    
    func prepare(device:MTLDevice, pixelFormat:MTLPixelFormat) {
        self.metalRenderPipelineState = MyRenderer.createPipelineState(device: device, pixelFormat: pixelFormat, vertex:"vertexShader", fragment:"fragmentShader")
    }
}

struct MyTriangle_Previews: PreviewProvider {
    static var previews: some View {
        MyMetalView(shader:MyTriangle())
    }
}
