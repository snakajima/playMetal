//
//  MyRenderer.swift
//  playMetal
//
//  Created by SATOSHI NAKAJIMA on 9/29/20.
//

import MetalKit

class MyRenderer: NSObject {
    let device:MTLDevice
    let pixelFormat:MTLPixelFormat
    init(device:MTLDevice, pixelFormat:MTLPixelFormat) {
        self.device = device
        self.pixelFormat = pixelFormat
    }
}

extension MyRenderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        print("sizeWillChange")
    }
    
    func draw(in view: MTKView) {
        print("draw")
    }
}
