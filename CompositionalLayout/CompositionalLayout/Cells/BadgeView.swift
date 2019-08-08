//
//  BadgeView.swift
//  CompositionalLayout
//
//  Created by Sebastian Osiński on 06/08/2019.
//  Copyright © 2019 Sebastian Osiński. All rights reserved.
//

import UIKit

class BadgeView: UICollectionReusableView {
    @IBOutlet weak var countLabel: UILabel!
    
    func setCount(_ count: Int) {
        countLabel.text = "\(count)"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.height / 2.0
    }
}
