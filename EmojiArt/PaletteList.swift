//
//  PaletteList.swift
//  EmojiArt
//
//  Created by luis armendariz on 4/16/24.
//

import SwiftUI

struct PaletteList: View {
    @EnvironmentObject var store: PaletteStore
    @State private var showCursorPalette = false
    
    var body: some View {
        NavigationStack{
            List {
                ForEach(store.palettes) { palette in
                    NavigationLink(value: palette){
                        VStack(alignment: .leading){
                            Text(palette.name)
                            Text(palette.emojis).lineLimit(1)
                        }
                    }
                }
                .onDelete { indexSet in
                    withAnimation {
                        store.palettes.remove(atOffsets: indexSet)
                    }
                }
                .onMove { indexSet, newOffset in
                    store.palettes.move(fromOffsets: indexSet, toOffset: newOffset)
        
                    }
                }
                .navigationDestination(for: Palette.self) { palette in
                    if let index = store.palettes.firstIndex(where: { $0.id == palette.id }) {
                        PaletteEditor(palette: $store.palettes[index])
                    }
                }
                .navigationDestination(isPresented: $showCursorPalette){
                    PaletteEditor(palette: $store.palettes[store.cursorIndex])
                }
                .navigationTitle("\(store.name) Palettes")
                .toolbar {
                    Button {
                        store.insert(name: "", emojis: "")
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }


struct PaletteView: View {
    let palette: Palette
    
    var body: some View {
        VStack {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(palette.emojis.uniqued.map(String.init), id: \.self) { emoji in
                    NavigationLink(value: emoji) {
                        Text(emoji)
                    }
                }
            }
            .navigationDestination(for: String.self) { emoji in
                Text(emoji).font(.system(size: 300))
            }
        }
        Spacer()
    }
        .padding()
        .font(.largeTitle)
        .navigationTitle(palette.name)
}

#Preview {
    PaletteList()
}
