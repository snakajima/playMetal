//
//  MyRenderer.swift
//  playMetal
//
//  Created by SATOSHI NAKAJIMA on 9/29/20.
//

import MetalKit

class MyRenderer: NSObject {
    let device:MTLDevice
    let commandQueue:MTLCommandQueue?
    let pixelFormat:MTLPixelFormat
    init(device:MTLDevice, pixelFormat:MTLPixelFormat) {
        self.device = device
        self.pixelFormat = pixelFormat
        self.commandQueue = device.makeCommandQueue()
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
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
