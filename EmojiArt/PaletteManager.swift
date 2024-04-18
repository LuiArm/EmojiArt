//
//  PaletteManager.swift
//  EmojiArt
//
//  Created by luis armendariz on 4/17/24.
//

import SwiftUI

struct PaletteManager: View {
    let stores: [PaletteStore]
    @State private var selectedStore: PaletteStore?
    var body: some View {
        NavigationSplitView {
            List(stores, selection: $selectedStore) { store in
                Text(store.name)
                    .tag(store)
            }
        } content: {
            if let selectedStore {
                PaletteList(store: selectedStore)
            }
            Text("Choose a Store")
        } detail: {
            Text("Choose a palette")
        }
    }
}

//#Preview {
//    PaletteManager()
//}
