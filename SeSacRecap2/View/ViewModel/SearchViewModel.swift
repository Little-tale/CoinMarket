//
//  SearchViewModel.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 2/27/24.
//

import Foundation

final class SearchViewModel {
    // MARK: INPUT
    let searchInPut: Observable<String?> = Observable(nil)
    
    let coinInfoInput: Observable<Int?> = Observable(nil)
    let coinButtonActive: Observable<String?> = Observable(nil)
    
    // MARk: Trigger
    let triggerViewController: Observable<Void?> = Observable(nil)
    
    // MARK: OutPut
    let searchOutput: Observable<[Coin]> = Observable([])
    let errorOutPut: Observable<APIError?> = Observable(nil)
    let tableErrorOutput: Observable<RepositoryError?> = Observable(nil)
    
    let saveSuccesOutput: Observable<String?> = Observable(nil)
    let checkedButtonOutput: Observable<Bool?> = Observable(nil)
    let reloadTrigger: Observable<Void?> = Observable(nil)
    
    // test
    // var realmModel.
    var allListen = ObservableGroup()
    var allListe2: [Unbinding] = []
    // Static
    let searchModel = searchCoin.self
    let repository = RealmRepository()
    
    init(){
        allListen.add(searchInPut)
        allListen.add(coinInfoInput)
        allListen.add(coinButtonActive)
        allListen.add(triggerViewController)
        allListen.add(tableErrorOutput)
        allListen.add(saveSuccesOutput)
        allListen.add(checkedButtonOutput)
        allListen.add(reloadTrigger)
        
        searchInPut.bind { [weak self] searchText in
            guard let searchText else {return}
            self?.searchOfCoin(searchText)
        }

        coinButtonActive.bind { [weak self] id in
            guard let id else {return}
            self?.checkingButton(id)
        }
        coinInfoInput.bind { [weak self] row in
            guard let row else {return}
            guard let self else {return}
            
            let data = self.searchOutput.value[row]
            self.favoriteSetting(data)
            print(searchOutput.value[row])
            // triggerViewController.value = ()
        }
        triggerViewController.bind {  [weak self] void in
            guard let void else {return}
            guard let self else {return}
            guard let text = searchInPut.value else {return}
            searchOfCoin(text)
        }
        
    }
    
    private func deleteRemove(){
        do{
            try repository.removeLastFavoriteButton()
        } catch {
            if let error = error as? RepositoryError {
                tableErrorOutput.value = error
            }
        }
    }
    
    private func checkingButton(_ id: String) {
        checkedButtonOutput.value = repository.findFavorite(id)
    }
    
    // 하.. 이렇게 하니까 된다. 먼저 즐겨찾기부터 확인
    // 그후에 최대 개수를 확인했어야 했다.
    private func favoriteSetting(_ coin: Coin){

        // 즐겨찾기에 있는지 확인
        if repository.findFavorite(coin.id) {
            // 이미 있는 경우 삭제 MARK: 이부분을 재고민
            // 1. 첫뷰에서는 생성과 삭제를 할수있다만.
            // 2. 차트뷰에서는 생성과 삭제를 하기에는 무리가 있다.
            let result = repository.newOrDeleteFavoriteCoin(coin: coin)
            
            switch result {
            case .success(let success):
                self.saveSuccesOutput.value = success
            case .failure(let failure):
                self.tableErrorOutput.value = failure
            }
            
        } else {
            // 즐겨찾기에 없는 경우, 최대 개수 체크
            guard repository.canIFavorite else {
                print("^^^^^^^^^^^^^^^^^^^^^^^^")
                self.reloadTrigger.value = ()
                self.saveSuccesOutput.value = "최대 10개까지 입니다."
                return
            }
            // 최대 개수를 넘지 않았다면,
            let result = repository.newOrDeleteFavoriteCoin(coin: coin)
            switch result {
            case .success(let success):
                self.saveSuccesOutput.value = success
            case .failure(let failure):
                self.tableErrorOutput.value = failure
            }
        }
       
    }

    // MARK: 코인정보를 조회
    private func searchOfCoin(_ text: String){
        APIReqeustManager.shared.fetchRequest(type: searchModel, api: .search(searchText: text)) { result in
            switch result {
            case .success(let success):
               // print("@@@@",success,#function)
                self.searchOutput.value = success.coins
               
            case .failure(let failure):
                print(failure)
                self.errorOutPut.value = failure
            }
        }
    }
    var numberOfRowsInSection: Int {
        return searchOutput.value.count
    }
    
}

/*
 //            guard let bool = self?.repository.canIFavorite else {
 //                return
 //            }
 //            print("@@@@@",bool)
 //            if bool{
 //
 //                self?.favoriteSetting(coinId)
 //            } else {
 //                print(bool)
 //                self?.repository.deleteOf(coinId)
 //                self?.saveSuccesOutput.value = "최대 10개 까지 입니다."
 //            }
 /// MAXIMAM 10
 var canIFavorite: Bool{
     if 9 < realm.objects(coinRealmTable.self).count{
         print("@@@@@ false")
         return false
     }
     print("@@@@@ true")
     return true
 }
 */
