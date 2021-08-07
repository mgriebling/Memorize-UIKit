//
//  EmojiMemoryGameView.swift
//  Memorize-UIKit
//
//  Created by Mike Griebling on 2021-07-28.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    
    @ObservedObject var game: EmojiMemoryGame
    
    @Namespace private var dealingNamespace
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                HStack { Text(game.title).font(.title) }
                gameBody
                HStack {
                    Text("Score: \(game.score)").bold()
                    Spacer()
                    newGame
                }.padding(.horizontal)
            }
            deckBody
        }
        .padding()
    }
    
    var newGame: some View {
        Button("Restart") {
            withAnimation {
                dealt = []
                game.newGame()
            }
        }
    }
    
    // private state used to temporary track
    //  whether a card has been dealt or not
    // contains id's of MemoryGame<String>.Cards
    @State private var dealt = Set<Int>()
    
    // marks the given card as having been dealt
    private func deal(_ card: EmojiMemoryGame.Card) {
        dealt.insert(card.id)
    }
    
    // returns whether the given card has not been dealt yet
    private func isUndealt(_ card: EmojiMemoryGame.Card) -> Bool {
        !dealt.contains(card.id)
    }
    
    // an Animation used to deal the cards out "not all at the same time"
    // the Animation is delayed depending on the index of the given card
    //  in our ViewModel's (and thus our Model's) cards array
    // the further the card is into that array, the more the animation is delayed
    private func dealAnimation(for card: EmojiMemoryGame.Card) -> Animation {
        var delay = 0.0
        if let index = game.cards.firstIndex(where: { $0.id == card.id }) {
            delay = Double(index) * (CardConstants.totalDealDuration / Double(game.cards.count))
        }
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    // returns a Double which is a bigger number the closer a card is to the front of the cards array
    // used by both of our matchedGeometryEffect CardViews
    //  so that they order the cards in the "z" direction in the same way
    // (the "z" direction is the direction going up out of the device towards the user)
    private func zIndex(of card: EmojiMemoryGame.Card) -> Double {
        -Double(game.cards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.cards.filter(isUndealt)) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex(of: card))
            }
        }
        // generally using magic numbers as arguments to frame(width:height:)
        // should be avoided
        // much better to let Views naturally lay themselves out if possible
        // but here, it's not clear what the "natural size" of a deck would be
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .foregroundColor(game.colour)
        .onTapGesture {
            // "deal" cards
            // note that this is not calling a user Intent function
            // (instead it is just setting some of our private @State)
            // that's because "dealing" is purely a temporary UI/animation thing
            // it has nothing to do with our Model
            // because "dealing" is not part of the Memorize game logic
            // (dealing IS part of some card games, for example, Set)
            for card in game.cards {
                withAnimation(dealAnimation(for: card)) {
                    deal(card)
                }
            }
        }
    }
    
    var gameBody: some View {
        AspectVGrid(items: game.cards, aspectRatio: CardConstants.aspectRatio) { card in
            if isUndealt(card) || (card.isMatched && !card.isFaceUp) {
                Color.clear
            } else {
                CardView(card: card, background: game.colour, useGradient: game.useGradient)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                    .zIndex(zIndex(of: card))
                    .padding(2)
                    .onTapGesture {
                        withAnimation {
                            game.choose(card)
                        }
                    }
            }
        }
        .foregroundColor(game.colour)
    }
    
    private struct CardConstants {
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
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
