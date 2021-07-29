//
//  ContentView.swift
//  Memorize-UIKit
//
//  Created by Mike Griebling on 2021-07-28.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var viewModel: EmojiMemoryGame
    let backColors = [Color.green.opacity(0.15), .blue.opacity(0.5), .gray.opacity(0.3)]
    @State var set = 0
    
    // tries to adjust the card width to fit all the cards
    func widthThatFitsBest(cardCount: Int) -> CGFloat {
        let area : CGFloat = 70_000  // guestimate for now
        let width = sqrt(area * 2 / CGFloat(cardCount+3))
        return width
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Memorize!").font(.largeTitle)
            }
            Spacer()
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 65))]) {
                    ForEach(viewModel.cards) { card in
                        CardView(card: card, background: backColors[set])
                            .aspectRatio(2/3, contentMode: .fit)
                            .onTapGesture {
                                viewModel.choose(card)
                            }
                    }
                }
            }
            .foregroundColor(.red)
            Spacer()
            HStack {
                Spacer()
                ButtonView(label: "Flags", image: "flag") { set = 0 }
                Spacer()
                ButtonView(label: "Weather", image: "sun.max") { set = 1 }
                Spacer()
                ButtonView(label: "Faces", image: "face.smiling") { set = 2 }
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}

struct ButtonView: View {
    var label: String
    var image: String
    var set: () -> ()
    var body: some View {
        VStack {
            Image(systemName: image).font(.largeTitle)
            Text(label).font(.footnote)
        }
        .foregroundColor(.accentColor)
        .onTapGesture { set() }
    }
}


struct CardView: View {
    var card: MemoryGame<String>.Card
    var background: Color = .white
    
    var body: some View {
        ZStack {
            let cardShape = RoundedRectangle(cornerRadius: 20)
            if card.isFaceUp {
                cardShape.fill().foregroundColor(background)
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
