//
//  NewTrendViewController.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 3/2/24.
//

import UIKit
enum TrendingViewSection:Int, CaseIterable{
    case favorite = 0
    case top15Coin = 1
    case top7NFT = 2
    
    var title: String{
        switch self {
        case .favorite:
            return "My Favorite"
        case .top15Coin:
            return "Top15 Coin"
        case .top7NFT:
            return "Top7 NFT"
        }
    }
    var sectionHeight: CGFloat {
        switch self {
        case .favorite:
            return 200
        case .top15Coin:
            return 66
        case .top7NFT:
            return 66
        }
    }
   
}

//순서가 뒤죽 박죽이 되버린 문제

class NewTrendViewController: HomeBaseViewController<TableHomeView> {
    
    let trendingViewModel = TrendingViewModel()

    let favoriteViewModel = FavoriteCoinViewModel()
    
    let topViewModel = Top15Top7ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribe()
        delegateDatasource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        trendingViewModel.outputSection.value = []
        
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
            guard void != nil else {return}
            trendingViewModel.inputSections.value.append(.favorite)
        }
        topViewModel.completeOutput.bind { [weak self] void in
            guard let self else {return}
            guard void != nil else {return}
            trendingViewModel.inputSections.value.append(.top15Coin)
            trendingViewModel.inputSections.value.append(.top7NFT)
        }
        trendingViewModel.compliteTrigger.bind { [weak self] void in
            guard let self else {return}
            guard void != nil else {return}
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.homeView.customTableView.reloadData()
                print("%%%%%",self.trendingViewModel.inputSections.value.count)
            }
        }
        
    }
}

extension NewTrendViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("^^^^^^ 트렌딩 아웃풋", trendingViewModel.outputTableSectionCount.value)
        return trendingViewModel.outputTableSectionCount.value
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewTableInCollectionFavoriteTableCell.reusableIdentifier, for: indexPath) as? NewTableInCollectionFavoriteTableCell else {
            print("레지스터 문제")
            return UITableViewCell()
        }
        
        let cellType = trendingViewModel.outputSection.value
            
        // 컬렉션뷰에 태그 달아서 컬렉션 뷰가 무슨 섹션인지 알게하는게 최선이라고 봄
        cell.collectionView.tag = indexPath.section
        
        print("^^^^^^",cell.collectionView.tag)
        
        cell.configureLayoutForSectionType(cellType[indexPath.section])
        
        print("@@@@ viewConCellType",cellType)
        
        cell.newDelegate = self
        
        DispatchQueue.main.async{
            cell.collectionView.reloadData()
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if trendingViewModel.outputSection.value.isEmpty {
            return nil
        }
        
        let cellType = trendingViewModel.outputSection.value[section]
        let headerView = CustomHeaderView()
        
        headerView.titleLabel.text = cellType.title
        return headerView
    }
}

extension NewTrendViewController: TableInCollectionFavoriteTableDelegate {
    func numberOfItemsInSection(collectionView: UICollectionView, section: Int) -> Int {
        let resultSection = trendingViewModel.outputSection.value[collectionView.tag]
        print("@@@@@@ numberOfItemsInSection", resultSection)
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
        cell.backgroundColor = .darkKey
        // favoriteCell.backgroundColor = .mySky
        
        let resultSection = trendingViewModel.outputSection.value[collectionView.tag]
        
        print("@@@@@@ cellForItemAt", resultSection)
        switch resultSection {
        case .favorite:
            favoriteViewModel.indexPathInput.value = indexPath.item
            
            favoriteCell.setupShadow(true)
            favoriteCell.coinPriceChangeView.coinViewModel.alimentCase.value = .left
            
            favoriteCell.coinPriceChangeView.coinViewModel.coinPriceModel.value = favoriteViewModel.coinPriceModelOutPut.value
            
            favoriteCell.coinInfoView.viewModel.inputModel.value = favoriteViewModel.coinInModelOutPut.value
            favoriteCell.backgroundColor = .mysharp
            // favoriteCell.backgroundColor = .myPink
            favoriteCell.layer.cornerRadius = 20
            return favoriteCell
        case .top15Coin:
            cell.cellViewModel.vs_currency.value = .usa
            cell.cellViewModel.inputCoin.value = topViewModel.outputCoinItem.value?[indexPath.item]
            cell.rankLabel.text = String(indexPath.item)
            
            return cell
        case .top7NFT:
            cell.cellViewModel.vs_currency.value = .jap
            cell.rankLabel.text = String(indexPath.item)
            cell.cellViewModel.inputNFT.value = topViewModel.outputNfts.value?[indexPath.item]
            return cell
        }
        
    }
    
    func didSelectItemAt(collectionView: UICollectionView, indexPath: IndexPath) {
        print("@@@@@",collectionView.tag)
    }

}
//        trendingViewModel.outputTableSectionCount.bind { [weak self] _ in
//            guard let self else {return}
//            homeView.customTableView.reloadData()
//        }
//        favoriteViewModel.testOiu.bind { [weak self] void in
//            guard let self else {return}
//            guard void != nil else {return}
//
//            homeView.customTableView.deleteSections(IndexSet(0...0), with: .automatic)
//        }



// trendingViewModel.trigger.value = ()
//            trendingViewModel.inputSection.value = [.favorite: true]
//
//            trendingViewModel.inputSection.value?[.favorite] = true


/*
 //            trendingViewModel.inputSection.value?.updateValue(true, forKey: .top15Coin)
 //            trendingViewModel.inputSection.value?.updateValue(true, forKey: .top7NFT)
 
 // trendingViewModel.inputSections.value = [.top15Coin]
 
 /*rendingViewModel.inputSections.value?.insert(.top15Coin)*/
 */
