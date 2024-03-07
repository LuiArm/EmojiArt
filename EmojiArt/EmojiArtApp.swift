//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by luis armendariz on 2/29/24.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    @StateObject var defaultDocument = EmojiArtDocument()
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: defaultDocument)        }
    }
}
