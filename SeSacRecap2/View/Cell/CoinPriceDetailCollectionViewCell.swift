//
//  CoinPriceDetailCollectionViewCell.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 2/28/24.
//

import UIKit
import SnapKit

class CoinPriceDetailCollectionViewCell: BaseCollectionViewCell {
    let priceTitle = UILabel()
    let price = UILabel()
    let superPriceTitle = UILabel()
    let superPrice = UILabel()
    
    override func configureHierarchy() {
        contentView.addSubview(priceTitle)
        contentView.addSubview(price)
        contentView.addSubview(superPriceTitle)
        contentView.addSubview(superPrice)
    }
    override func configureLayout() {
        priceTitle.snp.makeConstraints { make in
            make.leading.top.equalTo(contentView.safeAreaLayoutGuide).inset(4)
            make.height.equalTo(28)
        }
        price.snp.makeConstraints { make in
            make.top.equalTo(priceTitle.snp.bottom).offset(12)
            make.leading.equalTo(priceTitle)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(24)
        }
        superPriceTitle.snp.makeConstraints { make in
            make.leading.equalTo(price)
            make.top.equalTo(price.snp.bottom).offset(16)
            make.height.equalTo(28)
        }
        superPrice.snp.makeConstraints { make in
            make.top.equalTo(superPriceTitle.snp.bottom).offset(12)
            make.leading.equalTo(priceTitle)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(24)
        }

    }
    override func designView() {
        priceTitle.font = .systemFont(ofSize: 24, weight: .bold)
        superPriceTitle.font = .systemFont(ofSize: 24, weight: .bold)
        
        price.font = .systemFont(ofSize: 20, weight: .semibold)
        superPrice.font = .systemFont(ofSize: 20, weight: .semibold)
        
        price.textColor = .systemGray
        superPrice.textColor = .systemGray
    }
    
}
