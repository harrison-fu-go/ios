//
//  SwiftUIView1.swift
//  YYGradientView
//
//  Created by HarrisonFu on 2022/8/8.
//

import SwiftUI

struct SwiftUIView1: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct SwiftUIView1_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView1()
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
        .shadow(color: Color.primary, radius: 10, x: 0, y: 0)
    }
}
