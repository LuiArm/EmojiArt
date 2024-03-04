//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by luis armendariz on 3/1/24.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    var body: some View {
        VStack {
            Color.yellow
            ScrollingEmojis()
        }
    }
}

struct ScrollingEmojis: View {
    
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(emojis, id: \.self){ emoji in
                    
                }
            }
        }
    }
}

#Preview {
    EmojiArtDocumentView()
}
