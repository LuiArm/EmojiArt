//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by luis armendariz on 3/1/24.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    
    private let emojis = "👻👺🍰🍩👻👺🍰🍩👻👺🍰🍩👻👺🍰🍩👻👺🍰🍩👻👺🍰🍩👻👺🍰🍩👻👺🍰🍩👻👺🍰🍩👻👺🍰🍩👻👺🍰🍩👻👺🍰🍩"
    
    private let paletteEmojiSize: CGFloat = 40
    var body: some View {
        VStack {
            Color.yellow
            ScrollingEmojis(emojis)
                .font(.system(size: paletteEmojiSize))
                .padding(.horizontal)
        }
    }
}

struct ScrollingEmojis: View {
    var  emojis: [String]
    
    init(_ emojis: String) {
        self.emojis = emojis.uniqued.map(String.init)
    }
    
    var body: some View {
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
