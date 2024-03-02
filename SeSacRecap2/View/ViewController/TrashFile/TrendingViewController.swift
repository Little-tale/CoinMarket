//
//  TrendingViewController.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 3/1/24.
//

import UIKit
// MARK: 일단 고민해 봐야할 부분은 각 섹션별 데이터를 담을 그릇을 가지는 것이
// 필요해 보인다 그러고 나서는 1번쟤 섹션은 자료가 2개 이상일때만 나올수 있게 해야한다.
// top 15에서는 셀들이 아래 방향 스크롤 우축으로 하는 방식이다 이 부분은 일단 위의 것을 해결해 보고 해결하자
// 3번째도 마찬가지

//        case .trending: // 탑 15 탑 7
//            Trending.self
//        case .CoinMarket: // favorite Coin
//            [CoinMarket].self
// FavoriteCoinViewModel(즐겨찾기에서 쓸 뷰모델
//  FavoriteCoinViewModel

// 다 뷰컨에서 해야 한는가? 그것도 애매하다
// 셀에게 넘기냐? 그것도 애매하다.
//


// MARK: 1번 네트워크 테스트
// MARK: 2번 탑 15 탑 7의 전용 구조체를 고민
// MARK: 3번 공통 컬렉션뷰 셀 구성



// 일단 뷰모델 재사용을 해보자
// 콤포지션 컬렉션뷰 를 발견했는데 한번 적용시켜보자
//class TrendingViewController: HomeBaseViewController<TableHomeView> {
//    //
//    let trendingViewModel = TrendingViewModel()
//    // 일단은 여기에 박아보자
//    let favoriteViewModel = FavoriteCoinViewModel()
//    
//    let topViewModel = Top15Top7ViewModel()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        subscribe()
//        delegateDataSource()
//    }
//    
//}
//
//extension TrendingViewController{
//    func delegateDataSource(){
//        homeView.customTableView.dataSource = self
//        homeView.customTableView.delegate = self
//        homeView.customTableView.backgroundColor = .white
//        
//    }
//}
//
//
//extension TrendingViewController: UITableViewDelegate, UITableViewDataSource {
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 200
//    }
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        
//        let headerView = CustomHeaderView()
//        headerView.titleLabel.text = trendingViewModel.outputSection.value[section].title
//        
//        return headerView
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return trendingViewModel.outputSection.value.count
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print(#function)
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableInCollectionFavoriteTableCell.reusableIdentifier, for: indexPath) as? TableInCollectionFavoriteTableCell else {
//            print("레지스터 문제")
//            return UITableViewCell()
//        }
//        // cell.customDelegate = self
//        cell.backgroundColor = .red
//        cell.collecionView.reloadData()
//        
//        let section = trendingViewModel.outputSection.value[indexPath.section]
//        cell.tableviewModel.inputSection.value = section
//        switch section {
//        case .favorite:
//            let vsCoin = vsCurrency.kor
//            cell.vs_cointry = vsCoin
//            cell.tableviewModel.inputFavoriteData.value = favoriteViewModel.succesOutPut.value
//            //cell.section = .favorite
//        case .top15Coin:
//            let vsCoin = vsCurrency.usa
//            cell.vs_cointry = vsCoin
//        
//        case .top7NFT:
//            let vsCoin = vsCurrency.jap
//            cell.vs_cointry = vsCoin
//        }
//        
//        return cell
//    }
//    
//}
//
//extension TrendingViewController {
//    func subscribe(){
//        favoriteViewModel.succesOutPut.bind { [weak self] data in
//            guard let self else {return}
//            
//            guard data != nil else {
//                trendingViewModel.inputSection.value = [.favorite:false]
//                homeView.customTableView.reloadData()
//                return
//            }
//            trendingViewModel.inputSection.value = [.favorite:true]
//            homeView.customTableView.reloadData()
//        }
//        favoriteViewModel.nextCoinOutPut.bind { [weak self] coinModel in
//            guard let self else {return}
//            guard let coinModel else {return}
//            let vc = CoinChartViewController()
//            vc.viewModel.coinInfoInput.value = coinModel
//            vc.viewModel.inputViewdidLoadTrigger.bind {[weak self] _ in
//                guard self != nil else {return}
//            }
//            navigationController?.pushViewController(vc, animated: true)
//        }
//        topViewModel.outputNfts.bind {[weak self] coinModel in
//            guard let self else {return}
//            guard let coinModel else {return}
//            trendingViewModel.inputSection.value = [.top15Coin:true]
//           //  homeView.customTableView.reloadData()
//        }
//        topViewModel.outputCoinItem.bind {[weak self] coinModel in
//            guard let self else {return}
//            guard let coinModel else {return}
//            trendingViewModel.inputSection.value = [.top7NFT:true]
//            homeView.customTableView.reloadData()
//        }
//    }
//}
//extension TrendingViewController {
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        favoriteViewModel.maximViewWillTrigger.value = ()
//        topViewModel.viewWillTrigger.value = ()
//    }
//}


// MARK: 즐겨찾기 구역
//extension TrendingViewController: TableInCollectionFavoriteTableDelegate {
//    func didSelectItemAt(collectionView: UICollectionView, indexPath: IndexPath) {
//        favoriteViewModel.nextIndexPathInput.value = indexPath.item
//    }
//    
//    func numberOfItemsInSection(section: Int) -> Int {
//        print(favoriteViewModel.succesOutPut.value?.count ?? 0)
//        return favoriteViewModel.succesOutPut.value?.count ?? 0
//    }
//    
//    func cellForItemAt(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
//        let section = trendingViewModel.outputSection.value[indexPath.row]
//        
//        switch section {
//        case .favorite:
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoinStarCollectionViewCell.reusableIdentifier, for: indexPath) as? CoinStarCollectionViewCell else {
//                print("레지스터 문제")
//                return UICollectionViewCell()
//            }
//            favoriteViewModel.indexPathInput.value = indexPath.item
//            print("@@@@데이터 ",favoriteViewModel.coinInModelOutPut.value)
//            cell.coinInfoView.viewModel.inputModel.value = favoriteViewModel.coinInModelOutPut.value
//            cell.coinPriceChangeView.coinViewModel.coinPriceModel.value = favoriteViewModel.coinPriceModelOutPut.value
//            cell.layer.cornerRadius = 12
//            // cell.clipsToBounds = true
//            cell.backgroundColor = .mysharp
//            
//            return cell
//            
//        case .top15Coin:
//            <#code#>
//        case .top7NFT:
//            <#code#>
//        }
//       
//    }
//}






