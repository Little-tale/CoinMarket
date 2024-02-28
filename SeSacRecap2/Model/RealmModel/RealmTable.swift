//
//  RealmTable.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 2/28/24.
//

import Foundation
import RealmSwift

class CoinRealmTable:Object {
    @Persisted(primaryKey: true) var id : ObjectId
    @Persisted var coinId: String
    @Persisted var coinName: String
    @Persisted var coinsymbol: String
    @Persisted var coinImage: String
    
    convenience
    init(coinId: String, coinName: String, coinsymbol: String, coinImage: String) {
        self.init()
        self.coinId = coinId
        self.coinName = coinName
        self.coinsymbol = coinsymbol
        self.coinImage = coinImage
    }

    
}
