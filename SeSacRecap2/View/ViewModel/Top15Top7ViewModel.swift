//
//  Top15Top7ViewModel.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 3/2/24.
//

import Foundation


class Top15Top7ViewModel {
    
    //MARK: 트리거
    var viewWillTrigger: Observable<Void?> = Observable(nil)
    
    private var coinItem: Observable<[CoinItem]?> = Observable(nil)
    
    var outputNfts: Observable<[Nft]?> = Observable(nil)
    var outputCoinItem: Observable<[CoinItem]?> = Observable(nil)
    
    var completeOutput: Observable<Void?> = Observable(nil)
    
    var outPutAPIError: Observable<APIError?> = Observable(nil)
    
    init(){
        viewWillTrigger.bind { [weak self] void in
            guard void != nil else {return}
            guard let self else {return}
            fetch()
        }
        coinItem.bind { [weak self] coin in
            guard let coin else {return}
            guard let self else {return}
            sortedFfts(coin)
        }
    }
    
    // MARK: 네트워크
    private func fetch(){
        APIReqeustManager.shared.fetchRequest(type:  Trending.self, api: .traeding) {[weak self] results in
            guard let self else {return}
            
            switch results {
            case .success(let success):
//                print(success)
                divideStruct(success)
            case .failure(let failure):
                outPutAPIError.value = failure
            }
        }
    }
    
    // MAKR: 각 통신 구조체로 분리
    private func divideStruct(_ trending : Trending){
        coinItem.value = trending.coins
        outputNfts.value = trending.nfts
        
    }
    // MARK: coin 정렬
    private func sortedFfts(_ coin: [CoinItem]){
        let sorted = coin.sorted { first, second in
            return first.item.market_cap_rank < second.item.market_cap_rank
        }
        outputCoinItem.value = sorted
        // dump(sorted)
        completeOutput.value = ()
    }
    
}
