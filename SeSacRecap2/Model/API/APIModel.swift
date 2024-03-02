//
//  APIModel.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 2/27/24.
//

protocol guide {

    //        case .search:
    //            searchCoin.self
    //        case .trending:
    //            Trending.self
    //        case .CoinMarket:
    //            [CoinMarket].self
 
}


import Foundation


// MARK: 대표 모델 코인 검색
struct searchCoin: Decodable {
    let coins: [Coin] // 코인 데이터들
}
// 코인아이디 코인읾 코인 통화단위 코인 아이콘 리소스
// 이게 두개는 겹치니까 두개는 쓰고
// 다른애는 그냥 따로 만드는게 낫다고 봄
// 힝... 그냥 다 따로 만드는게.. ㅠㅠㅠㅠ 너무 어렵습니다!
struct Coin: Decodable {
    let id:String
    let name: String
    let symbol: String
    let thumb: String
}

// MARK: 코인 아이템
struct CoinItem: Decodable{
    let item: Item
}
// MARK: 대표 모델 트렌딩
struct Trending: Decodable {
    let coins: [CoinItem]
    let nfts: [Nft] // 토큰
}

// MARK: 코인 상세 정보
struct Item: Decodable {
    let id: String // 코인아이디
    let name: String // 코인 이름
    let symbol: String // 코인 통화 단위
    let small: String // 코인 아이콘 리소스
    let data: ItemData
    let market_cap_rank: Int
 
}


// MARK: 파라미터 관리
struct ItemData: Codable {
    let price:String
    let priceChangePercentage24H: [String: Double] // 후에가서 KRW 만 걸러서 가져오자

    enum CodingKeys: String, CodingKey {
        case price
        case priceChangePercentage24H = "price_change_percentage_24h"
    }
}


// MARK: 토큰정보들
/// 토큰명, 통화단위, 아이콘 리소스, NFT 데이터
struct Nft: Decodable {
    let name: String
    let symbol: String
    let thumb: String
    let data: NftData
    
    enum CodingKeys: String, CodingKey {
        case name, symbol, thumb
        case data
    }
}

// MARK: NFT 데이터
/// NFT최저가, NFT변동폭 -> 소수점 둘째 자리까지 표현, 코인의 경우 market_cap_rank를 통해 순위정렬이 가능 값이 작을수록 시가총액은 크다.
struct NftData: Codable {
    let floorPrice, floorPriceInUsd24HPercentageChange: String

    enum CodingKeys: String, CodingKey {
        case floorPrice = "floor_price"
        case floorPriceInUsd24HPercentageChange = "floor_price_in_usd_24h_percentage_change"
    }
}


// MARK:  대표 모델 코인 마켓 API 왜 안되는 거지
struct CoinMarket: Decodable {
    let id, symbol, name: String // 코인 아이디, 코인 통화단위, 코인이름
    let image: String // 코인 아이콘 리소스
    let currentPrice: Double // 코인 아이콘 리소스
    let priceChangePercentage24H: Double // 코인 현재가 (시가)
    let high24H, low24H: Double // 코인 고가, 코인 저기
    let ath: Double // 코인 사상최고가 (신고점, ALL-Time-High)
    let athDate: String // 신고점 일자
    let atlDate: String // 신저점 일자
    let atl: Double // 코인 사상 최저가 (신고점, ALL-Time-Low)
    let lastUpdated: String // 코인 시장 데이터 업데이트 시각
    let sparklineIn7D: SparklineIn7D? // 일주일간 코인 시세 정보

    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case ath
        case athDate = "ath_date"
        case atl
        case atlDate = "atl_date"
        case lastUpdated = "last_updated"
        case sparklineIn7D = "sparkline_in_7d"
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.symbol = try container.decode(String.self, forKey: .symbol)
        self.name = try container.decode(String.self, forKey: .name)
        self.image = try container.decode(String.self, forKey: .image)
        // 이거 옵셔널
        self.currentPrice = try container.decodeIfPresent(Double.self, forKey: .currentPrice) ?? 0.0
        // 이거 옵셔널
        self.high24H = try container.decodeIfPresent(Double.self, forKey: .high24H) ?? 0.0
        // 이것도 옵셔널
        self.low24H = try container.decodeIfPresent(Double.self, forKey: .low24H) ?? 0.0
        // 이것도 옵셔널
        self.priceChangePercentage24H = try container.decodeIfPresent(Double.self, forKey: .priceChangePercentage24H) ?? 0.0
        self.ath = try container.decodeIfPresent(Double.self, forKey: .ath) ?? 0.0
        // 이것도 옵셔널
        self.athDate = try container.decodeIfPresent(String.self, forKey: .athDate) ?? ""
        // 이것도 옵셔널
        self.atl = try container.decodeIfPresent(Double.self, forKey: .atl) ?? 0.0
        // 이것도 옵셔널
        self.atlDate = try container.decodeIfPresent(String.self, forKey: .atlDate) ?? ""
        // 이것도 옵셔널
        self.lastUpdated = try container.decodeIfPresent(String.self, forKey: .lastUpdated) ?? ""
        // 이것도 옵셔널
        self.sparklineIn7D = try container.decodeIfPresent(SparklineIn7D.self, forKey: .sparklineIn7D)
    }
   
}

// MARK: - 일주일간 코인시세 정보
/// 일주일간 코인시세 정보 [Double]
struct SparklineIn7D: Decodable {
    let price: [Double]
}
