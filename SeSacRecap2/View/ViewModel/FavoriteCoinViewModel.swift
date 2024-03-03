//
//  FavoriteCoinViewModel.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 2/29/24.
//

import Foundation


// 혹시 시간이 되신다면 StarViewModel의 글을 읽어주셨으면 합니다...
final class FavoriteCoinViewModel {
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
    
    let testOiu :Observable<Void?> = Observable(nil)
    
    // ALL Listen
    var allLiten = ObservableGroup() // 죄송합니다.. 노력했는데;..
    
    
    init(){
        allLiten.add(indexPathInput)
        allLiten.add(nextIndexPathInput)
        allLiten.add(viewWillTrigger)
        allLiten.add(maximViewWillTrigger)
        allLiten.add(errorOutput)
        allLiten.add(succesOutPut)
        allLiten.add(coinInModelOutPut)
        allLiten.add(coinPriceModelOutPut)
        allLiten.add(nextCoinOutPut)
        allLiten.add(testOiu)
        
        viewWillTrigger.bind {[weak self] Void in
            guard let self else {return}
            guard Void != nil else {return}
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
        // MARK: 제출전에는 2으로 재수정
        maximViewWillTrigger.bind {[weak self] void in
            guard let self else {return}
            guard void != nil else {return}
            if 2 > repository.getFavoriteList().count {
                
                print("@@@ 3 >")
                print("^^^ 2 >")
                
                succesOutPut.value = nil
                testOiu.value = ()
                return
            }
            print("@@@  3 < ")
            let list = repository.getFavoriteLatest()
            threeMaxCoinList(list)
        }
    }
    // 코인 리스트를 가져오고 요청합니다.
    private func settingCoinList(_ coins: [CoinSearchTable]){
        print("@@@@@@@@",#function)
        let idArray = coins.map { $0.coinId }
        print("@@@@**", idArray)
        if idArray.isEmpty {return}
        
        APIReqeustManager.shared.fetchRequest(type: [CoinMarket].self, api: .markets(marketId: idArray, contry: .kor, spakelType: false)) {  [weak self] result in
            guard let self else {return}
            switch result {
            case .success(let success):
                succesOutPut.value = success
               
                print("^^^success")
            case .failure(let failure):
                errorOutput.value = failure
               
                print("^^^failure")
            }
        }
    }
    private func threeMaxCoinList(_ coins: [CoinSearchTable]){
        print("@@@@@@@@",#function)
        let idArray = coins.map { $0.coinId }
        print("@@@@**", idArray)
        if idArray.isEmpty {return}
        // MARK: 그냥 넣으려고 하면 Array<String>.SubSequence 라고 뻐팅김
        // 그럼 다시 너 어레이야~ 해주니 잘만됨
        let maxArray = Array(idArray.suffix(3))
        APIReqeustManager.shared.fetchRequest(type: [CoinMarket].self, api: .markets(marketId: maxArray, contry: .kor, spakelType: false)) {  [weak self] result in
            guard let self else {return}
            switch result {
            case .success(let success):
                succesOutPut.value = success
               
                print("^^^success")
            case .failure(let failure):
                errorOutput.value = failure
               
                print("^^^failure")
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
        guard repository.getCoin(id.id) != nil else {return}
        let coin = Coin(id: id.id, name: id.name, symbol: id.symbol, thumb: id.image)
        nextCoinOutPut.value = coin
        
    }
}




//    private func settingMaxCoinList(_ coins: [CoinSearchTable]){
//        print("@@@@@@@@",#function)
//        let idArray = coins.map { $0.coinId }
//        print(idArray)
//        if idArray.isEmpty {return}
//
//        APIReqeustManager.shared.fetchRequest(type: [CoinMarket].self, api: .markets(marketId: idArray, contry: .kor, spakelType: false)) {  [weak self] result in
//            guard let self else {return}
//            switch result {
//            case .success(let success):
//                succesOutPut.value = success
//            case .failure(let failure):
//                errorOutput.value = failure
//            }
//        }
//    }
    
