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
            if emojiArt.background != oldValue.background {
                Task {
                    await fetchBackgroundImage()
                }
            }
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
    
//    var background: URL? {
//        emojiArt.background
//    }
    @Published var background: Background = .none
    
    // MARK: - Background Image
    
    @MainActor
    func fetchBackgroundImage() async {
        if let url = emojiArt.background {
            background = .fetching(url)
            do {
                let image = try await fetchUIImage(from: url)
                if url == emojiArt.background {
                    background = .found(try await fetchUIImage(from: url))
                }
            } catch {
                background = .failed("Could not set background: \(error.localizedDescription)")
            }
           
        } else {
            background = .none
        }
    }
    
    private func fetchUIImage(from url: URL) async throws -> UIImage {
        let (data, _) = try await URLSession.shared.data(from: url)
        if let uiImage = UIImage(data: data){
            return uiImage
        } else {
            throw FetchError.badImageData
        }
    }
    
    enum FetchError: Error {
        case badImageData
    }
    
    enum Background {
        case none
        case fetching(URL)
        case found(UIImage)
        case failed(String)
        
        var uiImage: UIImage? {
            switch self {
            case .found(let uiImage): return uiImage
            default: return nil
            }
        }
        
        var urlBeingFetched: URL? {
            switch self {
            case .fetching(let url): return url
            default: return nil
            }
        }
        
        var isFetching: Bool { urlBeingFetched != nil }
        
        var failureReason: String? {
            switch self {
            case .failed(let reason): return reason
            default: return nil
            }
        }
        
        
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
