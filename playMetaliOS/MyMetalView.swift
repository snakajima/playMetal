//
//  MyMetalView.swift
//  playMetaliOS
//
//  Created by SATOSHI NAKAJIMA on 10/2/20.
//
import SwiftUI
import MetalKit

struct MyMetalView: UIViewRepresentable {
    let shader:MyRendererDelegate
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self, shader: shader)
    }
    
    public func makeUIView(context: Context) -> some UIView {
        return context.coordinator.makeUIView()
    }
    
    public func updateUIView(_ uiView: UIViewType, context: Context) {
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
        
        func makeUIView() -> some UIView {
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
