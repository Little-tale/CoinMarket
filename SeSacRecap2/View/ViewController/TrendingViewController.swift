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
 
enum TrendingViewSection{
    
    
}



// 일단 뷰모델 재사용을 해보자
// 콤포지션 컬렉션뷰 를 발견했는데 한번 적용시켜보자
class TrendingViewController: HomeBaseViewController<TableHomeView> {
    // 일단은 여기에 박아보자
    let favoriteViewModel = FavoriteCoinViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribe()
        delegateDataSource()
    }
    
}
extension TrendingViewController{
    func delegateDataSource(){
        homeView.customTableView.dataSource = self
        homeView.customTableView.delegate = self
        homeView.customTableView.backgroundColor = .gray
    }
}

extension TrendingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 300
        }else {
            return 100
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3 
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(#function)
        if let cell = tableView.dequeueReusableCell(withIdentifier: TableInCollectionFavoriteTableCell.reusableIdentifier, for: indexPath) as? TableInCollectionFavoriteTableCell {
            cell.customDelegate = self
            cell.backgroundColor = .red
            return cell
        }
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.backgroundColor = .gray
        return cell
    }
}

extension TrendingViewController {
    func subscribe(){
        
    }
}
extension TrendingViewController: TableInCollectionFavoriteTableDelegate {
    func numberOfItemsInSection(section: Int) -> Int {
        return 3
    }
    
    func cellForItemAt(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoinStarCollectionViewCell.reusableIdentifier, for: indexPath) as? CoinStarCollectionViewCell else {
            return UICollectionViewCell()
        }
        favoriteViewModel.indexPathInput.value = indexPath.row
        cell.coinInfoView.viewModel.inputModel.value = favoriteViewModel.coinInModelOutPut.value
        
        cell.coinPriceChangeView.coinViewModel.coinPriceModel.value = favoriteViewModel.coinPriceModelOutPut.value
        
        cell.backgroundColor = .red
        return cell
    }
}

extension TrendingViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        favoriteViewModel.maximViewWillTrigger.value = ()
    }
}
