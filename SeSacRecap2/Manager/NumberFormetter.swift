//
//  NumberFormetter.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 2/28/24.
//

import Foundation

class NumberFormetter {
    private init() {}
    static let shared = NumberFormetter()
    private let formetter = NumberFormatter()
    
    
    func makeKRW(price: Double) -> String{
        formetter.numberStyle = .decimal
        let priceInt = Int(price)
        let results = formetter.string(from: priceInt as NSNumber)
        guard let results else {return ""}
        return "₩"+results
    }
    
    func presentation(persentage: Double) -> String {
        let formattedString = String(format: "%.2f",  persentage)
        // "556.58"
        return formattedString + "%"
    }
}
