//
//  TrendingViewModel.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 3/2/24.
//

import Foundation

// 이때 var inputSection: Observable<[TrendingViewSection: Bool]?> = Observable(nil) 를통해 하려고 했으나
// didSet이 먹히지 않는것을 알아버렸습니다. 내부 내용이 바껴도 마치 클래스마냥
// 걸리지 않더군요 컬렉션 타입이 참 저를 괴롭힙니다..... 혼내주세요...

class TrendingViewModel {
    // MARK: 섹션
    // var inputSection: Observable<[TrendingViewSection: Bool]?> = Observable(nil)
    
    var inputSections: Observable<[TrendingViewSection]> = Observable([])
    
    var outputSection: Observable<[TrendingViewSection]> = Observable([])
    var outputTableSectionCount: Observable<Int> = Observable(0)
    
    var compliteTrigger: Observable<Void?> = Observable(nil)
    
    // MARK: 이렇게 그냥 하나 선언해도 될까요...?
    //    let sections: [TrendingViewSection] = TrendingViewSection.allCases

    init(){
        
        inputSections.bind {[weak self] sections in
            guard let self else {return}
           // guard let sections else {return}
            checkedData(sections)
            sectionSetting(sections)
        }

    }
    
    private func sectionSetting(_ section: [TrendingViewSection]){

        let setArray = Set(section)
        let data = setArray.sorted { first , second in
            first.rawValue < second.rawValue
        }
        print("^^^^^^section",data)
        outputSection.value = data
        checkedData(data)
    }
    
    private func checkedData(_ section: [TrendingViewSection]){
        outputTableSectionCount.value = section.count
        compliteTrigger.value = ()
    }
    
    
}



//var trigger: Observable<Void?> = Observable(nil)
//        trigger.bind { [weak self] void  in
//            guard let self else {return}
//            guard let void else {return}
//
//        }
//guard let data = inputSections.value else {
  //  return
//}//        let setArray:Set<TrendingViewSection> = section
//        inputSection.bind {[weak self] sections in
//            guard let self else {return}
//            guard let sections else {return}
//            checkedData(sections)
//            sectionTitle(sections)
//        }
/*
 //    private func sectionTitle(_ section: Set<TrendingViewSection>){
 //        let data = section.sorted { first , second in
 //            first.rawValue < second.rawValue
 //        }
 //    }
 //    private func checkedData(_ section: Set<TrendingViewSection>){
 //
 //        outputTableSectionCount.value = section.count
 //    }
 //
     
 //    private func checkedData(_ section: [TrendingViewSection : Bool]){
 //
 //        let count = section.mapValues { $0 == true }
 //        outputTableSectionCount.value = count.count
 //    }
 //    private func sectionSetting(_ section: Set<TrendingViewSection>){
 //        let data = section.sorted { first , second in
 //            first.rawValue < second.rawValue
 //        }
 //        outputSection.value.append(contentsOf: data)
 //    }
     
 //    private func sectionTitle(_ section: [TrendingViewSection : Bool]){
 //        let sctions = section.filter { $0.value }.map { $0.key }
 //        outputSection.value = sctions
 //        print("^^^^개수", inputSection.value?.count)
 //        print("^^^^",section)
 //    }

 */
