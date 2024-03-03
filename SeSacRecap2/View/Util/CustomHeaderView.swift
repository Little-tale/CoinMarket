//
//  CustomHeaderView.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 3/2/24.
//

import UIKit
import SnapKit

final class CustomHeaderView: BaseView{
    let titleLabel = UILabel()
    
    override func configureHierarchy() {
        self.addSubview(titleLabel)
    }
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.verticalEdges.trailing.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
        }
    }
    override func designView() {
        titleLabel.textColor = .black
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
    }
}
