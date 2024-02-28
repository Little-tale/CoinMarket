//
//  ColorEssets.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 2/28/24.
//

import UIKit

// MARK: 차트뷰를 위해서....
enum DataColor: CaseIterable {
    case first
    case second
    case third

    var color: UIColor {
        switch self {
        case .first: return UIColor(red: 56/255, green: 58/255, blue: 209/255, alpha: 1)
        case .second: return UIColor(red: 235/255, green: 113/255, blue: 52/255, alpha: 1)
        case .third: return UIColor(red: 52/255, green: 235/255, blue: 143/255, alpha: 1)
        }
    }
}

enum ColorEssets {
    case myPuPle
    case myBlue
    case myPink
    case myRed

    
    var color: UIColor {
        switch self {
        case .myPuPle:
            return UIColor.mypurple
        case .myBlue:
            return UIColor.myblue
        case .myPink:
            return UIColor.myPink
        case .myRed:
            return UIColor.myred
        }
    }
}
