//
//  MyMetalView.swift
//  playMetal
//
//  Created by SATOSHI NAKAJIMA on 9/29/20.
//
import SwiftUI
import MetalKit

struct MyMetalView: NSViewRepresentable {
    let shader:MyRendererDelegate
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self, shader: shader)
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
        init(_ view:MyMetalView, shader:MyRendererDelegate) {
            self.view = view
            self.renderer = MyRenderer(device: device, pixelFormat: .bgra8Unorm, delegate:shader)
        }
        
        func makeNSView() -> some NSView {
            let metalView = MTKView()
            metalView.device = device
            metalView.delegate = renderer
            metalView.translatesAutoresizingMaskIntoConstraints = false
            metalView.clearColor = MTLClearColorMake(0, 0, 1, 1)
            metalView.colorPixelFormat = renderer.pixelFormat
            //metalView.autoResizeDrawable = true
            //metalView.framebufferOnly = false
            
            return metalView
        }
    }
}

struct MyMetalView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack {
                MyMetalView(shader:MyCircle())
                MyMetalView(shader:MyCircle())
            }
            HStack {
                MyMetalView(shader:MyTriangle())
                MyMetalView(shader:MyCircle())
            }
        }
    }
}
