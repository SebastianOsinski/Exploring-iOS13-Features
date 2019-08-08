//
//  App.swift
//  CompositionalLayout
//
//  Created by Sebastian Osiński on 05/08/2019.
//  Copyright © 2019 Sebastian Osiński. All rights reserved.
//

import class UIKit.UIColor
import struct CoreGraphics.CGFloat

struct App {
    let name: String
    let color: UIColor
    let badge: Int
}

extension App {
    static func generate(count: Int) -> [App] {
        (0..<count).map { index in
            let hue = CGFloat(index) / CGFloat(count)
            
            let color = UIColor(
                hue: hue,
                saturation: 1.0,
                brightness: 1.0,
                alpha: 1.0
            )
            
            return App(
                name: "App \(index)",
                color: color,
                badge: [0, 1, 3, 10, 100, 1000].randomElement()!
            )
        }
    }
}
