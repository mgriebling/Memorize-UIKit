//
//  EmojiMemoryGameView.swift
//  Memorize-UIKit
//
//  Created by Mike Griebling on 2021-07-28.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    
    @ObservedObject var game: EmojiMemoryGame
    
    var body: some View {
        VStack {
            HStack { Text(game.title).font(.largeTitle) }
            Spacer()
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                    ForEach(game.cards) { card in
                        CardView(card: card, background: game.colour, useGradient: game.useGradient)
                            .aspectRatio(2/3, contentMode: .fit)
                            .onTapGesture { game.choose(card) }
                    }
                }
            }
            .foregroundColor(game.colour)
            Spacer()
            HStack {
                Text("Score: \(game.score)").bold()
                Spacer()
                Text("\(game.cards.count) cards").font(.footnote)
                Spacer()
                Button("New Game") { game.newGame() }
            }.font(.title2)
        }
        .padding(.horizontal)
    }
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            let game = EmojiMemoryGame()
            EmojiMemoryGameView(game: game).previewDevice("iPhone 12 mini").preferredColorScheme(.light)
            EmojiMemoryGameView(game: game).previewDevice("iPhone 12 mini").preferredColorScheme(.dark)
        }
    }
}
