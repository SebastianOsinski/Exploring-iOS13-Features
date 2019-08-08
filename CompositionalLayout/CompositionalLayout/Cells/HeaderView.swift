//
//  HeaderView.swift
//  CompositionalLayout
//
//  Created by Sebastian Osiński on 05/08/2019.
//  Copyright © 2019 Sebastian Osiński. All rights reserved.
//

import UIKit

class HeaderView: UICollectionReusableView {
    @IBOutlet weak var titleLabel: UILabel!
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}
