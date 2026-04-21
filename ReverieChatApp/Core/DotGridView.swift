//
//  DotGridView.swift
//  ReverieChatApp
//
//  Created by Anatolii Semenchuk on 21.04.2026.
//

import SwiftUI

struct DotGridView: View {
    var body: some View {
        GeometryReader { geo in
            Color.white
                .colorEffect(
                    ShaderLibrary.dotGrid(
                        .float2(geo.size)
                    )
                )
        }
        .ignoresSafeArea()
    }
}

#Preview {
    DotGridView()
}
