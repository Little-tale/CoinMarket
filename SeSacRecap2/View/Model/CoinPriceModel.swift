//
//  CoinPriceModel.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 2/28/24.
//

import Foundation

struct CoinPriceModel {
   
    var coinName: String
    var coinImage: String
    // 1.27455 이런식
    var persentTage: Double
    var date: String
    var current: Double
    
    init(coinName: String, coinImage: String, persentTage: Double, current: Double) {
        self.coinName = coinName
        self.coinImage = coinImage
        self.persentTage = persentTage
        self.date = "Today" // 이게 문제인가보다.....
        self.current = current
    }
}
// 이미 너무 많은 강을 건넌거 같은데....
// 일단 어느정도 채워놓고 고민해보자
