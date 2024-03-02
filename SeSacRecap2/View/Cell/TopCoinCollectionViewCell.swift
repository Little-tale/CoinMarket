//
//  TopCoinCollectionViewCell.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 3/2/24.
//

import UIKit
import SnapKit

class TopCoinCollectionViewCell: BaseCollectionViewCell{
    let rankLabel = UILabel()
    let coinInfoView = CoinInfoView()
    let coinPriceView = CoinPriceChangeView()
    
    let cellViewModel = TopCoinViewModel()
    
    override func configureHierarchy() {
        contentView.addSubview(rankLabel)
        contentView.addSubview(coinInfoView)
        contentView.addSubview(coinPriceView)
    }
    override func configureLayout() {
        rankLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(8)
            make.centerY.equalToSuperview()
            make.width.equalTo(14)
        }
        coinInfoView.snp.makeConstraints { make in
            make.leading.equalTo(rankLabel.snp.trailing).offset(4)
            make.centerY.equalToSuperview()
            make.verticalEdges.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.6)
        }
        coinPriceView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset( -8 )
            make.centerY.equalToSuperview()
            make.leading.greaterThanOrEqualTo(coinInfoView.snp.trailing).offset(8)
        }
        
    }
    
    override func designView() {
        coinPriceView.coinViewModel.alimentCase.value = .right
        subscribe()
    
    }
    deinit{
        print("@@@@",#function, self)
    }
}

extension TopCoinCollectionViewCell{
    func subscribe(){
        cellViewModel.outputCoinInfoModel.bind { [weak self] coinInfoModel in
            guard let self else {return}
            guard let coinInfoModel else {return}
            coinInfoView.viewModel.inputModel.value = coinInfoModel
        }
        
        cellViewModel.outputCoinItemModel.bind { [weak self] coinItem in
            guard let self else {return}
            guard let coinItem else {return}
            coinPriceView.coinViewModel.coinPriceModelString.value = coinItem
        }
    }
}
