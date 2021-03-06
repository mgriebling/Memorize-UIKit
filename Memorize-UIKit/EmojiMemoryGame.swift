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
        Theme<String>(name: "Flags", emojis: ["ð","ðĻðĶ","ðīââ ïļ","ðšðļ","ðŽð§","ðĐðŠ","ðģïļâð","ð","ðŦðē","ðļðģ","ðđðŋ","ðŠðļ","ðļðą","ðąð·","ð―ð°","ðģð·","ðąðĻ","ð·ðŠ","ð°ð·","ðŪðļ"], colour: "cyan", randomPairs: true),
        Theme<String>(name: "Weather", emojis: ["âïļ","ðĨ","âïļ","ðĶ","âïļ","ðĪ","âïļ","ð§","â","ðĐ","ðĻ"], colour: "blue", useGradient: true),
        Theme<String>(name: "Faces", emojis: ["ðķ","ðĐðŋâðĶģ","ð§ð―ââïļ","ðĩðŧââïļ","ðē","ð°ðŧââïļ","ðĻðŧâð","ðĐâðŧ","ðĪīðŧ","ððūââïļ","ð§ðžâðĶą","ðĻðŧâðĶģ","ð§ðŧâðū","ð§ðŧ","ð§ðžâðŽ"], colour: "orange", numberOfPairs: 10),
        Theme<String>(name: "Vehicles", emojis: ["ð","ð","ðī","ð","ð","ðĩ","ð","ðĐ","ð","ðš","ðŧ","ð","ð","ð","ðļ","âĩïļ","ðķ","ð","ðē","ð"], colour: "gray"),
        Theme<String>(name: "Food", emojis:["ð","ð","ð","ðĨĨ","ðĨ","ð","ð","ðŦ","ðĐ","ðŽ","ðĨ","ðĨĻ","ðĨ","ð§","ð","ð","ðĨĶ","ð―","ð","ð°","ð","ðĪ","ð"], colour: "pink"),
        Theme<String>(name: "Animals", emojis: ["ðķ","ðą","ð·","ðļ","ðĩ","ðŧââïļ","ðŧ","ðĨ","ð","ðģ","ðĶ","ðĶ","ðĶ","ðĶ","ðĶ","ðŠ°","ð","ðĶ","ð","ð","ðĶĒ","ð","ð"], colour: "teal", randomPairs: true)
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
