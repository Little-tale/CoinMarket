//
//  CoinChartViewModel.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 2/28/24.
//
// MARK: 어떻게 해야 저 UI들을 유연하게 할수있을지
// MARK: 어떻게 해야 뷰모델이 덜 무거워 질지 감이 잘 오질 않습니다...
// MARK: 막상 이런 UI들을 보고 있으니 도무지 감이 오지 않았습니다....
// MARK: 어떤 키워드들을 공부해야 이런 UI들을 유연하게 대처해볼 수 있을까요..!
import Foundation

final class CoinChartViewModel {
    // INPUT
    var coinInfoInput: Observable<Coin?> = Observable(nil)
    var cellTextColorInput: Observable<IndexPath?> = Observable(nil)
    var checkedButtonStateInput: Observable<Void?> = Observable(nil)
    var coinIdInput: Observable<String?> = Observable(nil)
    
    // MARK: 트리거
    var inputViewdidLoadTrigger: Observable<Void> = Observable(())
    var modernization: Observable<Void?> = Observable(nil)
    
    // OUTPUT
    var mainCoinInfoOutput: Observable<CoinPriceModel?> = Observable(nil)
    var collectionDataOutput: Observable<[chartSectionData]> = Observable([])
    var cellectionCellColorBool: Observable<Bool?> = Observable(nil)
    var chartDataOutPut: Observable<[Double]> = Observable([])
    
    var firstButtonState: Observable<Bool?> = Observable(nil)
    var errorOutPut: Observable<String?> = Observable(nil)
    var dateLabelInfoOutput: Observable<String> = Observable("")
    
    // Static
    var repository = RealmRepository()
    
    // ALLLiten
    // var allLiten: ObservableGroup<[Any]> = ObservableGroup([])
    var allListen = ObservableGroup()
    init() {
        allListen.add(coinInfoInput)
        allListen.add(cellTextColorInput)
        allListen.add(checkedButtonStateInput)
        allListen.add(inputViewdidLoadTrigger)
        allListen.add(modernization)
        allListen.add(mainCoinInfoOutput)
        allListen.add(collectionDataOutput)
        allListen.add(chartDataOutPut)
        allListen.add(firstButtonState)
        allListen.add(dateLabelInfoOutput)
        
        coinInfoInput.bind {[weak self] coin in
            guard let coin else {return}
            guard let self else {return}
            fetch(coin)
            checkLikeButton(coin.id)
        }
       
        cellTextColorInput.bind { [weak self] indexPath in
            guard let self else {return}
            guard let indexPath else {return}
            prefetchCellColorBool(row: indexPath.row)
        }
        checkedButtonStateInput.bind { [weak self] void in
            guard let self else {return}
            guard void != nil else {return}
            checkLikeButton()
            // MARK: 탭바 컨트롤러에게 알립니다.
            ReloadViewModel.shared.inputLoadView.value = ()
            inputViewdidLoadTrigger.value = ()
        }
        coinIdInput.bind { [weak self] coinId in
            guard let self else {return}
            guard let coinId  else {return}
            fetch(coinId)
            checkLikeButton(coinId)
        }
        modernization.bind {[weak self] void in
            guard let self else {return}
            guard let void  else {return}
            guard let id = coinIdInput.value else {return}
            fetch(id)
        }
    }
    // MARK: 이부분을 좀더 단단하게 해야 해결할듯
    private func checkLikeButton(_ id: String){
        let bool = repository.findFavorite(id)
        firstButtonState.value = bool
    }
        
    private func checkLikeButton(){
        if let coin = coinInfoInput.value {
            // 메시지
            let result = repository.newOrDeleteFavoriteCoin(coin: coin)
            switch result {
            case .success(let success):
                errorOutPut.value = success
            case .failure(let failure):
                errorOutPut.value = failure.title
            }
            // 버튼 상태
            let bool = repository.findFavorite(coin.id)
            firstButtonState.value = bool
        } else {
            
        }
    }
    
    private func fetch(_ coinId: String) {
        APIReqeustManager.shared.fetchRequest(type: [CoinMarket].self, api: .markets(marketId: [coinId], contry: .kor, spakelType: true)) { results in
            switch results {
            case .success(let success):
                guard let result =  success.first else {return}
                print(result)
                self.prefetchCoinMainInfo(coinMarket: result)
                self.prefetchCoinHighLowInfo(coinMarket: result)
                self.prefetchChartData(market: result)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    /// 성공시 [CoinMarket] 반환받음 1차시동 성공 []가 여긴 하나라 그냥 벗겨야함
    /// 실패시 APIError 를 반환받음
    private func fetch(_ coin: Coin){
        APIReqeustManager.shared.fetchRequest(type: [CoinMarket].self, api: .markets(marketId: [coin.id], contry: .kor, spakelType: true)) { results in
            switch results {
            case .success(let success):
                guard let result =  success.first else {return}
                print(result)
                self.prefetchCoinMainInfo(coinMarket: result)
                self.prefetchCoinHighLowInfo(coinMarket: result)
                self.prefetchChartData(market: result)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    private func fetch(_ table: CoinSearchTable) {
        APIReqeustManager.shared.fetchRequest(type: [CoinMarket].self, api: .markets(marketId: [table.coinId], contry: .kor, spakelType: true)) { results in
            switch results {
            case .success(let success):
                guard let result =  success.first else {return}
                print(result)
                self.prefetchCoinMainInfo(coinMarket: result)
                self.prefetchCoinHighLowInfo(coinMarket: result)
                self.prefetchChartData(market: result)
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
    ///코인정보와 날짜를 를 전달합니다.
    private func prefetchCoinMainInfo(coinMarket : CoinMarket){
        let result =  DateAssistance.shared.localDate(coinMarket.lastUpdated)
        
        let coinModel = CoinPriceModel(coinName: coinMarket.name, coinImage: coinMarket.image, persentTage: coinMarket.priceChangePercentage24H, current: coinMarket.currentPrice)
        mainCoinInfoOutput.value = coinModel
        dateLabelInfoOutput.value = result + " 업데이트"
    }
    
    /// 컬렉션뷰 셀의 데이터를 전달합니다.....
    private func prefetchCoinHighLowInfo(coinMarket: CoinMarket) {
        let high = NumberFormetter.shared.makeKRW(price: coinMarket.high24H)
        let superHigh = NumberFormetter.shared.makeKRW(price: coinMarket.ath)
        let first = chartSectionData(normal: high, supers: superHigh)
        
        let low = NumberFormetter.shared.makeKRW(price: coinMarket.low24H)
        let superLow = NumberFormetter.shared.makeKRW(price: coinMarket.atl)
        let second = chartSectionData(normal: low, supers: superLow)
        collectionDataOutput.value = [first,second]
    }
    
    /// 컬러의 true false 의 따라 색을 구분합니다.
    private func prefetchCellColorBool(row: Int){
        let bool = CharSection.allCases[row].colorBool
        cellectionCellColorBool.value = bool
    }
    
    private func prefetchChartData(market: CoinMarket){
        guard let market7d = market.sparklineIn7D else {return}
        chartDataOutPut.value = market7d.price
    }
    
    
}
/*
 let id, symbol, name: String // 코인 아이디, 코인 통화단위, 코인이름
 let image: String // 코인 아이콘 리소스
 
 let currentPrice: Double? // 코인 현재가
 let priceChangePercentage24H: Double? // 코인 현재가 (시가) // 퍼센테이지
 let high24H, low24H: Double? // 코인 고가, 코인 저기
 let ath: Double? // 코인 사상최고가 (신고점, ALL-Time-High)
 let athDate: String? // 신고점 일자
 let atlDate: String? // 신저점 일자
 let atl: Double? // 코인 사상 최저가 (신고점, ALL-Time-Low)
 let lastUpdated: String? // 코인 시장 데이터 업데이트 시각
 let sparklineIn7D: SparklineIn7D? // 일주일간 코인 시세 정보
 */

/*
 var coinTableInfoInput: Observable<CoinSearchTable?> = Observable(nil)
 
 coinTableInfoInput.bind { [weak self] table in
     guard let table else {return}
     guard let self else {return}
     fetch(table)
     checkLikeButton(table.coinId)
 }
 private
 func test(){
     if let table = coinTableInfoInput.value {
         let result = repository.newOrDeleteFavoriteCoin(table: table)
         switch result {
         case .success(let success):
             errorOutPut.value = success
         case .failure(let failure):
             errorOutPut.value = failure.title
         }
         // 버튼 상태
         print(table)
         let bool = repository.findFavorite(table.coinId)
         firstButtonState.value = bool
     }
 }
 */
