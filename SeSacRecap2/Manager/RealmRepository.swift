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

class RealmRepository {
    
    let realm = try! Realm()
    let coinRealmTable = CoinRealmTable.self
    
    var canIFavorite: Bool{
        if 9 < realm.objects(coinRealmTable.self).count{
            print("@@@@@ false")
            return false
        }
        print("@@@@@ true")
        return true
    }
    
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
        
        let makeObject = CoinRealmTable(coinId: coin.id, coinName: coin.name, coinsymbol: coin.symbol, coinImage: coin.thumb)
        
        var message = ""
        do {
            try realm.write {
                if let dataSame = realm.objects(coinRealmTable).where({ $0.coinId == coin.id }).first {
                    realm.delete(dataSame)
                    message = "즐겨찾기를 제거!"
                } else {
                    realm.add(makeObject)
                    message = "즐겨찾기를 추가!"
                }
            }
            return .success(message)
        }catch {
            return .failure(.canAddYourObject)
        }
    }
    
    
    func findFavorite(_ id: String) -> Bool{
        if let sameData = realm.objects(coinRealmTable.self).where({ $0.coinId == id }).first {
            return true
        } else {
            return false
        }
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
