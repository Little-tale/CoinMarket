//
//  NewTrendViewController.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 3/2/24.
//

import UIKit

class NewTrendViewController: HomeBaseViewController<TableHomeView> {
    
    let trendingViewModel = TrendingViewModel()
    // 일단은 여기에 박아보자
    let favoriteViewModel = FavoriteCoinViewModel()
    
    let topViewModel = Top15Top7ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribe()
        delegateDatasource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        favoriteViewModel.maximViewWillTrigger.value = ()
        topViewModel.viewWillTrigger.value = ()
    }
    
    override func delegateDatasource() {
        homeView.customTableView.dataSource = self
        homeView.customTableView.delegate = self
        homeView.customTableView.rowHeight = 200
    }
}

extension NewTrendViewController {
    func subscribe(){
        favoriteViewModel.succesOutPut.bind { [weak self] void in
            guard let self else {return}
            guard let void else {return}
            trendingViewModel.inputSection.value = [.favorite: true]
        }
        topViewModel.completeOutput.bind { [weak self] void in
            guard let self else {return}
            guard let void else {return}
            trendingViewModel.inputSection.value = [.top15Coin:true, .top7NFT: true]
        }
        trendingViewModel.outputTableSectionCount.bind { [weak self] _ in
            guard let self else {return}
            homeView.customTableView.reloadData()
        }
        
    }
}

extension NewTrendViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trendingViewModel.outputTableSectionCount.value
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewTableInCollectionFavoriteTableCell.reusableIdentifier, for: indexPath) as? NewTableInCollectionFavoriteTableCell else {
            print("레지스터 문제")
            return UITableViewCell()
        }
        
        let cellType = trendingViewModel.outputSection.value
            
        // 컬렉션뷰에 태그 달아서 컬렉션 뷰가 무슨 섹션인지 알게하는게 최선이라고 봄
        cell.collectionView.tag = indexPath.row
        cell.configureLayoutForSectionType(cellType[indexPath.row])
        cell.newDelegate = self
        return cell
    }

}

extension NewTrendViewController: TableInCollectionFavoriteTableDelegate {
    func numberOfItemsInSection(collectionView: UICollectionView, section: Int) -> Int {
        let resultSection = trendingViewModel.outputSection.value[collectionView.tag]
        switch resultSection {
        case .favorite:
            return favoriteViewModel.succesOutPut.value?.count ?? 0
        case .top15Coin:
            return topViewModel.outputCoinItem.value?.count ?? 0
        case .top7NFT:
            return topViewModel.outputNfts.value?.count ?? 0
        }
    }
    
    func cellForItemAt(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopCoinCollectionViewCell.reusableIdentifier, for: indexPath) as? TopCoinCollectionViewCell else {
            print("custom Cell Error Check Plz THX")
            return UICollectionViewCell()
        }
        guard let favoriteCell = collectionView.dequeueReusableCell(withReuseIdentifier: CoinStarCollectionViewCell.reusableIdentifier, for: indexPath) as? CoinStarCollectionViewCell else {
            print("custom Cell Error Check Plz THX")
            return UICollectionViewCell()
        }
        
        let resultSection = trendingViewModel.outputSection.value[collectionView.tag]
        switch resultSection {
        case .favorite:
            favoriteCell.coinPriceChangeView.coinViewModel.alimentCase.value = .left
            favoriteCell.coinPriceChangeView.coinViewModel.coinPriceModel.value = favoriteViewModel.coinPriceModelOutPut.value
            favoriteCell.coinInfoView.viewModel.inputModel.value = favoriteViewModel.coinInModelOutPut.value
            return favoriteCell
        case .top15Coin:
            cell.cellViewModel.inputCoin.value = topViewModel.outputCoinItem.value
            return topViewModel.outputCoinItem.value?.count ?? 0
        case .top7NFT:
            return topViewModel.outputNfts.value?.count ?? 0
        }
    }
    
    func didSelectItemAt(collectionView: UICollectionView, indexPath: IndexPath) {
        <#code#>
    }
    
    
}
