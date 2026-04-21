//
//  AuroraStipeView.swift
//  ReverieChatApp
//
//  Created by Anatolii Semenchuk on 21.04.2026.
//


import SwiftUI

struct AuroraStripeView: View {

    var body: some View {
        GeometryReader { geo in
            TimelineView(.animation) { timeline in
                let t = Float(timeline.date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 100)) * 0.3
                Rectangle()
                    .colorEffect(
                        ShaderLibrary.auroraStripe(
                            .float2(geo.size),
                            .float(t)
                        )
                    )
            }
        }
        .frame(width: 4)
        .ignoresSafeArea()
    }
}

#Preview {
    HStack {
        AuroraStripeView()
        Spacer()
    }
    .background(Color(.systemBackground))
}
