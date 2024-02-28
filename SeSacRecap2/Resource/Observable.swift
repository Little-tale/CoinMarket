//
//  Observable.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 2/27/24.
//

import Foundation

class Observable<T> {
    
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
}
