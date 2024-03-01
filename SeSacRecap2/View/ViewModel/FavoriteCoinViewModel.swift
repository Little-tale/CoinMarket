//
//  FavoriteCoinViewModel.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 2/29/24.
//

import Foundation


// 혹시 시간이 되신다면 StarViewModel의 글을 읽어주셨으면 합니다...
class FavoriteCoinViewModel {
    // MARK: input
    var indexPathInput: Observable<Int?> = Observable(nil)
    
    var nextIndexPathInput: Observable<Int?> = Observable(nil)
    
    // MARK: 트리거
    var viewWillTrigger: Observable<Void?> = Observable(nil)
    var maximViewWillTrigger: Observable<Void?> = Observable(nil)
    // static
    let repository = RealmRepository()
    
    // OutPut
    let errorOutput: Observable<APIError?> = Observable(nil)
    let succesOutPut: Observable<[CoinMarket]?> = Observable(nil)
    
    let coinInModelOutPut: Observable<CoinInfoModel?> = Observable(nil)
    let coinPriceModelOutPut: Observable<CoinPiceModel?> = Observable(nil)
    let nextCoinOutPut: Observable<Coin?> = Observable(nil)
    
    
    init(){
        viewWillTrigger.bind {[weak self] _ in
            guard let self else {return}
            let list = repository.getFavoriteList()
            settingCoinList(list)
            print("@@@",repository.getFavoriteList().count)
        }
        indexPathInput.bind {[weak self] item in
            guard let self else {return}
            guard let item else {return}
            processCoinList(item)
        }
        nextIndexPathInput.bind { [weak self] item in
            guard let self else {return}
            guard let item else {return}
            nextCoin(item)
        }
        
        maximViewWillTrigger.bind {[weak self] _ in
            guard let self else {return}
            if 1 > repository.getFavoriteList().count {
                print("@@@ 3 >")
                return
            }
            print("@@@  3 < ")
            let list = repository.getFavoriteList()
            settingCoinList(list)
            print("@@@",repository.getFavoriteList().count)
        }
    }
    // 코인 리스트를 가져오고 요청합니다.
    private func settingCoinList(_ coins: [CoinSearchTable]){
        print("@@@@@@@@",#function)
        let idArray = coins.map { $0.coinId }
        print(idArray)
        if idArray.isEmpty {return}
        
        APIReqeustManager.shared.fetchRequest(type: [CoinMarket].self, api: .markets(marketId: idArray, contry: .kor, spakelType: false)) {  [weak self] result in
            guard let self else {return}
            switch result {
            case .success(let success):
                succesOutPut.value = success
            case .failure(let failure):
                errorOutput.value = failure
            }
        }
    }
    
    private func processCoinList(_ item: Int){
        guard let value = succesOutPut.value else {return}
        let data = value[item]
        
        let coinInfoModel = CoinInfoModel(imageName: data.image, coinName: data.name, symBol: data.symbol)
        coinInModelOutPut.value = coinInfoModel
        
        let coinPriceModel = CoinPiceModel(price: data.currentPrice, percentage: data.priceChangePercentage24H)
        coinPriceModelOutPut.value = coinPriceModel
    }
    
    // 리스트의 테이블을 꺼내 다음뷰에 전달합니다.
    private func nextCoin(_ item: Int) {
        guard let value = succesOutPut.value else {return}
        let id = value[item]
        guard let table = repository.getCoin(id.id) else {return}
        let coin = Coin(id: id.id, name: id.name, symbol: id.symbol, thumb: id.image)
        nextCoinOutPut.value = coin
    }
}
