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
// MARK: 네비게이션 타이틀 섹션
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
// MARK: 탭바 섹션
enum TabarSection: CaseIterable{
    case tranding
    case search
    case favorite
    case user
    
    var selected: String {
        switch self {
        case .tranding:
            "tab_trend"
        case .search:
            "tab_search"
        case .favorite:
            "tab_portfolio"
        case .user:
            "tab_user"
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
        case .user:
            "tab_user_inactive"
        }
    }
}
// MARK: 차트섹션
enum CharSection:Int, CaseIterable {
    case high
    case low
    var title: (title:String, supers: String ) {
        switch self{
        case .high:
            return ("고가","신고점")
        case .low:
            return ("저가","신저점")
        }
    }
    var colorBool: Bool {
        switch self{
        case .high:
            return true
        case .low:
            return false
        }
    }
}
// 레포지토리 에러 섹션
enum RepositoryError: Error{
    case canAddYourObject
    case deleteFail
    
    
    var title: String{
        return "데이터 베이스 오류!"
    }
    var message: String {
        switch self {
        case .canAddYourObject:
            "현재 추가하실수 없어요!"
        case .deleteFail:
            "삭제실패 하였습니다."
        }
    }
}
// MARK: API Error 섹션
enum APIError:Error {
    case canMakeResults
    case networkError
    case clientError
    case serverError
    case modelError
    case dataNoHave
    case cantChangeOfHTTPResponse
    
    var title: String {
       return "에러발생"
    }
    
    var message: String {
        switch self {
        case .canMakeResults, .cantChangeOfHTTPResponse:
            "통신에 문제가 발생했어요!"
        case .networkError:
            "통신에 문제가 발생했어요!"
        case .clientError:
            "통신 상태를 확인해주세요"
        case .serverError:
            "현재 서버의 문제가 있어요!"
        case .modelError:
            "앱을 재설치해 주세요!"
        case .dataNoHave:
            "통신에 문제가 발생했어요!"
        }
    }
    
}
// MARK: VSCurreny 섹션
enum vsCurrency {
    case kor
    case jap
    case usa
    
    static var base: String {return "vs_currency="}
    
    var query: String {
        switch self {
        case .kor:
            return vsCurrency.base + "krw"
        case .jap:
            return vsCurrency.base + "jpy"
        case .usa:
            return vsCurrency.base + "usd"
        }
    }
    var priceCase: String {
        switch self{
        case .kor:
            return "₩"
        case .jap:
            return "¥"
        case .usa:
            return "$"
        }
    }
    var moneyType: String {
        switch self {
        case .kor:
            "krw"
        case .jap:
            "jpy"
        case .usa:
            "usd"
        }
    }
}
