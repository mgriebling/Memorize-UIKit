//
//  EmojiMemoryGame.swift
//  Memorize-UIKit
//
//  Created by Mike Griebling on 2021-07-29.
//

import SwiftUI

class EmojiMemoryGame : ObservableObject {
    
    typealias Card = MemoryGame<String>.Card
    
    static private let themes = [
        Theme<String>(name: "Flags", emojis: ["🏁","🇨🇦","🏴‍☠️","🇺🇸","🇬🇧","🇩🇪","🏳️‍🌈","🎌","🇫🇲","🇸🇳","🇹🇿","🇪🇸","🇸🇱","🇱🇷","🇽🇰","🇳🇷","🇱🇨","🇷🇪","🇰🇷","🇮🇸"], colour: "cyan", randomPairs: true),
        Theme<String>(name: "Weather", emojis: ["⛅️","🌥","☁️","🌦","☀️","🌤","❄️","🌧","⛈","🌩","🌨"], colour: "blue", useGradient: true),
        Theme<String>(name: "Faces", emojis: ["👶","👩🏿‍🦳","🧔🏽‍♂️","🕵🏻‍♀️","👲","👰🏻‍♂️","👨🏻‍🚀","👩‍💻","🤴🏻","💂🏾‍♀️","🧑🏼‍🦱","👨🏻‍🦳","🧑🏻‍🌾","🧕🏻","🧑🏼‍🔬"], colour: "orange", numberOfPairs: 10),
        Theme<String>(name: "Vehicles", emojis: ["🚌","🏎","🛴","🚑","🚐","🛵","🚟","🛩","🚀","🛺","🛻","🚕","🚎","🚓","🛸","⛵️","🛶","🚁","🚲","🚜"], colour: "gray"),
        Theme<String>(name: "Food", emojis:["🍎","🍐","🍉","🥥","🥝","🍅","🍆","🫐","🍩","🍬","🥟","🥨","🥓","🧇","🍟","🍕","🥦","🌽","🍒","🍰","🍚","🍤","🍍"], colour: "pink"),
        Theme<String>(name: "Animals", emojis: ["🐶","🐱","🐷","🐸","🐵","🐻‍❄️","🐻","🐥","🐒","🐳","🦀","🦑","🦕","🦉","🦆","🪰","🐍","🦒","🐓","🐁","🦢","🐇","🐈"], colour: "teal", randomPairs: true)
    ]
    
    static private func createMemoryGame(theme: Theme<String>) -> MemoryGame<String> {
        MemoryGame<String>(numberOfPairsOfCards: theme.numberOfPairs) { pairIndex in
            theme.emojiSet[pairIndex]
        }
    }
    
    private func setValues(theme: Theme<String>) {
        game = EmojiMemoryGame.createMemoryGame(theme: theme)
        title = "\(theme.name) Memorize!"
        colour = EmojiMemoryGame.colorForName(theme.colour)
        useGradient = theme.useGradient
    }
    
    public init() {
        let theme = EmojiMemoryGame.themes.randomElement()!
        game = EmojiMemoryGame.createMemoryGame(theme: theme)
        setValues(theme: theme)
    }
    
    @Published private var game : MemoryGame<String>
    private(set) var title = ""
    private(set) var colour = Color.black
    private(set) var useGradient = false
    var score : Int { game.score }
    
    private static func colorForName(_ name: String) -> Color {
        switch name {
        case "red" :     return .red
        case "blue" :    return .blue
        case "orange" :  return .orange
        case "gray" :    return .gray
        case "green" :   return .green
        case "cyan" :    return Color(.cyan)
        case "magenta" : return Color(.magenta)
        case "purple" :  return .purple
        case "brown" :   return Color(.brown)
        case "indigo" :  return Color(.systemIndigo)
        case "teal" :    return Color(.systemTeal)
        case "pink" :    return Color(.systemPink)
        default:         return .black
        }
    }
    
    var cards: [MemoryGame<String>.Card] { game.cards }
    
    // MARK: - Intents
    
    func choose(_ card: Card) { game.choose(card) }
    
    func newGame() {
        let theme = EmojiMemoryGame.themes.randomElement()!
        setValues(theme: theme)
    }
    
}
