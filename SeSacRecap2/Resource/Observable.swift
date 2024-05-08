//
//  Observable.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 2/27/24.
//

import Foundation

final class Observable<T> :Unbinding{
    
    var value: T {
        didSet{
           listener?(value)
        }
    }
    private var listener: ((T) -> Void)?
    
    init(_ type: T) {
        self.value = type
    }
    
    func bind(_ listener: @escaping(T) -> Void){
        listener(value)
        self.listener = listener
    }
    //
    //MARK: 구독자 제거
    func unBind(){
        listener = nil
    }
    deinit {
        unBind()
    }
}

// MARK: 하나하나 지우는것도 참 힘들것 같음 다음에는 이렇게 해봐여 할것 같다
// 생각 대로 또 안된다.... Any로 모아서 했는데 우울하다
protocol Unbinding {
    func unBind()
}

final class ObservableGroup {
    
    private var observables: [Unbinding] = []
    
    func add(_ observer: Unbinding){
        observables.append(observer)
    }
    
    //MARK: 구독자들 제거
    func unBindAll() {
        observables.forEach { $0.unBind() }
    }
    deinit {
        // unBindAll()
    }
}
