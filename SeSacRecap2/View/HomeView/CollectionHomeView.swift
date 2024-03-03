//
//  CollectionHomeView.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 2/29/24.
//

import UIKit
import SnapKit

final class CollectionHomeView: BaseView {
    lazy var collectionCoinView = UICollectionView(frame: .zero, collectionViewLayout: configureCellLayout())
    
    override func configureHierarchy() {
        self.addSubview(collectionCoinView)
    }
    override func configureLayout() {
        collectionCoinView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func register() {
        collectionCoinView.register(CoinStarCollectionViewCell.self, forCellWithReuseIdentifier: CoinStarCollectionViewCell.reusableIdentifier)
        collectionCoinView.isScrollEnabled = true
        
        collectionCoinView.alwaysBounceVertical = true
    }
}
extension CollectionHomeView {
    func configureCellLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing : CGFloat = 24
        let cellWidth = UIScreen.main.bounds.width - (spacing * 3)
        layout.itemSize = CGSize(width: cellWidth / 2, height: (cellWidth) / 2) // 셀의 크기
        
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        layout.scrollDirection = .vertical
        
        return layout
    }

}

extension CollectionHomeView: UICollectionViewDelegateFlowLayout {
    
}
