//
//  Extention.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 2/27/24.
//

import UIKit

// Indentifier
extension UIView {
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}

// MARK: 후에 색상 변경해야해서 그린으로 눈에 띄게 설정
extension UILabel {
    func asFont(targetString: String) {
        let fullText = text ?? ""
        // MARK:
        let attributeString = NSMutableAttributedString(string: fullText)
        // MARK: 범위 + 대소문자 구분없이
        let range = (fullText as NSString).range(of: targetString, options: .caseInsensitive)
        
        attributeString.addAttribute(.foregroundColor ,value: UIColor.green, range: range)
        
        attributedText = attributeString

    }
}

extension UIViewController {
    func showAlert(error: APIError) -> UIAlertController {
        let alert = UIAlertController()
        alert.title = error.title
        alert.message = error.message
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true)
        }
        return alert
    }
    
    func showAlert(text: String?, message: String?) -> UIAlertController {
        let alert = UIAlertController()
        alert.title = text
        alert.message = message
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            alert.dismiss(animated: true)
        }
        return alert
    }
    
    func showAlert(error: RepositoryError) -> UIAlertController {
        let alert = UIAlertController()
        alert.title = error.title
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true)
        }
        return alert
    }
    
}

extension CoinChartViewController {
    
}
