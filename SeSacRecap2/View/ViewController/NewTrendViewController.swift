//
//  NewTrendViewController.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 3/2/24.
//

import UIKit

class NewTrendViewController: HomeBaseViewController<TableHomeView> {
    /// 트랜딩 뷰모델
    let trendingViewModel = TrendingViewModel()
    /// 즐겨찾기 뷰모델
    let favoriteViewModel = FavoriteCoinViewModel()
    /// Top 15, nft 뷰모델
    let topViewModel = Top15Top7ViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribe()
        delegateDatasource()
        settingNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        trendingViewModel.outputSection.value = []
        favoriteViewModel.maximViewWillTrigger.value = ()
        topViewModel.viewWillTrigger.value = ()

    }
    //  MARK: 딜리게이트 데이터 소스 정리
    override func delegateDatasource() {
        homeView.customTableView.dataSource = self
        homeView.customTableView.delegate = self
        homeView.customTableView.rowHeight = 200
    }
}

extension NewTrendViewController {
    func subscribe(){
        // MARK: 즐겨찾기의 결과
        favoriteViewModel.succesOutPut.bind { [weak self] void in
            guard let self else {return}
            guard void != nil else {return}
            trendingViewModel.inputSections.value.append(.favorite)
        }
        // MARK: Top 2종류 결과
        topViewModel.completeOutput.bind { [weak self] void in
            guard let self else {return}
            guard void != nil else {return}
            trendingViewModel.inputSections.value.append(.top15Coin)
            trendingViewModel.inputSections.value.append(.top7NFT)
        }
        // MARK: 트렌딩 결과
        trendingViewModel.compliteTrigger.bind { [weak self] void in
            guard let self else {return}
            guard void != nil else {return}
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.31) {
                self.homeView.customTableView.reloadData()
                print("%%%%%",self.trendingViewModel.inputSections.value.count)
            }
        }
        // MARK: ERROR
        favoriteViewModel.errorOutput.bind { [weak self] error in
            guard let self else {return}
            guard let error  else {return}
            showAlert(error: error)
        }
        topViewModel.outPutAPIError.bind {  [weak self] error in
            guard let self else {return}
            guard let error  else {return}
            showAlert(error: error)
        }
    }
}

extension NewTrendViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: 섹션넘버
    func numberOfSections(in tableView: UITableView) -> Int {
        return trendingViewModel.outputTableSectionCount.value
    }
    // MARK: 셀수
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
        
        cell.configureLayoutForSectionType(cellType[indexPath.section])
        
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
// MARK: 딜리게이트 패턴 컬렉션뷰 위임
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
        
        let resultSection = trendingViewModel.outputSection.value[collectionView.tag]
        cell.rankLabel.text = String(indexPath.item + 1)
        print("@@@@@@ cellForItemAt", resultSection)
        switch resultSection {
        case .favorite:
            favoriteViewModel.indexPathInput.value = indexPath.item
            
            favoriteCell.setupShadow(true)
            favoriteCell.coinPriceChangeView.coinViewModel.alimentCase.value = .left
            
            favoriteCell.coinPriceChangeView.coinViewModel.coinPriceModel.value = favoriteViewModel.coinPriceModelOutPut.value
            
            favoriteCell.coinInfoView.viewModel.inputModel.value = favoriteViewModel.coinInModelOutPut.value
            favoriteCell.backgroundColor = .mysharp

            favoriteCell.layer.cornerRadius = 20
            return favoriteCell
            
        case .top15Coin:
            cell.cellViewModel.vs_currency.value = .usa
            
            cell.cellViewModel.inputCoin.value = topViewModel.outputCoinItem.value?[indexPath.item]
        
            cell.coinPriceView.coinViewModel.alimentCase.value = .right
            
            dump(topViewModel.outputCoinItem.value?[indexPath.item])
            return cell
            
        case .top7NFT:
            cell.cellViewModel.vs_currency.value = .jap
           
            cell.coinPriceView.coinViewModel.alimentCase.value = .right
            cell.cellViewModel.inputNFT.value = topViewModel.outputNfts.value?[indexPath.item]
            dump(topViewModel.outputNfts.value?[indexPath.item])
            return cell
        }
        
    }
    // MARK: 셀선택시
    func didSelectItemAt(collectionView: UICollectionView, indexPath: IndexPath) {
        print("@@@@@",collectionView.tag)
        let vc = CoinChartViewController()
        
        let resultSection = trendingViewModel.outputSection.value[collectionView.tag]
        switch resultSection {
        case .favorite:
            favoriteViewModel.nextIndexPathInput.value = indexPath.item
            let selected = favoriteViewModel.nextCoinOutPut.value
            vc.viewModel.coinInfoInput.value = selected
            navigationController?.pushViewController(vc, animated: true)
        case .top15Coin:
            // topViewModel.inputIndexPath.value = (indexPath.item, .coinItem)
            guard let datas =  topViewModel.outputCoinItem.value else {return}
            let data = datas[indexPath.item]
            topViewModel.makeCoinInput.value = (nil,data)
            vc.viewModel.coinInfoInput.value = topViewModel.outPutCoin.value
            navigationController?.pushViewController(vc, animated: true)
        case .top7NFT: break

        }
    }

}
// MARK: 네비게이션 세팅
extension NewTrendViewController {
    func settingNavigation(){
        let rightImageView = CircleImageView(frame: .zero)
        rightImageView.image = UIImage(named: "tab_user_inactive")
        
        let rightBarButton = UIBarButtonItem(customView: rightImageView)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = NavigationTitleSection.Trending.title
        navigationItem.rightBarButtonItem = rightBarButton
    }
}

//            guard let datas =  topViewModel.outputNfts.value else {return}
//            let data = datas[indexPath.item]
//            topViewModel.makeCoinInput.value = (data,nil)
//            vc.viewModel.coinInfoInput.value = topViewModel.outPutCoin.value
//            navigationController?.pushViewController(vc, animated: true)
            //MARK: 혹시나 해보았지만 역시나
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
