//
//  StarViewModel.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 3/1/24.
//

// import Foundation

// 즐겨찾기된 리스트를 관리하는 공유 뷰모델을 만들어보는게 좋을듯 하다.

// MARK: 이걸 보시게 된다면... 이런 구조는 좋은 생각이였는지 묻고 싶습니다. 만...
// 정작 이 것을 연결해서 쓰니 차트뷰 버튼이 왔다갔다 하는 현상이 발생했었습니다.
// 그래서 이 코드를 이렇게 버리기는 안타까워서 남기게 되었는데
// 이렇게 짜려고 했던 이유를 물어 보신다면 하나의 뷰모델을 통해 변화를 감지하면
// 다른 뷰컨에 있는 뷰들이 알아차려서 리로드를 하게끔 하고 싶었습니다..
// 하지만 생각처럼 작동하지 않더군요 특히
// 검색뷰에서 셀을 클릭하면 coinIdInput 에 id를 전달해서
// 버튼 상태를 그대로 Chart뷰에 전달하려고 하였는데 이상하게
// 테이블뷰에 셀 포 로우 엣 에서 coinIdInput을 다시 0,1,2,3 순으로 작동하여
// 버튼이 예상한 동작으로 작동을 하지 않게 되었습니다.
// 전 바보인가 봐요

// 뷰의 결합도가 높아져서 MVC 랑 다른게 뭐냐
// 레포지터리 패턴
final class StarViewModel {
    static let shared = StarViewModel()
    
    init() {
        coinInfoInput.bind { [weak self] coin in
            guard let coin else {return}
            guard let self else {return}
            print(coin)
            favoriteSetting(coin)
        }
        coinIdInput.bind {[weak self]  id in
            guard let id else {return}
            guard let self else {return}
            print("@@@@@@@@ 코인인풋",id)
            checkingButton(id)
        }
    }
    
    let repository = RealmRepository()
    
    let coinInfoInput: Observable<Coin?> = Observable(nil)
    let coinIdInput: Observable<String?> = Observable(nil)
    
    let saveSuccesOutput: Observable<String?> = Observable(nil)
    let checkedButtonOutput: Observable<Bool?> = Observable(nil)

    let tableErrorOutput: Observable<RepositoryError?> = Observable(nil)
    
    // 리로드 필요시만 하기위해서....!
    let reloadTrigger: Observable<Void?> = Observable(nil)
    
    // 그후에 최대 개수를 확인했어야 했다.
    private func favoriteSetting(_ coin: Coin){
        // 즐겨찾기에 있는지 확인
        if repository.findFavorite(coin.id) {
           
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
    private func checkingButton(_ id: String) {
        checkedButtonOutput.value = repository.findFavorite(id)
        print("@@@@@@@",id)
        print("@@@@@@@",repository.findFavorite(id))
    }
}
