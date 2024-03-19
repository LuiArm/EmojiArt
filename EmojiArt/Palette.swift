//
//  Palette.swift
//  EmojiArt
//
//  Created by luis armendariz on 3/16/24.
//  Palette Model

import Foundation


struct Palette: Identifiable {
    var name: String
    var emojis: String
    let id = UUID()
    
    
    static let builtins = [
    Palette(name: "Vehicles", emojis: "🚗🚕")
    
    ]
}
