//
//  ChartSearchTabViewController.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 2/29/24.
//

import UIKit

enum TabarSection: CaseIterable{
    case tranding
    case search
    case favorite
    
    var selected: String {
        switch self {
        case .tranding:
            "tab_trend"
        case .search:
            "tab_search"
        case .favorite:
            "tab_portfolio"
        }
    }
    var normal: String {
        switch self {
        case .tranding:
            "tab_trend_inactive"
        case .search:
            "tab_search_inactive"
        case .favorite:
            "tab_portfolio_inactive"
        }
    }
}


// MARK: 죄송합니다. 모든 뷰컨트롤러 에서 MVVM을 하려고 했으나
// MARK: 도저히 탭바 컨트롤러 에서는 그것을 어떻게 해야할지 감지 전혀 오질 못했습니다.
// 그렇다고 NotificationCenter를 사용하는것은 학습의 방향성이 맞다고 생각하지 않았고,
// 어떻게든 여기서도 각 뷰컨의 뷰 모델에 접근하여서 해결해 보는 방향으로 생각했습니다.
// 원래는 이것을 이용해서가 아니라 공통적인 뷰모델을 정의해서 그 뷰모델에서 변화를 감지 하면 전체적으로 알릴수 있으니 그렇게 하려고 했는데... 진짜 열심히 해봤는데..
// 생각되로 되질 않아서 너무 속상하고 .... 죄송합니다.
class ChartSearchTabViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        let trentViewController =  NewTrendViewController()
        let searchViewController = SearchViewController()
        let FavoriteViewController = FavoriteCoinViewController()
        
        
        let nvc3 = UINavigationController(rootViewController: trentViewController)
        
        let nvc = UINavigationController(rootViewController: searchViewController)
        let nvc2 = UINavigationController(rootViewController: FavoriteViewController)
        
        self.setViewControllers([nvc3,nvc,nvc2], animated: true)
        
        if let items = tabBar.items {
            items.enumerated().forEach { [weak self] index, item in
                guard self != nil else {return}
                item.selectedImage = UIImage(named: TabarSection.allCases[index].selected)
                item.image = UIImage(named: TabarSection.allCases[index].normal)
            }
        }
        

        
    }
}

extension ChartSearchTabViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print(tabBarController, viewController)
        
    }
}




//class TabBarViewModel {
//    static var shared = TabBarViewModel()
//    
//    let inputState: Observable<Void?> = Observable(nil)
//    let outPutState: Observable<Void?> = Observable(nil)
//    
//    
//    private init(){
//        inputState.bind {[weak self] V in
//            guard let V else {return}
//            guard let self else {return}
//            outPutState.value = ()
//        }
//    }
//    
//}

//        TabBarViewModel.shared.outPutState.bind { [weak self] void in
//            guard let self else {return}
//            guard let void else {return}
//            ReloadViewModel.shared.inReloadView.value = ()
//            print("@@@@@@@")
//        }
//        ReloadViewModel.shared.OutReloadView.bind { [weak self] void in
//            guard let self else {return}
//            guard let void else {return}
//
//        }

/*
 if let items = self.tabBar.items {
//            items[0].selectedImage = UIImage(named: "tab_trend")
//            items[0].image = UIImage(named: "tab_trend_inactive")
//            items[1].selectedImage = UIImage(named: "tab_search_inactive")
//            items[1].image = UIImage(named: "tab_search")
//        }
 */


//    // MARK: 이논리 대로면 베이스 뷰에다가 뷰모델을 하나두고 옵저버만 값 변경만 감지하면 모든 뷰에 마치 노티피 케이션 센터같이 알릴수 있을것 같은데    searchViewController.viewModel.triggerViewController.bind { _ in
//            print("asdasdsadsa!!!")
//        }

