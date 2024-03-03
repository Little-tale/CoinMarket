//
//  RealmTable.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 2/28/24.
//

import Foundation
import RealmSwift

class CoinSearchTable:Object {
    @Persisted(primaryKey: true) var coinId: String // 코인 아이디
    @Persisted var coinName: String // 코인 이름
    @Persisted var coinsymbol: String // 코인 이름약자
    @Persisted var coinImage: String // 실제 사용하진 않지만 일단 저장
    @Persisted var regDate: Date // 생성날짜
    @Persisted var buttonBool : Bool // 실제 사용하진 않지만 후에 모르니 저장
    
    convenience
    init(coinId: String, coinName: String, coinsymbol: String, coinImage: String) {
        self.init()
        self.coinId = coinId
        self.coinName = coinName
        self.coinsymbol = coinsymbol
        self.coinImage = coinImage
        self.regDate = Date()
        self.buttonBool = true
    }

}
