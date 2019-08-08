//
//  Bubble.swift
//  CompositionalLayout
//
//  Created by Sebastian Osiński on 06/08/2019.
//  Copyright © 2019 Sebastian Osiński. All rights reserved.
//

import class UIKit.UIColor
import struct CoreGraphics.CGFloat

struct Bubble {
    let index: Int
    let color: UIColor
}

extension Bubble {
    static func generate(count: Int) -> [Bubble] {
        return (0..<count).map { index in
            Bubble(index: index, color: .random)
        }
    }
}
