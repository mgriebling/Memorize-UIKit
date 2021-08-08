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
        get { cards.indices.filter ({ cards[$0].isFaceUp }).oneAndOnly }
        set { cards.indices.forEach { cards[$0].isFaceUp = $0 == newValue } }
    }
    
    private(set) var score = 0
    
    static var bonusTime : Double { 10 }
    private let bonusAmount = Double(3)  // reduces with bonusTime
    
    private mutating func getBonus(for card: Card) -> Int {
        card.hasEarnedBonus ? Int(round(card.bonusRemaining*bonusAmount)) : 1
    }
    
    mutating func choose(_ card: Card) {
        let a = !cards[card].isMatched
        let b = !cards[card].isFaceUp
        if a && b {
            if let possibleMatchIndex = indexOfTheOnlyFaceUpCard {
                if cards[card].content == cards[possibleMatchIndex].content {
                    cards[card].isMatched = true
                    cards[possibleMatchIndex].isMatched = true
                    score += getBonus(for: cards[card]) + getBonus(for: cards[possibleMatchIndex])
                }
                cards[card].isFaceUp = true
            } else {
                for index in cards.indices.filter({ cards[$0].isFaceUp && !cards[$0].isMatched }) {
                    if cards[index].wasSeen { score -= 1 }
                }
                indexOfTheOnlyFaceUpCard = cards.index(matching: card)
            }
        }
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
        var isFaceUp = false {
            didSet {
                if isFaceUp { startUsingBonusTime() }
                else { stopUsingBonusTime() }
            }
        }
        var isMatched = false { didSet { stopUsingBonusTime() } }
        var wasSeen : Bool { pastFaceUpTime > 0 }
        
        let content: CardContent
        let id: Int // Identifiable compliance
        
        // MARK: - Bonus Time
        // can be zero which means "no bonus available" for this card
        var bonusTimeLimit: TimeInterval = bonusTime
        
        // how long this card has ever been face up
        private var faceUpTime: TimeInterval {
            if let lastFaceUpDate = self.lastFaceUpDate {
                return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
            } else {
                return pastFaceUpTime
            }
        }
        
        // last time this card was turned face up (and is still face up)
        var lastFaceUpDate: Date?
        
        // accumulated time this card has been face up in the past
        // (i.e., not including the current time it's been face up if it is currently so
        var pastFaceUpTime: TimeInterval = 0
        
        // how much time left before the bonus opportunity runs out
        var bonusTimeRemaining : Double { max(0, bonusTimeLimit - faceUpTime) }
        
        // percentage of the bonus time remaining
        var bonusRemaining: Double {
            (bonusTimeLimit > 0 && bonusTimeRemaining > 0) ? bonusTimeRemaining/bonusTimeLimit : 0
        }
        
        // whether the card was matched during the bonus time period
        var hasEarnedBonus: Bool { isMatched && bonusTimeRemaining > 0 }
        
        // whether we are currently face up, unmatched and have not yet used up the bonus window
        var isConsumingBonusTime : Bool { isFaceUp && !isMatched && bonusTimeRemaining > 0 }
        
        // called when the card transitions to face up state
        private mutating func startUsingBonusTime() {
            if isConsumingBonusTime, lastFaceUpDate == nil {
                lastFaceUpDate = Date()
            }
        }
        
        // called when the card goes back face down (or gets matched)
        private mutating func stopUsingBonusTime() {
            pastFaceUpTime = faceUpTime
            self.lastFaceUpDate = nil
        }
        
    }
    
}

extension Array {
    
    var oneAndOnly: Element? { count == 1 ? first : nil }
    
}
