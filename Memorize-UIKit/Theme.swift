//
//  Theme.swift
//  Memorize-UIKit
//
//  Created by Mike Griebling on 2021-07-29.
//

import Foundation

struct Theme<Content> {
    
    private(set) var name: String
    private(set) var emojiSet: [Content]
    var numberOfPairs: Int { randomPairs ? Int.random(in: 4..._numberOfPairs) : _numberOfPairs }
    private var _numberOfPairs: Int
    private var randomPairs: Bool = false
    private(set) var colour: String
    
    init(name: String, emojis: [Content], colour: String = "", numberOfPairs: Int = 0) {
        self.name = name
        self.emojiSet = emojis.shuffled()
        self._numberOfPairs = numberOfPairs == 0 ? emojis.count : min(emojis.count, numberOfPairs)
        self.colour = colour.isEmpty ? "white" : colour
    }
    
    init(name: String, emojis: [Content], colour: String = "", randomPairs: Bool) {
        self.init(name: name, emojis: emojis, colour: colour)
        self.randomPairs = randomPairs
    }
}


