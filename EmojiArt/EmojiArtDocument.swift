//
//  EmojiArtDocument.swift
//  EmojiArtDocument view model
//
//  Created by luis armendariz on 3/1/24.
//

import SwiftUI
import UniformTypeIdentifiers

class EmojiArtDocument: ReferenceFileDocument {
    func snapshot(contentType: UTType) throws -> Data {
        <#code#>
    }
    
    func fileWrapper(snapshot: Data, configuration: WriteConfiguration) throws -> FileWrapper {
        <#code#>
    }
    
    typealias Snapshot = Data
    
    static var readableContentTypes: [UTType]
    
    required init(configuration: ReadConfiguration) throws {
        <#code#>
    }
    
    typealias Emoji = EmojiArt.Emoji
    
    @Published private var emojiArt = EmojiArt() {
        didSet {
            if emojiArt.background != oldValue.background {
                Task {
                    await fetchBackgroundImage()
                }
            }
        }
    }
    
    
    init() { }
    
    var emojis: [Emoji] {
        emojiArt.emojis
    }
    
    var bbox: CGRect {
        var bbox = CGRect.zero
        for emoji in emojiArt.emojis {
            bbox = bbox.union(emoji.bbox)
        }
        if let backgroundSize = background.uiImage?.size {
            bbox = bbox.union(CGRect(center: .zero, size: backgroundSize))
        }
        return bbox
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
    var bbox: CGRect {
        CGRect(center: position.in(nil), size: CGSize(width: CGFloat(size), height: CGFloat(size)))
    }
}


extension EmojiArt.Emoji.Position {
    func `in`(_ geometry: GeometryProxy?) -> CGPoint {
        let center = geometry?.frame(in: .local).center ?? .zero
        return CGPoint(x: center.x + CGFloat(x) , y: center.y - CGFloat(y))
    }
}
