//
//  CollectionViewSectionLayout.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 3/2/24.
//

import Foundation


class TableViewCollectionCellStylerViewModel {
    let inputSection: Observable<TrendingViewSection?> =  Observable(nil)
    
    let inputFavoriteData: Observable<[CoinMarket]?> = Observable(nil)
    
    
    let coinInModelOutPut: Observable<[CoinInfoModel]> = Observable([])
    let coinPriceModelOutPut: Observable<[CoinPiceModel]> = Observable([])
    let coinPriceModelString: Observable<CoinPriceModelString?> = Observable(nil)
    
    
    
    init(){
        inputFavoriteData.bind { [weak self] coinMarket in
            guard let coinMarket else {return}
            guard let self else {return}
            processCoinList(coinMarket)
        }
    }
    
    private func processCoinList(_ item: [CoinMarket]){
        
        let coinInfos = item.map {
            CoinInfoModel(imageName: $0.image, coinName: $0.name, symBol: $0.symbol)
        }
        coinInModelOutPut.value = coinInfos
        
        let coinPriceModels = item.map { 
            CoinPiceModel(price: $0.currentPrice, percentage: $0.priceChangePercentage24H)
        }
        coinPriceModelOutPut.value = coinPriceModels

    }
}


