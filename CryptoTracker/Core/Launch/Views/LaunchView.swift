//
//  LaunchView.swift
//  CryptoTracker
//
//  Created by Nadeem Noushad on 11/09/24.
//

import SwiftUI

struct LaunchView: View {
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    @State private var loadingText: [String] = "Loading your Portfolio...".map({ String($0) })
    @State private var showLoadingText: Bool = false
    @State private var counter: Int = 0
    @State private var loop: Int = 0
    @Binding var showLaunchView: Bool
    
    var body: some View {
        ZStack {
            Color.launch.background
                .ignoresSafeArea()
            
            Image("logo-transparent")
                .resizable()
                .frame(width: 100, height: 100)
            
            ZStack {
                if showLoadingText {
                    loadingTextView
                    .transition(.scale.animation(.easeIn))
                    .onReceive(timer, perform: letterAnimation)
                }
            }
        }
        .onAppear { showLoadingText.toggle() }
        .opacity(showLaunchView ? 1 : 0)
    }

}

#Preview {
    LaunchView(showLaunchView: .constant(true))
}

extension LaunchView {
    private var loadingTextView: some View {
        HStack(spacing: 0.5) {
            ForEach(loadingText.indices, id: \.self) { index in
                Text(loadingText[index])
                    .foregroundStyle(Color.launch.accent)
                    .lineSpacing(0)
                    .offset(y: counter == index ? -5 : 0)
            }
            .offset(y: 70)
        }
    }
    
    func letterAnimation(_: Published<Any>.Publisher.Output) {
        withAnimation(.easeInOut(duration: 0.5)) {
            let lastIndex = loadingText.count - 1
            
            if counter == lastIndex {
                counter = 0
                loop += 1
                if loop > 1 {
                    showLaunchView = false
                }
            } else {
                counter += 1
            }
        }
    }
}
