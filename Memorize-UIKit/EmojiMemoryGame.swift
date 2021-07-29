//
//  EmojiMemoryGame.swift
//  Memorize-UIKit
//
//  Created by Mike Griebling on 2021-07-29.
//

import SwiftUI

class EmojiMemoryGame : ObservableObject {
    
    static let themes = [
        Theme<String>(name: "Flags", emojis: ["🏁", "🇨🇦", "🏴‍☠️", "🇺🇸", "🇬🇧", "🇩🇪", "🏳️‍🌈", "🎌", "🇫🇲", "🇸🇳", "🇹🇿", "🇪🇸", "🇸🇱", "🇱🇷", "🇽🇰", "🇳🇷", "🇱🇨", "🇷🇪", "🇰🇷", "🇮🇸"], numberOfPairs: 14, colour: "red"),
        Theme<String>(name: "Weather", emojis: ["⛅️", "🌥", "☁️", "🌦", "☀️", "🌤", "❄️", "🌧", "⛈", "🌩", "🌨"], colour: "blue"),
        Theme<String>(name: "Faces", emojis: ["👶", "👩🏿‍🦳", "🧔🏽‍♂️", "🕵🏻‍♀️", "👲", "👰🏻‍♂️", "👨🏻‍🚀", "👩‍💻", "🤴🏻", "💂🏾‍♀️", "🧑🏼‍🦱", "👨🏻‍🦳", "🧑🏻‍🌾", "🧕🏻", "🧑🏼‍🔬"], colour: "orange")
    ]
    
    static func createMemoryGame(themeIndex: Int = 0) -> MemoryGame<String> {
        let theme = themes[themeIndex]
        return MemoryGame<String>(numberOfPairsOfCards: theme.numberOfPairs) { pairIndex in
            theme.emojiSet[pairIndex]
        }
    }
    
    @Published private var model : MemoryGame<String> = createMemoryGame()
    
    var themeIndex : Int = 0
    
    var title : String { "\(EmojiMemoryGame.themes[themeIndex].name) Memorize!" }
    
    var colour : UIColor {
        let theme = EmojiMemoryGame.themes[themeIndex]
        switch theme.colour {
        case "red" :    return .red
        case "blue" :   return .blue
        case "orange" : return .orange
        case "gray" :   return .gray
        case "green" :  return .green
        case "cyan" :   return .cyan
        default:        return .black
        }
    }
    
    var cards: [MemoryGame<String>.Card] {
        model.cards
    }
    
    // MARK: - Intents
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
    func newGame() {
        let themeIndex = Int.random(in: 0..<EmojiMemoryGame.themes.count)
        model = EmojiMemoryGame.createMemoryGame(themeIndex: themeIndex)
    }
    
}
