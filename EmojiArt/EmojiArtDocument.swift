//
//  EmojiArtDocument.swift
//  EmojiArtDocument view model
//
//  Created by luis armendariz on 3/1/24.
//

import SwiftUI

class EmojiArtDocument: ObservableObject {
    typealias Emoji = EmojiArt.Emoji
    
    @Published private var emojiArt = EmojiArt() {
        didSet {
           autoSave()
        }
    }
    
    private let autosaveURL: URL = URL.documentsDirectory.appendingPathComponent("Autosaved.emojiart")
    
    private func autoSave(){
        save(to: autosaveURL)
        print("autosave to \(autosaveURL)")
    }
    
    private func save(to url: URL) {
        do{
            let data = try emojiArt.json()
            try data.write(to: url)
        } catch let error {
            print("\(error.localizedDescription)")
        }
    }
    
    init() {
        if let data = try? Data(contentsOf: autosaveURL),
            let autosavedEmojiArt = try? EmojiArt(json: data){
                emojiArt = autosavedEmojiArt
            }
    }
    
    var emojis: [Emoji] {
        emojiArt.emojis
    }
    
    var background: URL? {
        emojiArt.background
    }
    
    // MARK: - Intent(S)
    
    func setBackground(_ url: URL?) {
        emojiArt.background = url
    }
    
    func addEmoji(_ emoji: String, at position: Emoji.Position, size: CGFloat) {
        emojiArt.addEmoji(emoji, at: position, size: Int(size))
    }
}


extension EmojiArt.Emoji {
    var font: Font {
        Font.system(size: CGFloat(size))
    }
}


extension EmojiArt.Emoji.Position {
    func `in`(_ geometry: GeometryProxy) -> CGPoint {
        let center = geometry.frame(in: .local).center
        return CGPoint(x: center.x + CGFloat(x) , y: center.y - CGFloat(y))
    }
}
