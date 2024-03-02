//
//  CoinInfoView.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 2/29/24.
//

import UIKit
import SnapKit
import Kingfisher

struct CoinInfoModel{
    var imageName:String
    var coinName:String
    var symBol:String
    init(imageName: String, coinName: String, symBol: String) {
        self.imageName = imageName
        self.coinName = coinName
        self.symBol = symBol
    }
}


class CoinInfoView: BaseView {
    let imageView = UIImageView()
    let coinName = UILabel()
    let symBol = UILabel()
    
    let viewModel = SubCoinInfoViewModel()
    
    override func configureHierarchy() {
        self.addSubview(imageView)
        self.addSubview(coinName)
        self.addSubview(symBol)
    }
    override func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.size.equalTo(40)
            make.leading.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
        }
        coinName.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(8)
            make.top.equalTo(imageView)
            make.trailing.equalToSuperview().inset(4)
        }
        symBol.snp.makeConstraints { make in
            make.bottom.equalTo(imageView.snp.bottom)
            make.leading.equalTo(coinName)
            make.trailing.equalToSuperview().inset(4)

        }
    }
    override func designView() {
        coinName.font = .systemFont(ofSize: 18, weight: .bold)
        symBol.font = .systemFont(ofSize: 14, weight: .semibold)
        symBol.textColor = .systemGray
        
        viewModel.inputModel.bind {[weak self] coin in
            guard let self else {return}
            guard let coin else {return}
            let url = URL(string: coin.imageName)
            imageView.kf.setImage(with: url)
            coinName.text = coin.coinName
            symBol.text = coin.symBol
        }
    }
    
}
