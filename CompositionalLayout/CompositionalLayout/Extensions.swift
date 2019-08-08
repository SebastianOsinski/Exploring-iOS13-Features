//
//  Extensions.swift
//  CompositionalLayout
//
//  Created by Sebastian Osiński on 06/08/2019.
//  Copyright © 2019 Sebastian Osiński. All rights reserved.
//

import UIKit

extension UIColor {
    static var random: UIColor {
        let randomComponent = { CGFloat.random(in: 0...1) }
        
        return UIColor(
            hue: randomComponent(),
            saturation: randomComponent(),
            brightness: randomComponent(),
            alpha: 1.0
        )
    }
    
    var inverted: UIColor {
        var (hue, saturation, brightness, alpha): (CGFloat, CGFloat, CGFloat, CGFloat) = (0.0, 0.0, 0.0, 0.0)
        
        getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        
        return UIColor(hue: 1.0 - hue, saturation: 1.0 - saturation, brightness: 1.0 - brightness, alpha: alpha)
    }
}

extension CGPoint {
    func rotate(around center: CGPoint, by angle: CGFloat) -> CGPoint {
        let transform = CGAffineTransform(translationX: -center.x, y: -center.y)
            .concatenating(.init(rotationAngle: angle))
            .concatenating(.init(translationX: center.x, y: center.y))

        
        return self.applying(transform)
    }
    
    func distance(to other: CGPoint) -> CGFloat {
        return sqrt(pow(x - other.x, 2) + pow(y - other.y, 2))
    }
}

extension CGRect {
    init(center: CGPoint, size: CGSize) {
        let origin = center.applying(.init(translationX: -size.width / 2.0, y: -size.height / 2.0))
        
        self.init(origin: origin, size: size)
    }
}

