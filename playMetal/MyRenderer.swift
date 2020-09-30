//
//  MyRenderer.swift
//  playMetal
//
//  Created by SATOSHI NAKAJIMA on 9/29/20.
//

import MetalKit
import simd
import SwiftUI // only for preview

class MyRenderer: NSObject {
    let device:MTLDevice
    let commandQueue:MTLCommandQueue?
    let pixelFormat:MTLPixelFormat
    let vertexBuffer:MTLBuffer
    var metalRenderPipelineState:MTLRenderPipelineState?
    
    init(device:MTLDevice, pixelFormat:MTLPixelFormat) {
        self.device = device
        self.pixelFormat = pixelFormat
        self.commandQueue = device.makeCommandQueue()
        self.vertexBuffer = MyRenderer.createVertexBuffer(device:device)
        self.metalRenderPipelineState = MyRenderer.createPipelineState(device: device, pixelFormat: pixelFormat)
    }
    
    static private func createVertexBuffer(device:MTLDevice) ->MTLBuffer {
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
        
        return device.makeBuffer(bytes: vertices, length: vertices.count * MemoryLayout<simd_float2>.stride, options: [])!
    }
    
    static private func createPipelineState(device:MTLDevice, pixelFormat:MTLPixelFormat) -> MTLRenderPipelineState? {
        guard let shaderLib = device.makeDefaultLibrary(),
              let vertexShader = shaderLib.makeFunction(name: "vertexShader"),
              let fragmentShader = shaderLib.makeFunction(name: "fragmentShader")else {
            print("no shader")
            return nil
        }

        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexShader
        pipelineDescriptor.fragmentFunction = fragmentShader
        pipelineDescriptor.colorAttachments[0].pixelFormat = pixelFormat
        return try! device.makeRenderPipelineState(descriptor: pipelineDescriptor)
      }
}

extension MyRenderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        print("sizeWillChange")
    }
    
    func draw(in view: MTKView) {
        guard let commandQueue = self.commandQueue,
              let commandBuffer = commandQueue.makeCommandBuffer(),
              let metalRenderPipelineState = self.metalRenderPipelineState,
              let renderDescriptor = view.currentRenderPassDescriptor else {
            print("no commandQueu, commandBuffer, drawable, metalRenderPipelineState")
            return
        }
        
        if let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderDescriptor) {
            renderEncoder.setRenderPipelineState(metalRenderPipelineState)
            renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
            renderEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 1081)
            renderEncoder.endEncoding()
        }

        if let drawable = view.currentDrawable {
            commandBuffer.present(drawable)
        }
        commandBuffer.commit()
    }
}

struct MyRenderer_Previews: PreviewProvider {
    static var previews: some View {
        MyMetalView()
    }
}
