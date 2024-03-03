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


final class NewTableInCollectionFavoriteTableCell:BaseTableViewCell {
    
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
        
        collectionView.register(ModeCollectionViewCell.self, forCellWithReuseIdentifier: ModeCollectionViewCell.reusableIdentifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        // MARK: 페이징 하려면 이걸 해야함
        collectionView.isPagingEnabled = false
        collectionView.decelerationRate = .fast
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

extension NewTableInCollectionFavoriteTableCell: UIScrollViewDelegate {
    
    // MARK: 스크롤 하다 멈추려 할때 발동
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // velocity = 스크롤 속도 + 면 우측 -면 좌측 스크롤
        // targetContentOffset: 스크롤 뷰의 정지할 예상지점
        if let collectionView = scrollView as? UICollectionView,
           let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            // MARK: 셀 넓이와 셀 사이 최소 간격을 합치면 최종 셀 넓이
            let cellWidth = layout.itemSize.width + layout.minimumLineSpacing
            
            // 스크롤 동작이 멈출때 컬렉션뷰가 위치할 예상 지점
            var offset = targetContentOffset.pointee
            // 컬렉션뷰의 현 x 축 오프셋에 왼쪽 인섹을 더함 / 셀 넓이만큼
            let estindex = round((offset.x + collectionView.contentInset.left) / cellWidth)
            
            var index: Int
            if velocity.x > 0 {
                // 오른쪽 스와이프할때 예상 인덱스를 올림 즉 다음셀 ceil = 소수점 올림
                index = Int(ceil(estindex))
            } else if velocity.x < 0 {
                // 왼쪽 스와이프할때 예상 인덱스를 내림 즉 다음셀
                index = Int(floor(estindex)) // floor = 소수점 내림
            } else {
                // 스와이프 정지시 가장 가까운셀로 반올림
                index = Int(round(estindex)) // round 소수점 반올림
            }
            
            // trunc 도 있는데 그냥 뒷자리 안녕~ 임
            
            // MARK: 게산된 인덱스 를 컬렉션뷰 범위와 대조
            // collectionView.numberOfItems(inSection: 0) -> 섹션 0의 아이템 개수
            // -1 : 0123 순이라 개수에서 -1
            // min 두값중 작은값
            // max 두값중 큰값
            // 즉 셀의 총 인덱스와 예상 인덱스중 누가 더 작은가?
            // 작은값과 0 중에 누가 더 큰가
            index = max(min(collectionView.numberOfItems(inSection: 0)-1, index),0)
            // 포인트를 x축으로 예상 인덱스 * 셀 넓이 즉 .   .   .    .    .   .
            // 위에 점들이 예상 인덱스라면 셀 넓이 만큼 곱하면 해당 지점에 셀이 보일것이다.
            targetContentOffset.pointee = CGPoint(x: CGFloat(index) * cellWidth , y: 0)
        }
    }
}
