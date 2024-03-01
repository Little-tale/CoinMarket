//
//  CoinPriceChangeViewModel.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 2/29/24.
//

import Foundation

enum Alignment {
    case left
    case right
}
class CoinPriceChangeViewModel {
    var alimentCase: Observable<Alignment> = Observable(.left)
    
    var coinPriceModel: Observable<CoinPiceModel?> = Observable(nil)
    
    
    var isPlusOrNot: Observable<Bool?> = Observable(nil)
    var priceProcessing: Observable<String?> = Observable(nil)
    var percentageProcessing: Observable<String?> = Observable(nil)
    
    init(){
        coinPriceModel.bind { [weak self] coinModel in
            guard let self else {return}
            guard let coinModel else {return}
            processing(coinModel)
        }
    }
    private func processing(_ coin: CoinPiceModel){
        let percent = NumberFormetter.shared.presentation(persentage: coin.percentage)
        
        let price = NumberFormetter.shared.makeKRW(price: coin.price)
        
        priceProcessing.value = price
        percentageProcessing.value = percent
        print("@@@",coin.price)
        if coin.percentage < 0 {
            isPlusOrNot.value = false
        }else {
            isPlusOrNot.value = true
        }
    }
    
}


