//
//  MyCircle.swift
//  playMetal
//
//  Created by SATOSHI NAKAJIMA on 9/30/20.
//

import Foundation
import Metal

class MyCircle : MyRendererDelegate {
    var metalRenderPipelineState: MTLRenderPipelineState? = nil
    
    func prepare(device:MTLDevice, pixelFormat:MTLPixelFormat) {
        self.metalRenderPipelineState = MyRenderer.createPipelineState(device: device, pixelFormat: pixelFormat, vertex:"vertexShader", fragment:"fragmentShader")
    }
}
