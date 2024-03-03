//
//  TableInCollectionTableCell.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 3/1/24.
//

import UIKit
import SnapKit



// MARK: UI를 변경을 하는데 뷰모델이 하는게 맞나?
// var section: TrendingViewSection = .favorite

// 프로토콜 채택
// weak var customDelegate: TableInCollectionFavoriteTableDelegate?

final class TableInCollectionFavoriteTableCell: BaseTableViewCell {
    // MARK: 바인딩으로 하려했으나 이친구가 먼저 로드됨
    lazy var collecionView = UICollectionView(frame: .zero, collectionViewLayout: configureCellLayout())
    
    let tableviewModel = TableViewCollectionCellStylerViewModel()    
    
    var vs_cointry = vsCurrency.kor
    
    override func configureHierarchy() {
        contentView.addSubview(collecionView)
    }
    override func configureLayout() {
        collecionView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
            // make.height.equalTo(90)
        }
    }
    
    override func registers() {
        collecionView.register(CoinStarCollectionViewCell.self, forCellWithReuseIdentifier: CoinStarCollectionViewCell.reusableIdentifier)
        print(self)
    }
    
    override func designView() {
        collecionView.dataSource = self
        collecionView.delegate = self
        subscribe()
    }
}

extension TableInCollectionFavoriteTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return customDelegate?.numberOfItemsInSection(section: section) ?? 0
        guard tableviewModel.inputSection.value != nil else {
            return 0
        }
       // MARK: 즐겨찾기일때
        if let favorite = tableviewModel.inputFavoriteData.value {
            return favorite.count
        }
        
        return 0
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        return customDelegate?.cellForItemAt(collectionView: collectionView, indexPath: indexPath) ?? UICollectionViewCell()
        guard let caseof = tableviewModel.inputSection.value else {
            return UICollectionViewCell()
        }
        switch caseof {
        case .favorite:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoinStarCollectionViewCell.reusableIdentifier, for: indexPath) as? CoinStarCollectionViewCell else {
                return UICollectionViewCell()
            }
            let coinInfo = tableviewModel.coinInModelOutPut.value[indexPath.item]
                   // print("@@@@데이터 ",tableviewModel.coinInModelOutPut.value)
            cell.coinInfoView.viewModel.inputModel.value = coinInfo
            let coinPrice = tableviewModel.coinPriceModelOutPut.value[indexPath.item]
            
            cell.coinPriceChangeView.coinViewModel.coinPriceModel.value = coinPrice
            
                   cell.layer.cornerRadius = 12
                   // cell.clipsToBounds = true
            cell.backgroundColor = .mysharp
            return cell
        case .top15Coin:
            return UICollectionViewCell()
        case .top7NFT:
           return UICollectionViewCell()
        }
       
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        customDelegate?.didSelectItemAt(collectionView: collectionView, indexPath: indexPath)
        
        
    }
    
}

extension TableInCollectionFavoriteTableCell {
    
    private func configureCellLayout(scction: TrendingViewSection){
        let layout = UICollectionViewFlowLayout()
    
        let spacing : CGFloat = 15
        let cellWidth = UIScreen.main.bounds.width - (spacing * 3)
        
        switch scction {
        case .favorite:
            layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        case .top15Coin:
            layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        case .top7NFT:
            layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        }
        
        layout.itemSize = CGSize(width: cellWidth / 1.5, height: scction.sectionHeight) // 셀의 크기
        
        layout.scrollDirection = .horizontal

        collecionView.setCollectionViewLayout(layout, animated: true)
    }
    
    func configureCellLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        let spacing : CGFloat = 10
        let cellWidth = UIScreen.main.bounds.width - (spacing * 3)
        
        layout.itemSize = CGSize(width: cellWidth / 2, height: (cellWidth) / 2) // 셀의 크기
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.scrollDirection = .vertical
        
        return layout
    }

    

}

extension TableInCollectionFavoriteTableCell {
    func subscribe(){
        tableviewModel.inputSection.bind {[weak self] section in
            guard let self else {return}
            guard let section else {return}
            
            configureCellLayout(scction: section)
        }
    }
}





