//
//  CoinStarCollectionViewCell.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 2/29/24.
//

import UIKit
import SnapKit

class CoinStarCollectionViewCell: BaseCollectionViewCell {
    
    let coinInfoView = CoinInfoView()
   let coinPriceChangeView = CoinPriceChangeView()
    
    override func configureHierarchy() {
        contentView.addSubview(coinInfoView)
        contentView.addSubview(coinPriceChangeView)
    }
    override func configureLayout() {
        coinInfoView.snp.remakeConstraints { make in
            make.horizontalEdges.top.equalTo(contentView.safeAreaLayoutGuide)
            make.height.equalTo(contentView.snp.height).multipliedBy(0.5)
        }
        coinPriceChangeView.snp.remakeConstraints { make in
            make.horizontalEdges.bottom.equalTo(contentView.safeAreaLayoutGuide)
            make.top.equalTo(coinInfoView.snp.bottom)
        }
        // coinInfoView.backgroundColor = .red
        // coinPriceChangeView.backgroundColor = .myblue
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        setupShadow(nil)
    }
    
    func setupShadow(_ bool: Bool? ){
        guard let bool else {return}
        if !bool {return}
        self.contentView.layer.masksToBounds = true
        
        self.layer.shadowColor = UIColor.black.cgColor
        
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        self.layer.shadowRadius = 2
        
        self.layer.shadowOpacity = 0.2
        
        self.layer.masksToBounds = false
    }
    
    
}
