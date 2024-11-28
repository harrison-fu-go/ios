//
//  ContentView.swift
//  YYiMessage
//
//  Created by Harrison Fu on 2024/10/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showVC = false
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!==")
            Button("弹出 UIViewController") {
                            showVC.toggle()
                        }
                        .fullScreenCover(isPresented: $showVC) {
                            AnimatedViewControllerWrapper()
                        }
        }
        .padding()
    }
}

struct YYTestView: View {
    var body: some View {
        VStack {
            Text("Hello, world!==")
        }
        .padding()
    }
}


#Preview {
    ContentView()
}
