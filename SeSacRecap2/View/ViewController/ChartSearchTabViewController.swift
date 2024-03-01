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

class ChartSearchTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        let searchViewController = SearchViewController()
        let FavoriteViewController = FavoriteCoinViewController()
        

        
        let nvc = UINavigationController(rootViewController: searchViewController)
        let nvc2 = UINavigationController(rootViewController: FavoriteViewController)
        
        self.setViewControllers([UIViewController(),nvc,nvc2], animated: true)
        
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
        if let viewConIndex = self.viewControllers?.firstIndex(of: viewController) {
            
        }
            
    }
}


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

