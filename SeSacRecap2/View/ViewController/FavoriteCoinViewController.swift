//
//  FavoriteCoinViewController.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 2/29/24.
//

import UIKit
import Kingfisher


// 0번 렘에서 저장된 즐겨찾기들을 가져오기 ok
// 1번 통신 어떻게 오는지 테스트 ok
// 2번 이번엔 뷰가쓸 모델과 뷰모델과 다른 뷰모델들을 연계해보자

class FavoriteCoinViewController: HomeBaseViewController<CollectionHomeView> {
    let viewModel = FavoriteCoinViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("@@@@@@@",#function)
        subscribe()
        settingNavigation()
        
    }
    
    override func delegateDatasource() {
        homeView.collectionCoinView.delegate = self
        homeView.collectionCoinView.dataSource = self
    }
}

extension FavoriteCoinViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("@@@@",viewModel.succesOutPut.value?.count)
        return viewModel.succesOutPut.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CoinStarCollectionViewCell.reusableIdentifier, for: indexPath) as? CoinStarCollectionViewCell else {
            return UICollectionViewCell()
        }
        viewModel.indexPathInput.value = indexPath.item
        
        cell.coinInfoView.viewModel.inputModel.value = viewModel.coinInModelOutPut.value
        
        cell.coinPriceChangeView.coinViewModel.coinPriceModel.value = viewModel.coinPriceModelOutPut.value
        
        cell.coinPriceChangeView.coinViewModel.alimentCase.value = .right
        cell.backgroundColor = .white
        cell.setupShadow(true)
        cell.layer.cornerRadius = 12
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.nextIndexPathInput.value = indexPath.item
       
    }
    
}


extension FavoriteCoinViewController {
    func subscribe(){
        viewModel.errorOutput.bind { [weak self] error in
            guard let error else {return}
            guard let self else {return}
            let alert = showAlert(error: error)
            present(alert, animated: true)
        }
        viewModel.succesOutPut.bind {[weak self] _ in
            guard let self else {return}
            homeView.collectionCoinView.reloadData()
        }
        viewModel.nextCoinOutPut.bind { [weak self] coinModel in
            guard let self else {return}
            guard let coinModel else {return}
            let vc = CoinChartViewController()
            vc.viewModel.coinInfoInput.value = coinModel
            
            vc.viewModel.inputViewdidLoadTrigger.bind {[weak self] _ in
                guard let self else {return}
                viewModel.viewWillTrigger.value = ()
                homeView.collectionCoinView.reloadData()
            }
            navigationController?.pushViewController(vc, animated: true)
        }
        // MARK: 리로드를 했음에도 값이 변하질 않음
    }
}


extension FavoriteCoinViewController {
    func settingNavigation(){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Favorite Coin"
    }
}
