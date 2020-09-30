//
//  MyRenderer.swift
//  playMetal
//
//  Created by SATOSHI NAKAJIMA on 9/29/20.
//

import MetalKit
import simd
import SwiftUI // only for preview

protocol MyRendererDelegate {
    var metalRenderPipelineState:MTLRenderPipelineState? { get }
    var vertexBuffer:MTLBuffer? { get }
    var vertexCount:Int { get }

    func prepare(device:MTLDevice, pixelFormat:MTLPixelFormat)
}

class MyRenderer: NSObject {
    let device:MTLDevice
    let pixelFormat:MTLPixelFormat
    let commandQueue:MTLCommandQueue?
    let delegate:MyRendererDelegate
    
    init(device:MTLDevice, pixelFormat:MTLPixelFormat, delegate:MyRendererDelegate) {
        self.device = device
        self.pixelFormat = pixelFormat
        self.delegate = delegate
        delegate.prepare(device: device, pixelFormat: pixelFormat)
        self.commandQueue = device.makeCommandQueue()
    }
    
    static func createPipelineState(device:MTLDevice, pixelFormat:MTLPixelFormat,
                                            vertex:String, fragment:String) -> MTLRenderPipelineState? {
        guard let shaderLib = device.makeDefaultLibrary(),
              let vertexShader = shaderLib.makeFunction(name: vertex),
              let fragmentShader = shaderLib.makeFunction(name: fragment)else {
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
    }
    
    func draw(in view: MTKView) {
        guard let commandQueue = self.commandQueue,
              let commandBuffer = commandQueue.makeCommandBuffer(),
              let metalRenderPipelineState = delegate.metalRenderPipelineState else {
            print("no commandQueu, commandBuffer, metalRenderPipelineState")
            return
        }
        
        if let renderDescriptor = view.currentRenderPassDescriptor,
           let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderDescriptor),
           let vertexBuffer = delegate.vertexBuffer {
            renderEncoder.setRenderPipelineState(metalRenderPipelineState)
            renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
            renderEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: delegate.vertexCount)
            renderEncoder.endEncoding()
            if let drawable = view.currentDrawable {
                commandBuffer.present(drawable)
            }
        }

        commandBuffer.commit()
    }
}

struct MyRenderer_Previews: PreviewProvider {
    static var previews: some View {
        MyMetalView(shader:MyCircle())
    }
}
