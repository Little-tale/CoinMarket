//
//  notificationViewModel.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 3/1/24.
//




import Foundation

// 원래는.... 공통 데이터.... 처리하려.....했는데....
// 정말 진심으로 하루를 쏟았는데 ...ㅠㅠㅠㅠ 도저히 해결이 되지 않아서....
// 너무 속상합니다. 일단은... 이렇게라도 해결해 보려고 합니다...
// 수업에서 자꾸 뒤쳐지고 이해도가 낮아서 정말 죄송합니다...
final class ReloadViewModel {
    
    static let shared = ReloadViewModel()
    
    var inReloadView: Observable<Void?> = Observable(nil)
    var OutReloadView: Observable<Void?> = Observable(nil)
    var inputLoadView: Observable<Void?> = Observable(nil)
    var outputLoadView: Observable<Void?> = Observable(nil)
    
    private init(){
        inReloadView.bind { [weak self] void in
            guard let self else {return}
            OutReloadView.value = void
        }
        inputLoadView.bind { [weak self] void in
            guard let self else {return}
            outputLoadView.value = void
        }
    }
    
}
