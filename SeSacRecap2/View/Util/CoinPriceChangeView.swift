//
//  CoinPriceChangeView.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 2/29/24.
//

import UIKit
import SnapKit

struct CoinPiceModel{
    var price: Double
    var percentage: Double
    init(price: Double, percentage: Double) {
        self.price = price
        self.percentage = percentage
    }
}

struct CoinPriceModelString{
    var price: String
    var percentage: String
    init(price: String, percentage: String) {
        self.price = price
        self.percentage = percentage
    }
    
    init(price: String, psercentage: Double){
        self.price = price
        self.percentage = String(psercentage)
    }
}

final class CoinPriceChangeView: BaseView {
    let priceLabel = UILabel()
    let persantageLable = UILabel()
    
    let coinViewModel = CoinPriceChangeViewModel()
    
    override func configureHierarchy() {
        addSubview(priceLabel)
        addSubview(persantageLable)
    }
    
    override func designView() {
        priceLabel.font = .systemFont(ofSize: 20, weight: .bold)
        persantageLable.font = .systemFont(ofSize: 14, weight: .semibold)
        persantageLable.textAlignment = .center
        
    }
    private func updateLayout(_ aliment: Alignment) {
        persantageLable.snp.remakeConstraints { make in
            make.bottom.equalToSuperview().inset( 8 )
            // make.width.equalToSuperview().multipliedBy(0.4)
            // make.width.lessThanOrEqualTo(40)
            switch aliment {
            case .right:
                make.trailing.equalTo(self).inset(12)
            case .left:
                make.leading.equalTo(self).offset(12)
            }
        }
        priceLabel.snp.remakeConstraints { make in
            make.bottom.equalTo(persantageLable.snp.top).inset( -8)
            switch aliment {
            case .right:
                make.width.equalToSuperview().inset(-4)
                make.trailing.equalTo(self).inset(12)
            case .left:
                //make.width.equalToSuperview().inset(-4)
                make.leading.equalTo(self).offset(12)
            }
        }
        priceLabel.textAlignment = .right
        //priceLabel.backgroundColor = .myPink
    }
    override func subscribe() {
        coinViewModel.alimentCase.bind {[weak self] aliment in
            guard let self else {return}
            updateLayout(aliment)
        }
        coinViewModel.percentageProcessing.bind {[weak self]  percent in
            guard let self else {return}
            guard let percent else {return}
            persantageLable.text = "  " + percent + "  "
            print("^^^^^^^ percent",percent)
        }
        coinViewModel.priceProcessing.bind { [weak self] price in
            guard let self else {return}
            guard let price else {return}
            priceLabel.text = price
        }
        coinViewModel.isPlusOrNot.bind {[weak self] bool in
            guard let self else {return}
            guard let bool else {return}
            if bool {
                persantageLable.backgroundColor = .myPink
                persantageLable.textColor = .myred
            }else {
                persantageLable.backgroundColor = .mySky
                persantageLable.textColor = .myblue
            }
        }
        
    }
}
