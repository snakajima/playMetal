//
//  ContentView.swift
//  playMetal
//
//  Created by SATOSHI NAKAJIMA on 9/29/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            MyMetalView(shader:MyTriangle())
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
