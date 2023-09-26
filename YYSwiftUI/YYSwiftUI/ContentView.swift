//
//  ContentView.swift
//  YYSwiftUI
//
//  Created by HarrisonFu on 2022/8/8.
//

import SwiftUI
import PureSwiftUI
import PureSwiftUIDesign

struct ContentView: View {
    var body: some View {
//        Text("Hello, world!")
//            .padding()
//        Text("Green Text").padding()
        SFSymbol(.music_note_house_fill).fontSize(60, weight: .bold)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


struct CardView: View {
    var body: some View {
        VStack(spacing: 0) {
            Circle()
                .trim(from: 0.5, to: 1)
                .fill(Color.orange)
                .frame(width: 100, height: 100)
                .offset(x: 0, y: 50)
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.orange)
                .frame(width: 200, height: 250)
        }
        .compositingGroup()
        .shadow(color: Color.primary, radius: 5, x: 0, y: 0)
    }
}
