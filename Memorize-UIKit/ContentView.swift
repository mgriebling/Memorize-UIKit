//
//  ContentView.swift
//  Memorize-UIKit
//
//  Created by Mike Griebling on 2021-07-28.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var viewModel: EmojiMemoryGame
    
    // tries to adjust the card width to fit all the cards
    func widthThatFitsBest(cardCount: Int) -> CGFloat {
        let area : CGFloat = 70_000  // guestimate for now
        let width = sqrt(area * 2 / CGFloat(cardCount+3))
        return width
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(viewModel.title).font(.largeTitle)
            }
            Spacer()
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                    ForEach(viewModel.cards) { card in
                        CardView(card: card, background: viewModel.colour)
                            .aspectRatio(2/3, contentMode: .fit)
                            .onTapGesture {
                                viewModel.choose(card)
                            }
                    }
                }
            }
            .foregroundColor(viewModel.colour)
            Spacer()
            HStack {
                Text("Score: \(viewModel.score)").font(.largeTitle).bold()
                Spacer()
                Button("New Game") { viewModel.newGame() }
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    var background: Color = .white
    
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
                cardShape.fill()
            }
        }
    }
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            let game = EmojiMemoryGame()
            ContentView(viewModel: game).previewDevice("iPhone 12 mini").preferredColorScheme(.light)
            ContentView(viewModel: game).previewDevice("iPhone 12 mini").preferredColorScheme(.dark)
        }
    }
}
