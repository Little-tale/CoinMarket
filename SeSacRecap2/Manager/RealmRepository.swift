//
//  RealmRepositry.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 2/28/24.
//

import Foundation
import RealmSwift

extension Error {
    var RepositoryError: RepositoryError? {
        self as? RepositoryError
    }
}

enum RepositoryError: Error{
    case canAddYourObject
    case deleteFail
    
    
    var title: String{
        return "데이터 베이스 오류!"
    }
    var message: String {
        switch self {
        case .canAddYourObject:
            "현재 추가하실수 없어요!"
        case .deleteFail:
            "삭제실패 하였습니다."
        }
    }
}

final class RealmRepository {
    
    let realm = try! Realm()
    let coinRealmTable = CoinSearchTable.self
    
    var canIFavorite: Bool{
        print(realm.configuration.fileURL)
        let count = realm.objects(coinRealmTable.self).where { $0.buttonBool == true}.count
        
        if 9 < count{
            print("@@@@@ false")
            return false
        }
        print("@@@@@ true")
        return true
    }
    // 안쓸수도 있자만 일단 구현
    func removeLastFavoriteButton() throws {
        do{
            try realm.write {
                if let last = realm.objects(coinRealmTable).last{
                    realm.delete(last)
                }
            }
        } catch {
            throw RepositoryError.deleteFail
        }
    }
    
    // MARK: 새로짠 코인 테이블
    func newOrDeleteFavoriteCoin(coin: Coin) -> Result<String, RepositoryError>{
        print(realm.configuration.fileURL)
        var message = ""
        do {
            try realm.write {
                if let dataSame = realm.objects(coinRealmTable).where({ $0.coinId == coin.id }).first {
                    realm.delete(dataSame)
                    message = "즐겨찾기를 제거!"
                } else {
                    let makeObject = CoinSearchTable(coinId: coin.id, coinName: coin.name, coinsymbol: coin.symbol, coinImage: coin.thumb)
                    realm.add(makeObject)
                    message = "즐겨찾기를 추가!"
                }
            }
            return .success(message)
        }catch {
            return .failure(.canAddYourObject)
        }
    }
    
    func newOrDeleteFavoriteCoin(table: CoinSearchTable) -> Result<String, RepositoryError>{
        print(realm.configuration.fileURL)
        var message = ""
        do {
            try realm.write {
                if let dataSame = realm.objects(coinRealmTable).where({ $0.coinId == table.coinId }).first {
                    realm.delete(dataSame)
                    message = "즐겨찾기를 제거!"
                } else {
                    let makeObject = CoinSearchTable(coinId: table.coinId, coinName: table.coinName, coinsymbol: table.coinsymbol, coinImage: table.coinImage)
                    realm.add(makeObject)
                    message = "즐겨찾기를 추가!"
                }
            }
            return .success(message)
        }catch {
            return .failure(.canAddYourObject)
        }
    }
    
    // 조건없이 coin 테이블을 생성합니다.
//    func makeCoinTable(coin: Coin) throws {
//        let result = CoinSearchTable(coinId: coin.id, coinName: coin.name, coinsymbol: coin.symbol, coinImage: coin.thumb)
//        do {
//            try realm.write {
//                realm.add(result)
//            }
//        } catch {
//            throw RepositoryError.canAddYourObject
//        }
//    }
//    
    
    // MARK: 즐겨찾기를 찾아드립니다.
    func findFavorite(_ id: String) -> Bool{
        print(realm.configuration.fileURL)
        if let sameData = realm.objects(coinRealmTable.self).where({ $0.coinId == id }).first {
            if sameData.buttonBool {
                return true
            }else {
                return false
            }
        } else {
            return false
        }
    }
    
    // MARK: 즐겨찾기 상태를 토글합니다.
    func changeLikeState(_ id: String) -> Result<String, RepositoryError>{
        print(realm.configuration.fileURL)
        if let sameData = realm.objects(coinRealmTable.self).where({ $0.coinId == id }).first {
            do {
                try realm.write {
                    sameData.buttonBool.toggle()
                }
                if sameData.buttonBool {
                    return .success("즐겨찾기 추가하였습니다.")
                }
                return .success("즐겨찾기 취소하였습니다.")
            } catch {
                return .failure(.canAddYourObject)
            }
        }
        return .failure(.canAddYourObject)
    }
    
    func deleteOf(_ id: String) {
        do{
            try realm.write {
                if let data = realm.objects(coinRealmTable.self).where({ $0.coinId == id }).first {
                    realm.delete(data)
                }
            }
        }catch {
            print(error)
        }
    }
    // 현재 모든 코인을 가져옵니다.
    func getFavoriteList() -> [CoinSearchTable] {
        let results = realm.objects(coinRealmTable)
        let array = Array(results)
        return array
    }
    
    func getFavoriteResults() -> [Results<CoinSearchTable>] {
        let results = realm.objects(coinRealmTable)
        return Array(arrayLiteral: results)
    }
    
    // id를 조회해 코인 테이블을 가져옵니다.
    func getCoin(_ id: String) -> CoinSearchTable? {
        let data = realm.objects(coinRealmTable).where { $0.coinId == id }
        let array = Array(data)
        return array.first
    }
    
}



/*
 func removeLast<T: Object>(type: T.Type){
     do{
         let last = realm.objects(type.self).last
         realm.delete(last)
     } catch {
         
     }
     
 }
 */

/*
 do{
     try realm.write {
         // Results
         let data = realm.objects(coinRealmTable)
         if let datalast = data.last {
             realm.delete(datalast)
         }
     }
 } catch {
     // 여기 에러처리는 난감하네
     print(error)
 }
 */
/// MAKE Favorite Id
//    func newFavorite(_ id: String) -> Result<String, RepositoryError> {
//        print(realm.configuration.fileURL)
//        let object = CoinRealmTable(coinId: id)
//        var message = ""
//        do{
//            try realm.write {
//                if let sameData = realm.objects(coinRealmTable).where({ $0.coinId == id }).first {
//                    // sameData.coinButton.toggle()
//                    realm.delete(sameData)
//                    message = "즐겨찾기를 취소하였어요"
//                } else {
//                    realm.add(object)
//                    message = "즐겨찾기에 추가하였어요"
//                }
//            }
//            return .success(message)
//        } catch {
//            return .failure(.canAddYourObject)
//        }
//    }
