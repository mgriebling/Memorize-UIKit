//
//  EmojiMemoryGame.swift
//  Memorize-UIKit
//
//  Created by Mike Griebling on 2021-07-29.
//

import SwiftUI

class EmojiMemoryGame : ObservableObject {
    
    static private let themes = [
        Theme<String>(name: "Flags", emojis: ["🏁", "🇨🇦", "🏴‍☠️", "🇺🇸", "🇬🇧", "🇩🇪", "🏳️‍🌈", "🎌", "🇫🇲", "🇸🇳", "🇹🇿", "🇪🇸", "🇸🇱", "🇱🇷", "🇽🇰", "🇳🇷", "🇱🇨", "🇷🇪", "🇰🇷", "🇮🇸"], colour: "cyan", randomPairs: true),
        Theme<String>(name: "Weather", emojis: ["⛅️", "🌥", "☁️", "🌦", "☀️", "🌤", "❄️", "🌧", "⛈", "🌩", "🌨"], colour: "blue"),
        Theme<String>(name: "Faces", emojis: ["👶", "👩🏿‍🦳", "🧔🏽‍♂️", "🕵🏻‍♀️", "👲", "👰🏻‍♂️", "👨🏻‍🚀", "👩‍💻", "🤴🏻", "💂🏾‍♀️", "🧑🏼‍🦱", "👨🏻‍🦳", "🧑🏻‍🌾", "🧕🏻", "🧑🏼‍🔬"], colour: "orange", numberOfPairs: 10),
        Theme<String>(name: "Vehicles", emojis: ["🚌", "🏎", "🛴", "🚑", "🚐", "🛵", "🚟", "🛩", "🚀", "🛺", "🛻", "🚕", "🚎", "🚓", "🛸", "⛵️", "🛶", "🚁", "🚲", "🚜"], colour: "gray"),
        Theme<String>(name: "Food", emojis:["🍎", "🍐", "🍉", "🥥", "🥝", "🍅", "🍆", "🫐", "🍩", "🍬", "🥟", "🥨", "🥓", "🧇", "🍟", "🍕", "🥦", "🌽", "🍒", "🍰", "🍚", "🍤", "🍍"], colour: "pink"),
        Theme<String>(name: "Animals", emojis: ["🐶", "🐱", "🐷", "🐸", "🐵", "🐻‍❄️", "🐻", "🐥", "🐒", "🐳", "🦀", "🦑", "🦕", "🦉", "🦆", "🪰", "🐍", "🦒", "🐓", "🐁", "🦢", "🐇", "🐈"], colour: "teal", randomPairs: true)
    ]
    
    static private func createMemoryGame(theme: Theme<String>) -> MemoryGame<String> {
        return MemoryGame<String>(numberOfPairsOfCards: theme.numberOfPairs) { pairIndex in
            theme.emojiSet[pairIndex]
        }
    }
    
    public init() {
        let theme = EmojiMemoryGame.themes.randomElement()!
        title = "\(theme.name) Memorize!"
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
        colour = EmojiMemoryGame.colorForName(theme.colour)
    }
    
    @Published private var model : MemoryGame<String>
    
    private(set) var title : String
    private(set) var colour : Color
    var score : Int { model.score }
    
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
    
    var cards: [MemoryGame<String>.Card] { model.cards }
    
    // MARK: - Intents
    
    func choose(_ card: MemoryGame<String>.Card) { model.choose(card) }
    
    func newGame() {
        let theme = EmojiMemoryGame.themes.randomElement()!
        title = "\(theme.name) Memorize!"
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
        colour = EmojiMemoryGame.colorForName(theme.colour)
    }
    
}
