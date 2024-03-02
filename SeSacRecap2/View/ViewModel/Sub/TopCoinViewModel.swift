//
//  TopCoinViewModel.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 3/2/24.
//

import Foundation

/*
 struct CoinInfoModel{
     var imageName:String
     var coinName:String
     var symBol:String
     init(imageName: String, coinName: String, symBol: String) {
         self.imageName = imageName
         self.coinName = coinName
         self.symBol = symBol
     }
 }
/*
 struct CoinPiceModel{
     var price: Double
     var percentage: Double
     init(price: Double, percentage: Double) {
         self.price = price
         self.percentage = percentage
     }
 }
 */
 */

class TopCoinViewModel {

    var vs_currency : Observable<vsCurrency> = Observable(.usa)
    var inputNFT: Observable<Nft?> = Observable(nil)
    var inputCoin: Observable<CoinItem?> = Observable(nil)
    
    var outputCoinInfoModel: Observable<CoinInfoModel?> = Observable(nil)
    var outputCoinItemModel: Observable<CoinPriceModelString?> = Observable(nil)
    
    init(){
        inputNFT.bind {[weak self] nft in
            guard let self else {return}
            guard let nft else {return}
            processingModel(nft: nft)
        }
        inputCoin.bind { [weak self] coin in
            guard let self else {return}
            guard let coin else {return}
            processingModel(coinItem: coin)
        }
    }
    private func processingModel(nft: Nft? = nil, coinItem: CoinItem? = nil) {
        if let nft {
            let coinInfoModel = CoinInfoModel(imageName: nft.thumb, coinName: nft.name, symBol: nft.symbol)
            let coinItem = CoinPriceModelString(price: nft.data.floorPrice, percentage: nft.data.floorPriceInUsd24HPercentageChange)
            outputCoinInfoModel.value = coinInfoModel
            outputCoinItemModel.value = coinItem
            
        } else if let coinItem {
            
            let coinInfoModel = CoinInfoModel(imageName: coinItem.item.small, coinName: coinItem.item.name, symBol: coinItem.item.symbol)
            let coinItem = CoinPriceModelString(price: coinItem.item.data.price, psercentage: coinItem.item.data.priceChangePercentage24H[vs_currency.value.query] ?? 0)
            
            outputCoinInfoModel.value = coinInfoModel
            outputCoinItemModel.value = coinItem
        }
        
    }
    
}
