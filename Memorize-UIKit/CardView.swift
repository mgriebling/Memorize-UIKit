//
//  CardView.swift
//  Memorize-UIKit
//
//  Created by Mike Griebling on 2021-07-30.
//

import SwiftUI

struct CardView: View {
    let card: EmojiMemoryGame.Card
    var background: Color = .white
    var useGradient = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Text(card.content)
                    .padding(5)
                    .font(.system(size: DrawingConstants.fontSize))
                    .scaleEffect(scale(thatFits: geometry.size))
            }
            .cardify(isFaceUp: card.isFaceUp)
        }
    }
    
    // the "scale factor" to scale our Text up so that it fits the geometry.size offered to us
    private func scale(thatFits size: CGSize) -> CGFloat {
        min(size.width, size.height) / (DrawingConstants.fontSize / DrawingConstants.fontScale)
    }
    
    private struct DrawingConstants {
        static let fontScale = CGFloat(0.7)
        static let fontSize = CGFloat(32)
    }
}
