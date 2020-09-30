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
    var circleVertices = [simd_float2]()
    var vertexBuffer:MTLBuffer!
    
    init(device:MTLDevice, pixelFormat:MTLPixelFormat) {
        self.device = device
        self.pixelFormat = pixelFormat
        self.commandQueue = device.makeCommandQueue()
        super.init()
        createVertexPoints()
        vertexBuffer = device.makeBuffer(bytes: circleVertices, length: circleVertices.count * MemoryLayout<simd_float2>.stride, options: [])!
    }
    
    private func createVertexPoints() {
        func rads(forDegree d: Float)->Float32{
            return (Float.pi*d)/180
        }

        for i in 0...720 {
            let position : simd_float2 = [cos(rads(forDegree: Float(Float(i)/2.0))),sin(rads(forDegree: Float(Float(i)/2.0)))]
            circleVertices.append(position)
        }
        
    }
}

extension MyRenderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        print("sizeWillChange")
    }
    
    func draw(in view: MTKView) {
        guard let commandQueue = self.commandQueue,
              let commandBuffer = commandQueue.makeCommandBuffer() else {
            print("no commandQueu or commandBuffer")
            return
        }

        guard let drawable = view.currentDrawable else {
            print("no drawable")
            return
        }
        
        guard let shaderLib = device.makeDefaultLibrary() else {
            print("no shderLib")
            return
        }
        
        guard let vertexShader = shaderLib.makeFunction(name: "vertexShader") else {
            print("no vertexShader")
            return
        }
        
        guard let fragmentShader = shaderLib.makeFunction(name: "fragmentShader") else {
            print("no fragmentShader")
            return
        }
                
        guard let renderDescriptor = view.currentRenderPassDescriptor else {
            print("no renderDescriptor")
            return
        }
        renderDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0, 1, 0, 1)
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderDescriptor) else {
            print("no renderEncoder")
            return
        }
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()

        //give the names of the function to the pipelineDescriptor
        pipelineDescriptor.vertexFunction = vertexShader
        pipelineDescriptor.fragmentFunction = fragmentShader

        //set the pixel format to match the MetalView's pixel format
        pipelineDescriptor.colorAttachments[0].pixelFormat = pixelFormat

        //make the pipelinestate using the gpu interface and the pipelineDescriptor
        let metalRenderPipelineState = try! device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        renderEncoder.setRenderPipelineState(metalRenderPipelineState)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 1081)

        renderEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}

struct MyRenderer_Previews: PreviewProvider {
    static var previews: some View {
        MyMetalView()
    }
}
