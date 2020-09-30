//
//  MyCircle.swift
//  playMetal
//
//  Created by SATOSHI NAKAJIMA on 9/30/20.
//

import Foundation
import Metal
import simd

class MyCircle : MyRendererDelegate {
    var metalRenderPipelineState: MTLRenderPipelineState? = nil
    var vertexBuffer:MTLBuffer? = nil

    func prepare(device:MTLDevice, pixelFormat:MTLPixelFormat) {
        self.metalRenderPipelineState = MyRenderer.createPipelineState(device: device, pixelFormat: pixelFormat, vertex:"vertexShader", fragment:"fragmentShader")
        var vertices = Array(0..<360).map { (i) -> [simd_float2] in
            let rad0 = Float(i * 2) / 2.0 / 180 * .pi
            let rad1 = Float(i * 2 + 1) / 2.0 / 180 * .pi
            return [
                [cos(rad0), sin(rad0)],
                [cos(rad1), sin(rad1)],
                [0, 0]
            ]
        }.flatMap { $0 }
        vertices.append(vertices[0])
        
        self.vertexBuffer = device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<simd_float2>.stride, options: [])!
    }
}
