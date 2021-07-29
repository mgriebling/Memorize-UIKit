//
//  EmojiMemoryGame.swift
//  Memorize-UIKit
//
//  Created by Mike Griebling on 2021-07-29.
//

import SwiftUI

class EmojiMemoryGame : ObservableObject {
    
    static let emojis = [
        "🏁🇨🇦🏴‍☠️🇺🇸🇬🇧🇩🇪🏳️‍🌈🎌🇫🇲🇸🇳🇹🇿🇪🇸🇸🇱🇱🇷🇽🇰🇳🇷🇱🇨🇷🇪🇰🇷🇮🇸",
        "⛅️🌥☁️🌦☀️🌤❄️🌧⛈🌩🌨",
        "👶👩🏿‍🦳🧔🏽‍♂️🕵🏻‍♀️👲👰🏻‍♂️👨🏻‍🚀👩‍💻🤴🏻💂🏾‍♀️🧑🏼‍🦱👨🏻‍🦳🧑🏻‍🌾🧕🏻🧑🏼‍🔬"
    ]
    
    static func createMemoryGame(emojiSet: Int = 0) -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: 4) { pairIndex in
            let emoji = emojis[emojiSet].map{ String($0) }
            return emoji[pairIndex]
        }
    }
    
    @Published private var model = createMemoryGame()
    
    var cards: [MemoryGame<String>.Card] {
        model.cards
    }
    
    // MARK: - Intents
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
}
