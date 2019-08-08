//
//  BubbleCollectionViewCell.swift
//  CompositionalLayout
//
//  Created by Sebastian Osiński on 06/08/2019.
//  Copyright © 2019 Sebastian Osiński. All rights reserved.
//

import UIKit

class BubbleCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var indexLabel: UILabel!
    
    func setBubble(_ bubble: Bubble) {
        indexLabel.text = "\(bubble.index)"
        indexLabel.textColor = bubble.color.inverted
        contentView.backgroundColor = bubble.color
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layer.cornerRadius = contentView.frame.width / 2.0
    }
}
