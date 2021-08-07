//
//  MemoryGame.swift
//  Memorize-UIKit
//
//  Created by Mike Griebling on 2021-07-29.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    
    private(set) var cards: [Card]
    
    private var indexOfTheOnlyFaceUpCard: Int? {
        get { cards.indices.filter({ cards[$0].isFaceUp }).oneAndOnly }
        set { cards.indices.forEach { cards[$0].isFaceUp = $0 == newValue } }
    }
    
    private(set) var score = 0
    
    private var lastTime = Date()
    
    private mutating func getPoints(for value: Int) -> Int {
        let delta = Int(Date().timeIntervalSince(lastTime))
        return value * max(10 - delta, 1)
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { card.id == $0.id }),
           !cards[chosenIndex].isMatched, !cards[chosenIndex].isFaceUp
        {
            if let possibleMatchIndex = indexOfTheOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[possibleMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[possibleMatchIndex].isMatched = true
                    score += getPoints(for: 2)
                }
                cards[chosenIndex].isFaceUp = true
            } else {
                for index in cards.indices.filter({ cards[$0].isFaceUp && !cards[$0].isMatched }) {
                    if cards[index].wasSeen { score -= 1 }
                    cards[index].wasSeen = true
                }
                indexOfTheOnlyFaceUpCard = chosenIndex
            }
        }
        lastTime = Date()   // update the last chosen time
    }
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = []
        
        // verify the emojois are unique while building the deck
        var contents = [CardContent]()
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = createCardContent(pairIndex)
            if !contents.contains(content) {
                contents.append(content)
                cards.append(Card(content: content, id: 2*pairIndex))
                cards.append(Card(content: content, id: 2*pairIndex+1))
            } else {
                print("\(content) is a duplicate card! Ignoring...")
            }
        }
        score = 0
        cards.shuffle()
    }
    
    struct Card : Identifiable {
        var isFaceUp = false
        var isMatched = false
        var wasSeen = false
        let content: CardContent
        let id: Int // Identifiable compliance
    }
    
}

extension Array {
    
    var oneAndOnly: Element? { count == 1 ? first : nil }
    
}
