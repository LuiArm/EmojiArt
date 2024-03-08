//
//  Extensions.swift
//  EmojiArt
//
//  Created by luis armendariz on 3/4/24.
//

import SwiftUI


extension CGRect {
    var center: CGPoint {
        CGPoint(x: midX, y: midY)
    }
    
    init(center: CGPoint, size: CGSize) {
        self.init(origin: CGPoint(x: center.x-size.width/2, y: center.y-size.height/2), size: size)
    }
    
}
extension String {
    // removes any duplicate characters
    // preserves the order of the characters
    
    var uniqued: String {
        // not super efficient
        // would only want to use it on small(ish) strings
        // and we wouldnt want to call it in a tight loop or something
        reduce(into: "" ) {sofar, element in
            if !sofar.contains(element) {
                sofar.append(element)
            }
        }
    }
    
}
