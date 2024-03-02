//
//  NewTableInCollectionCell.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 3/2/24.
//

import UIKit


protocol TableInCollectionFavoriteTableDelegate: AnyObject {
    
    func numberOfItemsInSection(collectionView: UICollectionView, section : Int) -> Int
    
    func cellForItemAt(collectionView: UICollectionView ,indexPath: IndexPath) -> UICollectionViewCell
    
    func didSelectItemAt(collectionView: UICollectionView, indexPath: IndexPath )
}


class NewTableInCollectionFavoriteTableCell:BaseTableViewCell {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    weak var newDelegate: TableInCollectionFavoriteTableDelegate?
    
    override func configureHierarchy() {
        contentView.addSubview(collectionView)
    }
    
    override func configureLayout() {
        collectionView.snp.makeConstraints{ make in
            make.edges.equalToSuperview()
        }
    }

    override func registers() {
        
        collectionView.register(CoinStarCollectionViewCell.self, forCellWithReuseIdentifier: CoinStarCollectionViewCell.reusableIdentifier)
        
        collectionView.register(TopCoinCollectionViewCell.self, forCellWithReuseIdentifier: TopCoinCollectionViewCell.reusableIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        print(self)
    }
    
    
    func configureLayoutForSectionType(_ sectionType: TrendingViewSection) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        print("@@@@sectionType",sectionType)
        switch sectionType {
        case .favorite:
            print("@@@@favorite")
            layout.itemSize = CGSize(width: 200, height: 160)
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            break
        case .top15Coin, .top7NFT:
            print("@@@@top15Coin, top7NFT")
            layout.itemSize = CGSize(width: collectionView.frame.width - 20, height: 60)
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            break
        }
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.snp.remakeConstraints{ make in
            make.edges.equalToSuperview()
        }
    }
    
}


extension NewTableInCollectionFavoriteTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newDelegate?.numberOfItemsInSection(collectionView: collectionView,section: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return newDelegate?.cellForItemAt(collectionView: collectionView, indexPath: indexPath) ?? UICollectionViewCell()
    
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        newDelegate?.didSelectItemAt(collectionView: collectionView, indexPath: indexPath)
    }

}
