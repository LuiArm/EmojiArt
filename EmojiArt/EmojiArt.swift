//
//  EmojiArt.swift
//  EmojiArt Model
//
//  Created by luis armendariz on 3/1/24.
//

import Foundation

struct EmojiArt {
    var background: URL?
    var emojis = [Emoji]()
    
    struct Emoji {
        let string: String
        var position: Position
        var size: Int
        
        struct Position {
            var x: Int
            var y: Int
        }
    }
}