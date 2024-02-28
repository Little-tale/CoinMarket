//
//  StarButton.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 2/27/24.
//

import UIKit

class StarButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setting()
        addTarget(self, action: #selector(selectColor), for: .touchUpInside)
    }
    
    @objc
    func selectColor() {
        self.isSelected = !self.isSelected
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setting(){
        self.setImage(UIImage(named: "btn_star_fill") , for: .selected)
        self.setImage(UIImage(named: "btn_star"), for: .normal)
    }

}
