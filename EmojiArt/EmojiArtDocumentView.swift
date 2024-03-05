//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by luis armendariz on 3/1/24.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    
    private let emojis = "👻👺🍰🍩"
    
    var body: some View {
        VStack {
            Color.yellow
            ScrollingEmojis()
        }
    }
}

struct ScrollingEmojis: View {
    
    
    var body: some View {
        var  emojis: [String]
        
        init(emojis: String) {
            self.emojis = emojis
        }
        
        ScrollView(.horizontal) {
            HStack {
                ForEach(emojis, id: \.self){ emoji in
                    Text(emoji)
                }
            }
        }
    }
}

#Preview {
    EmojiArtDocumentView()
}
