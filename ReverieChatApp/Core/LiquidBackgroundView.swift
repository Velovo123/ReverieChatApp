//
//  LiquidBackgroundView.swift
//  ReverieChatApp
//
//  Created by Anatolii Semenchuk on 21.04.2026.
//

import SwiftUI
internal import Combine

struct LiquidBackgroundView: View {

    @State private var time: Float = 0

    var body: some View {
        GeometryReader { geo in
            Color.white
                .colorEffect(
                    ShaderLibrary.liquidRainbow(
                        .float2(geo.size),
                        .float(time)
                    )
                )
                .ignoresSafeArea()
        }
        .ignoresSafeArea()
        .onReceive(
            Timer.publish(every: 1.0/60.0, on: .main, in: .common).autoconnect()
        ) { _ in
            time += 1.0/60.0
        }
    }
}

#Preview {
    LiquidBackgroundView()
}
