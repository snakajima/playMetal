//
//  MyRenderer.swift
//  playMetal
//
//  Created by SATOSHI NAKAJIMA on 9/29/20.
//

import Metal

class MyRenderer: NSObject {
    let device:MTLDevice
    let pixelFormat:MTLPixelFormat
    init(device:MTLDevice, pixelFormat:MTLPixelFormat) {
        self.device = device
        self.pixelFormat = pixelFormat
    }
}
