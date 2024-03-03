//
//  Top15Top7ViewModel.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 3/2/24.
//

import Foundation

enum coinTypes: String{
    case nfs = "nfs"
    case coinItem = "coinItem"
}

class Top15Top7ViewModel {
    
    var inputIndexPath: Observable<(num:Int, type:coinTypes)?> = Observable(nil)
    var makeCoinInput: Observable<(nft: Nft?, items: CoinItem?)?> = Observable(nil)
    //MARK: 트리거
    var viewWillTrigger: Observable<Void?> = Observable(nil)
    
    private var coinItem: Observable<[CoinItem]?> = Observable(nil)
    
    
    var outputNfts: Observable<[Nft]?> = Observable(nil)
    var outputCoinItem: Observable<[CoinItem]?> = Observable(nil)
    var completeOutput: Observable<Void?> = Observable(nil)
    var outPutAPIError: Observable<APIError?> = Observable(nil)
    var outPutCoin: Observable<Coin?> = Observable(nil)
    
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
        makeCoinInput.bind { [weak self] before in
            guard let before else {return}
            guard let self else {return}
            if let item = before.items {
                makeCoin(nil,item)
            } else if let nft = before.nft {
                makeCoin(nft,nil)
            }
            
        }

    }
    
    
    private func makeCoin(_ nft: Nft? = nil, _ coinItem: CoinItem? = nil) {
        if let nft {
            // MARK: 코인 아이디가 없음. 이친구
            // 애초에.... 이런 접근이.... 맞는지 모르겠어...
            // Realm 에 다 저장해서 하는 방법도 있겠지만....
            // 그럼 다른 관점에서 생각해 보면 내가 관심도 없는 코인이
            // 내가 영원히 볼지도 모르는 코인이 검색 시점에서 다 일단 저장시킨다..?
            // 그럼 내폰이 서버가 되는것인가??? 뭔가 많이 이상하다..
            // 물론 네트워크 절단 문제를 해결하기에는 무리가 없을수 있겠지만....
            // 그럼 3일 지나서 앱을 켰는데 아직도 상향가네 하다가
            // 알고보니 엄청나게 떨어지고 있는데 그걸 뒤늦게 차리고 한강에 갈지도 말이야.
            let coin = Coin(id: nft.name, name: nft.name, symbol: nft.symbol, thumb: nft.thumb)
            outPutCoin.value = coin
        } else if let coinItem{
            let coin = Coin(id: coinItem.item.id, name: coinItem.item.name, symbol: coinItem.item.symbol, thumb: coinItem.item.small)
            outPutCoin.value = coin
        }
    }
    

    
    // MARK: 네트워크
    private func fetch(){
        APIReqeustManager.shared.fetchRequest(type:  Trending.self, api: .traeding) {[weak self] results in
            guard let self else {return}
            switch results {
            case .success(let success):
//                print(success)
                dump(success)
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
//        inputIndexPath.bind { [weak self] num in
//            guard let num else {return}
//            guard let self else {return}
//            makeCoin(num.num ,num.type)
//        }
//    private func makeCoin(_ num: Int, _ coinType: coinTypes){
//        switch coinType {
//        case .nfs:
//            print(outputCoinItem.value?[num])
//        case .coinItem:
//            print(outputNfts.value?[num])
//        }
//    }
