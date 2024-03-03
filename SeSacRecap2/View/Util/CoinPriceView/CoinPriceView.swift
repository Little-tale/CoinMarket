//
//  CoinPriceView.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 2/28/24.
//

import UIKit
import SnapKit
import Kingfisher

class CoinPriceView: BaseView {
    let mainCoinImageView = UIImageView()
    let coinName = UILabel()
    let priceLabel = UILabel()
    let persentage = UILabel()
    let dateLabel = UILabel()
   
    private let superLowLabel = UILabel()
    
    let viewModel = CoinPriceViewModel()
    
    
    override func configureHierarchy() {
        self.addSubview(mainCoinImageView)
        self.addSubview(coinName)
        self.addSubview(priceLabel)
        self.addSubview(persentage)
        self.addSubview(dateLabel)
    }
    override func configureLayout() {
        // 이미지
        mainCoinImageView.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().inset(8)
            make.size.equalTo(48)
        }
        // 코인이름
        coinName.snp.makeConstraints { make in
            make.leading.equalTo(mainCoinImageView.snp.trailing).offset(10)
            make.top.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(12)
        }
        // 가격
        priceLabel.snp.makeConstraints { make in
            make.leading.equalTo(mainCoinImageView)
            make.top.equalTo(mainCoinImageView.snp.bottom).offset(24)
            make.trailing.equalToSuperview().inset(12)
        }
        // 퍼센트
        persentage.snp.makeConstraints { make in
            make.leading.equalTo(mainCoinImageView)
            make.top.equalTo(priceLabel.snp.bottom).offset(4)
        }
        // 날짜
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(persentage.snp.trailing).offset(8)
            make.top.equalTo(persentage)
        }
    }
    override func designView() {
        coinName.font = .systemFont(ofSize: 30, weight: .bold)
        priceLabel.font = .boldSystemFont(ofSize: 40)
        persentage.font = .systemFont(ofSize: 20, weight: .semibold)
        // ##### 색 후에 수정사항
        persentage.textColor = .red
        dateLabel.font = .systemFont(ofSize: 20, weight: .semibold)
    }
    
    // MARK 또다른 뷰모델
    override func subscribe() {
        viewModel.coinImageOutput.bind {[weak self] url in
            // print("$$$$URL",url)
            guard let url else {return}
            guard let self else {return}
            
            mainCoinImageView.kf.setImage(with: url)
        }
        viewModel.coinNameOutput.bind { [weak self] string in
            guard let self else {return}
            coinName.text = string
        }
        viewModel.current.bind { [weak self] string in
            guard let self else {return}
            priceLabel.text = string
        }
        viewModel.presentageOutput.bind { [weak self] string in
            guard let self else {return}
            persentage.text = string
        }
        viewModel.dateOutPut.bind { [weak self] string in
            print(string)
            guard let self else {return}
            dateLabel.text = string
        }
        
    }
}



