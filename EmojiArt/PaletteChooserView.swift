//
//  PaletteChooserView.swift
//  EmojiArt
//
//  Created by luis armendariz on 3/20/24.
//

import SwiftUI

struct PaletteChooserView: View {
    @EnvironmentObject var store: PaletteStore
    
    var body: some View {
        HStack {
            chooser
            view(for: store.palettes[store.cursorIndex])
        }
    }
    
    var chooser: some View {
        Button{
            
        }label: {
            Image(systemName: "paintpalette")
        }
    }
    
    func view(for palette: Palette) -> some View {
        HStack{
            Text(palette.name)
            ScrollingEmojis(palette.emojis)
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
                        .draggable(emoji)
                }
            }
        }
    }
}

#Preview {
    PaletteChooserView()
        .environmentObject(PaletteStore(named: "Preview"))
}
