//
//  ViewController.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 2/27/24.
//

import UIKit
import Kingfisher

// MARK: 검색 잘 되는지 테스트
// 1. seaechCoin OK
// 2. tranding 실패 -> 모델이슈 해결 OK
// 3. 하... 3시간을 해매 3번째도 성공 오류의 이유 Double이였던거
// 두번째 [String: Any?]를 원하신다는데 [CoinMarket].self 로 하니 해결 [CoinMarket].self

// MARK: 서치컨트롤러 세팅
// 서치 컨트롤러를 쓰시려면 네비게이션을 임베디드 해야한다. ok
//

class SearchViewController: HomeBaseViewController<SearchHomeView> {
    
    let viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController() // 서치컨트롤러 세팅
        settingOfTableView() // 테이블뷰 세팅
        subscribe()
        settingNavigation()
        
    }
}
// dataSource, delegate etc Setting
extension SearchViewController {
    func settingOfTableView(){
        homeView.tableView.delegate = self
        homeView.tableView.dataSource = self
        homeView.tableView.rowHeight = UITableView.automaticDimension
        homeView.tableView.estimatedRowHeight = 50
    }
}

extension SearchViewController {
    func subscribe(){
        viewModel.searchOutput.bind {[weak self] _ in
            self?.homeView.tableView.reloadData()
        }
        
        viewModel.errorOutPut.bind { [weak self] error in
            guard let error else {return}
            let alert = self?.showAlert(error: error)
            if let alert {
                self?.present(alert, animated: true)
            }
        }
        viewModel.tableErrorOutput.bind { [weak self] error in
            guard let error else {return}
            let alert = self?.showAlert(error: error)
            if let alert {
                self?.present(alert, animated: true)
            }
        }
        viewModel.saveSuccesOutput.bind { [weak self] success in
            guard let success else {return}
            let alert = self?.showAlert(text: "즐겨찾기", message: success)
            if let alert {
                self?.present(alert, animated: true)
            }
            // self?.homeView.tableView.reloadData()
        }
        
       
    }
}
// MARK: 서치바 딜리게이트
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchInPut.value = searchBar.text

    }
}
// MARK: 테이블 뷰 데이타 소스 딜리게이트
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CoinDetailButtonCell.reusableIdentifier, for: indexPath) as? CoinDetailButtonCell else {return UITableViewCell()}
        let data =  viewModel.searchOutput.value[indexPath.row]
        
        let url = URL(string:data.thumb)

        cell.detailImage.kf.setImage(with: url)
        cell.nameLabel.text = data.name
        cell.nameLabel.asFont(targetString: viewModel.searchInPut.value ?? "")
        
        cell.rightButton.tag = indexPath.row
        
        cell.subNameLabel.text = data.symbol
        
        viewModel.coinButtonActive.value = data.id
        
        cell.rightButton.isSelected = viewModel.checkedButtonOutput.value ?? false
        
        cell.rightButton.addTarget(self, action: #selector(favoriteButtonClicked), for: .touchUpInside)
        return cell
    }
    // MARK: 테이블 셀 선택시 다음컨트롤러 CoinViewCon으로 이동
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CoinChartViewController()
       
       let data = viewModel.searchOutput.value[indexPath.row]
        vc.viewModel.coinInfoInput.value = data
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
        navigationController?.pushViewController(vc, animated: true)
        vc.viewModel.inputViewdidLoadTrigger.bind {[weak self] _ in
            guard let self else {return}
            tableView.reloadData()
        }
    }
    
}
// MARK: Objc Function
// 즐겨찾기에 들어갈것을 재고민
extension SearchViewController {
    @objc
    func favoriteButtonClicked(_ sender: UIButton){
        print(sender.tag)
        viewModel.coinInfoInput.value = sender.tag
        let cell = IndexPath(row: sender.tag, section: 0)
        homeView.tableView.reloadRows(at: [cell], with: .automatic)
    }
}

// MARK: 검색컨 세팅
extension SearchViewController {
    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "검색하실 코인을 입력해주세요"
        searchController.hidesNavigationBarDuringPresentation = false
        // searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "Search"
        self.navigationItem.hidesSearchBarWhenScrolling = true
    }
}
// MARK: 네비게이션 세팅
extension SearchViewController {
    func settingNavigation(){
        
        let rightImageView = CircleImageView(frame: .zero)
        rightImageView.image = UIImage(named: "tab_user_inactive")
        
        let rightBarButton = UIBarButtonItem(customView: rightImageView)
        
        navigationItem.rightBarButtonItem = rightBarButton
    }
}
