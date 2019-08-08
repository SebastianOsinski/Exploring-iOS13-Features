//
//  AppStoreLayoutBuilder.swift
//  CompositionalLayout
//
//  Created by Sebastian Osiński on 05/08/2019.
//  Copyright © 2019 Sebastian Osiński. All rights reserved.
//

import UIKit

struct AppStoreLayoutBuilder {
    func buildLayout(sectionRef: @escaping (() -> [AppStoreSection])) -> UICollectionViewCompositionalLayout {
        let sectionProvider: UICollectionViewCompositionalLayoutSectionProvider = { sectionIndex, environment in
            let sections = sectionRef()
            let section = sections[sectionIndex]
            
            switch section {
            case .banners: return Self.bannersSection()
            case .apps(_, let perColumntCount, _): return Self.appsSection(perColumntCount: perColumntCount)
            case .categories: return Self.categoriesSection()
            case .bubbles: return Self.bubblesSection()
            }
        }
        
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        
        return UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: configuration)
    }
    
    private static func bannersSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(300.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 10.0
        section.contentInsets = NSDirectionalEdgeInsets(top: 10.0, leading: 0.0, bottom: 10.0, trailing: 0.0)
        
        return section
    }
    
    private static func appsSection(perColumntCount: Int) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.33))
        let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [badgeSupplementaryItem()])
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(200.0))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: perColumntCount)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        section.interGroupSpacing = 10.0
        section.contentInsets = NSDirectionalEdgeInsets(top: 10.0, leading: 0.0, bottom: 10.0, trailing: 0.0)
        
        section.boundarySupplementaryItems = [headerSupplementaryItem()]
        
        return section
    }
    
    private static func categoriesSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(40.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(200.0))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 5)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        section.boundarySupplementaryItems = [headerSupplementaryItem()]
        
        return section
    }
    
    private static func bubblesSection() -> NSCollectionLayoutSection {
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
        
        let itemRadius: CGFloat = 25.0
        let itemsCount = 16
        
        let group = NSCollectionLayoutGroup.custom(layoutSize: groupSize) { environment -> [NSCollectionLayoutGroupCustomItem] in
            let containerSize = environment.container.contentSize
            
            let center = CGPoint(x: containerSize.width / 2.0, y: containerSize.height / 2.0)
            let circleRadius = containerSize.width / 2.0 * 0.8

            let startPoint = center.applying(.init(translationX: -circleRadius, y: 0.0))

            let items = (0..<itemsCount).map { index -> NSCollectionLayoutGroupCustomItem in
                let itemCenter = startPoint.rotate(around: center, by: CGFloat(index) / CGFloat(itemsCount) * 2.0 * .pi)
                let itemFrame = CGRect(center: itemCenter, size: CGSize(width: itemRadius * 2.0, height: itemRadius * 2.0))

                return NSCollectionLayoutGroupCustomItem(frame: itemFrame, zIndex: index)
            }
            
//            let availableHeight = containerSize.height - 2.0 * itemRadius
//            let availableWidth = containerSize.width - 2.0 * itemRadius
//
//            let items = (0..<itemsCount).map { index -> NSCollectionLayoutGroupCustomItem in
//                let multiplier = CGFloat(index) / CGFloat(itemsCount)
//                let value = sin(multiplier * 2.0 * .pi)
//                let adjustedValue = (value + 1.0) * availableHeight / 2.0
//
//                let itemCenter = CGPoint(x: itemRadius + availableWidth * multiplier, y: itemRadius + adjustedValue)
//                let itemFrame = CGRect(center: itemCenter, size: CGSize(width: itemRadius * 2.0, height: itemRadius * 2.0))
//
//                return NSCollectionLayoutGroupCustomItem(frame: itemFrame, zIndex: index)
//            }
            
            
            return items
        }
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = -2.0 * itemRadius
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
    
    private static func headerSupplementaryItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(60.0))
        let headerSupplementaryItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: headerKind,
            alignment: .top
        )
        
        return headerSupplementaryItem
    }
    
    private static func badgeSupplementaryItem() -> NSCollectionLayoutSupplementaryItem {
        let badgeSize = NSCollectionLayoutSize(widthDimension: .estimated(20.0), heightDimension: .absolute(20.0))
        
        let badgeAnchor = NSCollectionLayoutAnchor(edges: [.top, .leading], absoluteOffset: CGPoint(x: 20.0, y: 20.0))
        let badgeItem = NSCollectionLayoutSupplementaryItem(
            layoutSize: badgeSize,
            elementKind: badgeKind,
            containerAnchor: badgeAnchor,
            itemAnchor: badgeAnchor
        )
        
        badgeItem.zIndex = 10
        
        return badgeItem
    }
}
