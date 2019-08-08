//
//  Category.swift
//  CompositionalLayout
//
//  Created by Sebastian Osiński on 05/08/2019.
//  Copyright © 2019 Sebastian Osiński. All rights reserved.
//

struct Category {
    let name: String
}

extension Category {
    static func generate(count: Int) -> [Category] {
        (0..<count).map { index in
            Category(name: "Category \(index)")
        }
    }
}
