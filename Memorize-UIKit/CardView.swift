//
//  CardView.swift
//  Memorize-UIKit
//
//  Created by Mike Griebling on 2021-07-30.
//

import SwiftUI

struct CardView: View {
    var card: MemoryGame<String>.Card
    var background: Color = .white
    var useGradient: Bool = false
    
    var body: some View {
        ZStack {
            let cardShape = RoundedRectangle(cornerRadius: 20)
            if card.isFaceUp {
                cardShape.fill().foregroundColor(background.opacity(0.3))
                cardShape.strokeBorder(lineWidth: 3)
                Text(card.content).font(.system(size: 60))
            } else if card.isMatched {
                cardShape.opacity(0)
            } else {
                if useGradient {
                    let gradient = LinearGradient(gradient: Gradient(colors: [.white, background]), startPoint: .top, endPoint: .bottom)
                    cardShape.fill(gradient)
                } else {
                    cardShape.fill()
                }
            }
        }
    }
}
