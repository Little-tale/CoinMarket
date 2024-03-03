//
//  Section.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 2/27/24.
//

import Foundation

// MARK: 트렌딩 뷰 테이블 섹션
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


enum NavigationTitleSection{
    case Trending
    case Search
    case Favorite
    
    var title : String{
        switch self {
        case .Trending:
            return "Crypto Coin"
        case .Search:
            return "Search"
        case .Favorite:
            return "Favorite Coin"
        }
    }
}
