//
//  APIModel.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 2/27/24.
//

import Foundation


// https://api.coingecko.com/api/v3/ coins/markets?vs_currency=krw&ids={id}// 시장데이터
// https://api.coingecko.com/api/v3/ search?query=bitcoin // 검색
// https://api.coingecko.com/api/v3/ search/trending // 트렌딩

// https://api.coingecko.com/api/v3/ coins/markets?vs_currency=krw&ids=bitcoin&sparkline=true

// https://api.coingecko.com/api/v3/
// coins/markets?vs_currency=krw&ids=bitcoin,wrapped-bitcoin,01coin,1000shib,1hive-water,agoric,agrello,aldrin




enum APIType {
    case search(searchText: String)
    case traeding
    case markets(marketId: [String], spakelType: Bool)
    
    var baseURL: String {
        return "https://api.coingecko.com/api/v3/"
    }
    
    var query: String{
        switch self {
        case .search(let searchText):
            return "search?query=" + searchText
        case .traeding:
            return "search/trending"
        case .markets(let marketID, let spakelType):
            // 각 ID "asd" 스트링 배열이 있다면
            let results = marketID.joined(separator: ",")
            // https://api.coingecko.com/api/v3/search?query=bitcoin
            if spakelType == true {
                return "coins/markets?vs_currency=krw&ids=" + results + "&sparkline=true"
            }
            return "coins/markets?vs_currency=krw&ids=" + results
        }
    }
    var querys: String{
        switch self {
        case .search(let searchText):
            <#code#>
        case .traeding:
            <#code#>
        case .markets(let marketId, let spakelType):
            <#code#>
        }
    }
    
    
}

