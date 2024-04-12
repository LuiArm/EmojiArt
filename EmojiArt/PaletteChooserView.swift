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
        .clipped()
    }
    
    var chooser: some View {
        AnimatedActionButton(systemImage: "paintpalette") {
                store.cursorIndex += 1
            }
        .contextMenu{
            gotoMenu
            AnimatedActionButton("New", systemImage: "plus"){
                store.insert(name: "Math", emojis: "✖️➗")
            }
            AnimatedActionButton("Delete", systemImage: "minus.circle", role: .destructive){
                store.palettes.remove(at: store.cursorIndex)
            }
        }
    }
     
    private var gotoMenu: some View {
        Menu {
            ForEach(store.palettes){ palette in
                AnimatedActionButton(palette.name) {
                    if let index = store.palettes.firstIndex(where: {$0.id == palette.id}){
                        store.cursorIndex = index
                    }
                }
            }
        }label: {
            Label("Go To", systemImage: "")
        }
    }
    
    func view(for palette: Palette) -> some View {
        HStack{
            Text(palette.name)
            ScrollingEmojis(palette.emojis)
        }
        .id(palette.id)
        .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .top)))
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
