//
//  MyMetalView.swift
//  playMetal
//
//  Created by SATOSHI NAKAJIMA on 9/29/20.
//

import SwiftUI

struct MyMetalView: NSViewRepresentable {
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    public func makeNSView(context: Context) -> some NSView {
        let nsView = NSView()
        nsView.layer = context.coordinator.makeLayer()
        return nsView
    }
    
    public func updateNSView(_ nsView: NSViewType, context: Context) {
        //
    }
    
    class Coordinator: NSObject {
        let gpu = MTLCreateSystemDefaultDevice()
        let renderer = MyRenderer()
        let view: MyMetalView
        init(_ view:MyMetalView) {
            self.view = view
        }
        
        func makeLayer() -> CALayer {
            let layer = CAMetalLayer()
            layer.backgroundColor = NSColor.yellow.cgColor
            return layer
        }
    }
}

struct MyMetalView_Previews: PreviewProvider {
    static var previews: some View {
        MyMetalView()
    }
}
