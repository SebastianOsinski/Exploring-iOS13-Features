//
//  AppCollectionViewCell.swift
//  CompositionalLayout
//
//  Created by Sebastian Osiński on 05/08/2019.
//  Copyright © 2019 Sebastian Osiński. All rights reserved.
//

import UIKit

class AppCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    
    func setApp(_ app: App) {
        nameLabel.text = app.name
        colorView.backgroundColor = app.color
    }
}
