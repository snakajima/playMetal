//
//  ContentView.swift
//  playMetaliOS
//
//  Created by SATOSHI NAKAJIMA on 10/2/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        MyMetalView(shader:MyTriangle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
