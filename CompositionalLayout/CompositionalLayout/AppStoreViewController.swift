//
//  AppStoreViewController.swift
//  CompositionalLayout
//
//  Created by Sebastian Osiński on 04/08/2019.
//  Copyright © 2019 Sebastian Osiński. All rights reserved.
//

import UIKit

enum AppStoreSection {
    case banners([App])
    case apps(title: String, perColumnCount: Int, [App])
    case categories(title: String, [Category])
    case bubbles([Bubble])
    
    var itemsCount: Int {
        switch self {
        case .banners(let apps), .apps(_, _, let apps): return apps.count
        case .categories(_, let categories): return categories.count
        case .bubbles(let bubbles): return bubbles.count
        }
    }
}

let bannerCellIdentifier = "BannerCell"
let appCellIdentifier = "AppCell"
let categoryCellIdentifier = "CategoryCell"
let bubbleCellIdentifier = "BubbleCell"
let headerKind = "Header"
let headerIdentifier = "Header"
let badgeKind = "Badge"
let badgeIdentifier = "Badge"

class AppStoreViewController: UIViewController {
    var sections: [AppStoreSection] = [
        .banners(App.generate(count: 10)),
        .apps(title: "Best apps", perColumnCount: 3, App.generate(count: 10)),
        .banners(App.generate(count: 10)),
        .apps(title: "Average apps", perColumnCount: 2, App.generate(count: 10)),
        .categories(title: "Top Categories", Category.generate(count: 10)),
        .bubbles(Bubble.generate(count: 100))
    ]
    
    private var collectionView: UICollectionView!
    private var layout: UICollectionViewCompositionalLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            print("RELOAD")
            
            self.collectionView.performBatchUpdates({
                self.collectionView.insertSections(IndexSet(integer: 0))
                            self.sections.insert(.apps(title: "Zajebiste apki", perColumnCount: 4, App.generate(count: 20)), at: 0)
            })
            

        }
    }
    
    private func setupCollectionView() {
        layout = AppStoreLayoutBuilder().buildLayout(
            sectionRef: { [weak self] in self?.sections ?? [] }
        )
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(UINib(nibName: "BannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: bannerCellIdentifier)
        collectionView.register(UINib(nibName: "AppCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: appCellIdentifier)
        collectionView.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: categoryCellIdentifier)
        collectionView.register(UINib(nibName: "BubbleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: bubbleCellIdentifier)
        
        collectionView.register(UINib(nibName: "HeaderView", bundle: nil), forSupplementaryViewOfKind: headerKind, withReuseIdentifier: headerIdentifier)
        collectionView.register(UINib(nibName: "BadgeView", bundle: nil), forSupplementaryViewOfKind: badgeKind, withReuseIdentifier: badgeIdentifier)
        
        collectionView.dataSource = self
        
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(collectionView)
        collectionView.frame = view.bounds
        collectionView.backgroundColor = .systemBackground
    }
}

extension AppStoreViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]
        
        switch section {
        case .banners(let apps):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: bannerCellIdentifier, for: indexPath) as! BannerCollectionViewCell
            
            cell.setApp(apps[indexPath.item])
            
            return cell
        case .apps(_, _, let apps):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: appCellIdentifier, for: indexPath) as! AppCollectionViewCell
            
            cell.setApp(apps[indexPath.item])
            
            return cell
        case .categories(_, let categories):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCellIdentifier, for: indexPath) as! CategoryCollectionViewCell
            
            cell.setCategory(categories[indexPath.item])
            
            return cell
        case .bubbles(let bubbles):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: bubbleCellIdentifier, for: indexPath) as! BubbleCollectionViewCell
            
            cell.setBubble(bubbles[indexPath.item])
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let section = sections[indexPath.section]
        
        switch section {
        case .apps(let title, _, _) where kind == headerKind, .categories(let title, _) where kind == headerKind:
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: headerKind, withReuseIdentifier: headerIdentifier, for: indexPath) as! HeaderView
            
            view.setTitle(title)
            
            return view
        case .apps(_, _, let apps) where kind == badgeKind:
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: badgeKind, withReuseIdentifier: badgeIdentifier, for: indexPath) as! BadgeView
            
            let badge = apps[indexPath.item].badge
            view.setCount(badge)
            view.isHidden = badge == 0
            
            return view
        default:
            fatalError()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].itemsCount
    }
}
