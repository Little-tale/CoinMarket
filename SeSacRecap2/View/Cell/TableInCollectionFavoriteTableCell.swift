//
//  TableInCollectionTableCell.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 3/1/24.
//

import UIKit
import SnapKit

protocol TableInCollectionFavoriteTableDelegate: AnyObject {
    func numberOfItemsInSection(section : Int) -> Int
    func cellForItemAt(collectionView: UICollectionView ,indexPath: IndexPath) -> UICollectionViewCell
}


class TableInCollectionFavoriteTableCell: BaseTableViewCell {
    
    lazy var collecionView = UICollectionView(frame: .zero, collectionViewLayout: configureCellLayout())
    // 프로토콜 채택
    weak var customDelegate: TableInCollectionFavoriteTableDelegate?
    
    
    override func configureHierarchy() {
        contentView.addSubview(collecionView)
    }
    override func configureLayout() {
        collecionView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    override func registers() {
        collecionView.register(CoinStarCollectionViewCell.self, forCellWithReuseIdentifier: CoinStarCollectionViewCell.reusableIdentifier)
    }
}

extension TableInCollectionFavoriteTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        customDelegate?.numberOfItemsInSection(section: section) ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let customDelegate else {return UICollectionViewCell()}
        guard let cell = customDelegate.cellForItemAt(collectionView: collectionView, indexPath: indexPath) as? CoinStarCollectionViewCell else {
            return UICollectionViewCell()
        }

        return cell
    }
    
    
}

extension TableInCollectionFavoriteTableCell {
    func configureCellLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        let spacing : CGFloat = 15
        let cellWidth = UIScreen.main.bounds.width - (spacing * 3)
        
        layout.itemSize = CGSize(width: cellWidth / 1.5, height: (cellWidth) / 2) // 셀의 크기
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.scrollDirection = .horizontal
        return layout
    }

}





