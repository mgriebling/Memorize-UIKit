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
    private      var _numberOfPairs: Int
    private      var randomPairs = false
    private(set) var useGradient = false
    private(set) var colour: String
    
    var numberOfPairs: Int { randomPairs ? Int.random(in: 4..._numberOfPairs) : _numberOfPairs }
    
    init(name: String, emojis: [Content], colour: String = "", numberOfPairs: Int = 0, useGradient: Bool = false) {
        self.name = name
        self.emojiSet = emojis.shuffled()
        self._numberOfPairs = numberOfPairs == 0 ? emojis.count : min(emojis.count, numberOfPairs)
        self.colour = colour.isEmpty ? "white" : colour
        self.useGradient = useGradient
    }
    
    init(name: String, emojis: [Content], colour: String = "", randomPairs: Bool, useGradient: Bool = false) {
        self.init(name: name, emojis: emojis, colour: colour, useGradient: useGradient)
        self.randomPairs = randomPairs
    }
}


