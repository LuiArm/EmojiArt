//
//  PaletteStore.swift
//  EmojiArt
//
//  Created by luis armendariz on 3/19/24.
// VIEW MODEL

import Foundation


class PaletteStore: ObservableObject {
    let name: String
    @Published var palettes: [Palette] {
        didSet {
            if palettes.isEmpty, !oldValue.isEmpty {
                palettes = oldValue
            }
        }
    }
    
    init(named name: String) {
        self.name = name
        palettes = Palette.builtins
        
        if palettes.isEmpty {
            palettes = [Palette(name: "Warning", emojis: "⚠️")]
        }
    }
    
    @Published private var _cursorIndex = 0
    
    var cursorIndex: Int {
        get { boundsCheckedPaletteIndex(_cursorIndex)}
        set { _cursorIndex = boundsCheckedPaletteIndex(newValue)}
    }
    
    private func boundsCheckedPaletteIndex(_ index: Int) -> Int {
        var index = index % palettes.count
        if index < 0 {
            index += palettes.count
        }
        return index
    }
    
    
    
    
    ///MARK - Intents
    
    func insert(_ palette: Palette, at insertionIndex: Int? = nil) { //"at" default is cursorIndex
        let insertIndex = boundsCheckedPaletteIndex(insertionIndex ?? cursorIndex)
        if let index = palettes.firstIndex(where: {$0.id == palette.id}) {
            palettes.move(fromOffsets: IndexSet([index]), toOffset: insertionIndex ?? 0)
            palettes.replaceSubrange(insertIndex...(insertionIndex ?? 0), with: [palette])
        }else {
            palettes.insert(palette, at: insertionIndex ?? 0)
        }
    }
    
    func append(_ palette: Palette) {// at the end of palettes
        if let index = palettes.firstIndex(where: {$0.id == palette.id}) {
            if palettes.count == 1 {
                palettes = [palette]
            } else {
                palettes.remove(at: index)
                palettes.append(palette)
            }
        } else {
            palettes.append(palette)
        }
    }
    
//    func append(name: String, emojis: String) {
//        append(name: name, emojis: emojis)
//    }
}
