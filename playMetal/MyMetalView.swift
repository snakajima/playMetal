//
//  MyMetalView.swift
//  playMetal
//
//  Created by SATOSHI NAKAJIMA on 9/29/20.
//

import SwiftUI
import MetalKit

struct MyMetalView: NSViewRepresentable {
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    public func makeNSView(context: Context) -> some NSView {
        return context.coordinator.makeNSView()
    }
    
    public func updateNSView(_ nsView: NSViewType, context: Context) {
        //
    }
    
    class Coordinator: NSObject, CALayerDelegate {
        let device = MTLCreateSystemDefaultDevice()! // LAZY
        let renderer:MyRenderer
        let view: MyMetalView
        init(_ view:MyMetalView) {
            self.view = view
            self.renderer = MyRenderer(device: device, pixelFormat: .bgra8Unorm)
        }
        
        func makeNSView() -> some NSView {
            let metalView = MTKView()
            metalView.device = device
            metalView.delegate = renderer
            metalView.translatesAutoresizingMaskIntoConstraints = false
            /*
            metalView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            metalView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
            metalView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            metalView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            */
            metalView.clearColor = MTLClearColorMake(1, 1, 1, 1)
            metalView.colorPixelFormat = renderer.pixelFormat
            metalView.autoResizeDrawable = true
            metalView.framebufferOnly = false
            
            return metalView
        }
    }
}

struct MyMetalView_Previews: PreviewProvider {
    static var previews: some View {
        MyMetalView()
    }
}
