//
//  TrendingViewModel.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 3/2/24.
//

import Foundation

class TrendingViewModel {
    // MARK: 섹션
    var inputSection: Observable<[TrendingViewSection: Bool]?> = Observable(nil)
    
    var outputSection: Observable<[TrendingViewSection]> = Observable([])
    var outputTableSectionCount: Observable<Int> = Observable(0)
    
    init(){
        inputSection.bind {[weak self] sections in
            guard let self else {return}
            guard let sections else {return}
            checkedData(sections)
            sectionTitle(sections)
        }
        
    }
    
    private func sectionTitle(_ section: [TrendingViewSection : Bool]){
        let sctions = section.filter { $0.value }.map { $0.key }
        outputSection.value = sctions
    }
    
    private func checkedData(_ section: [TrendingViewSection : Bool]){
        
        let count = section.mapValues { $0 == true }
        outputTableSectionCount.value = count.count
    }
    
}
