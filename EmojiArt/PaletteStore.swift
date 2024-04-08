//
//  PaletteStore.swift
//  EmojiArt
//
//  Created by luis armendariz on 3/19/24.
// VIEW MODEL

import Foundation

extension UserDefaults {
    func palettes(forKey key: String) -> [Palette]{
        if let jsonData = data(forKey: key),
           let decodedPalettes = try? JSONDecoder().decode([Palette].self, from: jsonData){
            return decodedPalettes
        }else {
            return []
        }
    }
    func set(_ palettes: [Palette], forKey key: String ){
        let data = try? JSONEncoder().encode(palettes)
        set(data, forKey: key)
    }
    
}
class PaletteStore: ObservableObject {
    private var userDefaultsKey: String {"PaletteStore" + name}
    
    let name: String
    var palettes: [Palette] {
        get {
            UserDefaults.standard.palettes(forKey: userDefaultsKey)
        }
        set {
            if !newValue.isEmpty {
                UserDefaults.standard.set(newValue, forKey: userDefaultsKey)
                objectWillChange.send()
            }
        }
    }
    
    
    
    init(named name: String) {
        self.name = name
        if palettes.isEmpty{
            palettes = Palette.builtins
            if palettes.isEmpty {
                palettes = [Palette(name: "Warning", emojis: "⚠️")]
            }
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
    
    // these functions are the recommend to add Palettes to the PaletteStore
    // since they try to avoid duplication Identifiable-ly identical Palettes
    // by first removing/replacing any Palette with the same id that is already in palettes
    // it does not "remedy" existing duplication, it just does not "cause" new duplication
    
    func insert(_ palette: Palette, at insertionIndex: Int? = nil) { //"at" default is cursorIndex
        let insertIndex = boundsCheckedPaletteIndex(insertionIndex ?? cursorIndex)
        if let index = palettes.firstIndex(where: {$0.id == palette.id}) {
            palettes.move(fromOffsets: IndexSet([index]), toOffset: insertionIndex ?? 0)
            palettes.replaceSubrange(insertIndex...(insertionIndex ?? 0), with: [palette])
        }else {
            palettes.insert(palette, at: insertionIndex ?? 0)
        }
    }
    
    func insert(name: String, emojis: String, at index: Int? = nil) {
        insert(Palette(name: name, emojis: emojis), at: index)
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
    
    func append(name: String, emojis: String) {
        append(Palette(name: name, emojis: emojis))
    }
}
