//
//  CoinmarketDibideViewModel.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 3/1/24.
//

import Foundation


//class CoinmarketDibideViewModel {
//    
//    let inputData: Observable<[CoinMarket]?> = Observable(nil)
//    
//    let outputCoinInFoModel: Observable<CoinInfoModel?> = Observable(nil)
//    let outputPriceModelOutput: Observable<CoinPiceModel?> = Observable(nil)
//    
//    
//    private func processCoinList(_ item: Int){
//        guard let value = inputData.value?[item] else {return}
//        
//        let data = value[item]
//        
//        let coinInfoModel = CoinInfoModel(imageName: data.image, coinName: data.name, symBol: data.symbol)
//        outputCoinInFoModel.value = coinInfoModel
//        
//        let coinPriceModel = CoinPiceModel(price: data.currentPrice, percentage: data.priceChangePercentage24H)
//        outputPriceModelOutput.value = coinPriceModel
//    }
//}
