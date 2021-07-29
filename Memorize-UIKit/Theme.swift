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
    private(set) var numberOfPairs: Int
    private(set) var colour: String
    
    init(name: String, emojis: [Content], numberOfPairs: Int = 0, colour: String = "") {
        self.name = name
        self.emojiSet = emojis
        self.numberOfPairs = numberOfPairs == 0 ? emojis.count : min(emojis.count, numberOfPairs)
        self.colour = colour.isEmpty ? "white" : colour
    }
}


