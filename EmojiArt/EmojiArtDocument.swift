//
//  EmojiArtDocument.swift
//  EmojiArtDocument view model
//
//  Created by luis armendariz on 3/1/24.
//

import SwiftUI

class EmojiArtDocument: ObservableObject {
    typealias Emoji = EmojiArt.Emoji
    
    private var emojiArt = EmojiArt()
    
    var emojis: [Emoji] {
        emojiArt.emojis
    }
    
    var background: URL? {
        emojiArt.background
    }
    
    // MARK: - Intent(S)
    
    func setBackground(_ url: URL?) {
        emojiArt.background = url
    }
    
}
