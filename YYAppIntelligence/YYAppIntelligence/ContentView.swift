//
//  ContentView.swift
//  YYAppIntelligence
//
//  Created by Harrison Fu on 2024/10/22.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var siriStt = SiriSTT.shared
    
    init() {
        SiriSTT.shared.requestAuthorization { auth in
            print("requestAuthorization ======> \(auth)")
        }
    }
    var body: some View {
        VStack {
            if #available(iOS 15.0, *) {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
            } else {
                // Fallback on earlier versions
            }
            Text("Hello, world!")
            Button(action: {
                print("Button tapped! ======")
                SiriSTT.shared.startRecording()
            }) {
                Text("Tap me!")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            Button(action: {
                XsRemoveLogs()
            }) {
                Text("清除logs")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            Button(action: {
                print("Button tapped! ======")
                SiriSTT.shared.startRecognitionMp3()
            }) {
                Text("Recognition Mp3")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            Text("当前已经识别：\(siriStt.currentCount)--> \(siriStt.currentFinalText)")
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
