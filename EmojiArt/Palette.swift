//
//  Palette.swift
//  EmojiArt
//
//  Created by luis armendariz on 3/16/24.
//  Palette Model

import Foundation


struct Palette: Identifiable, Codable {
    var name: String
    var emojis: String
    var id = UUID()
    
    
    static var builtins: [Palette] { [
        Palette(name: "Vehicles", emojis: "🚗🚕")
        
    ]}
}
