//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by luis armendariz on 3/1/24.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    @ObservedObject var document: EmojiArtDocument
    
    private let emojis = "👻👺🍰🍩👻👺🍰🍩👻👺🍰🍩👻👺🍰🍩👻👺🍰🍩👻👺🍰🍩👻👺🍰🍩👻👺🍰🍩👻👺🍰🍩👻👺🍰🍩👻👺🍰🍩👻👺🍰🍩"
    
    private let paletteEmojiSize: CGFloat = 40
    var body: some View {
        VStack(spacing: 0) {
            documentBody
            ScrollingEmojis(emojis)
                .font(.system(size: paletteEmojiSize))
                .padding(.horizontal)
        }
        .scrollIndicators(.hidden)
    }
    
    private var documentBody: some View  {
        ZStack{
            Color.white
            // image goes here
            ForEach(document.emojis){emoji in
                Text(emoji.string)
                    .font(emoji.font)
                    .position(emoji.position)
            }
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
    EmojiArtDocumentView(document: EmojiArtDocument())
}
