//
//  CoinPriceViewModel.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 2/28/24.
//

import Foundation

class CoinPriceViewModel {
    // input
    var coinInput: Observable<CoinPriceModel?> = Observable(nil)
    // output
    var current: Observable<String> = Observable("")
    var coinNameOutput: Observable<String> = Observable("")
    var coinImageOutput: Observable<URL?> = Observable(nil)
    var presentageOutput: Observable<String> = Observable("")
    var dateOutPut: Observable<String> = Observable("")
    
    init(){
        coinInput.bind { [weak self] coinModel in
            guard let coinModel else {return}
            guard let self else {return}
            procseeing(coinModel)
        }
    }
    
    
    func procseeing(_ coin: CoinPriceModel){
        // 코인이름
        coinNameOutput.value = coin.coinName
        // 날짜
        dateOutPut.value = coin.date
       // 코인 이미지 URL
        coinImageOutput.value = URL(string:coin.coinImage)
        let result = NumberFormetter.shared.makeKRW(price: coin.current)
        // 현재 가격
        current.value = result
        
        presentageOutput.value = NumberFormetter.shared.presentation(persentage: coin.persentTage)
        
    }
    
}
