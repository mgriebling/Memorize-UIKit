//
//  MemoryGame.swift
//  Memorize-UIKit
//
//  Created by Mike Griebling on 2021-07-29.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    
    private(set) var cards: [Card]
    
    private var indexOfTheOnlyFaceUpCard: Int?
    
    private(set) var score: Int = 0
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { card.id == $0.id }),
           !cards[chosenIndex].isMatched, !cards[chosenIndex].isFaceUp
        {
            if let possibleMatchIndex = indexOfTheOnlyFaceUpCard {
                if cards[chosenIndex].content == cards[possibleMatchIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[possibleMatchIndex].isMatched = true
                    score += 2
                    print("Score: \(score)")
                }
                indexOfTheOnlyFaceUpCard = nil
            } else {
                for index in cards.indices {
                    if cards[index].isFaceUp && !cards[index].isMatched {
                        if cards[index].wasSeen { score -= 1 }
                        cards[index].wasSeen = true
                    }
                    cards[index].isFaceUp = false
                }
                print("Score: \(score)")
                indexOfTheOnlyFaceUpCard = chosenIndex
            }
            cards[chosenIndex].isFaceUp.toggle()
        }
    }
    
    init(numberOfPairsOfCards: Int, createCardContent: (Int) -> CardContent) {
        cards = [Card]()
        
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
        var content: CardContent
        var id: Int // Identifiable compliance
    }
    
}
