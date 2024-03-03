//
//  CoinDetailButtonCell.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 2/27/24.
//

import UIKit
import SnapKit

class CircleImageView: UIImageView{
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor.mypurple.cgColor
    }
}


class CoinDetailButtonCell: BaseTableViewCell {
    let detailImage = UIImageView()
    
    let nameLabel: UILabel = {
       let view = UILabel()
        view.font = .systemFont(ofSize: 22, weight: .bold)
        return view
    }()
    
    let subNameLabel: UILabel = {
       let view = UILabel()
        view.textColor = .gray
        view.font = .systemFont(ofSize: 17, weight: .light)
        return view
    }()
    
    let rightButton = StarButton()
    
    override func configureHierarchy() {
        contentView.addSubview(detailImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(subNameLabel)
        contentView.addSubview(rightButton)
    }
    
    override func configureLayout() {
        detailImage.snp.makeConstraints { make in
            make.size.equalTo(28)
            make.top.leading.equalTo(contentView.safeAreaLayoutGuide).offset(12)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(detailImage)
            make.leading.equalTo(detailImage.snp.trailing).offset(10)
            make.trailing.equalTo(rightButton.snp.leading).inset(4)
        }
        subNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(8)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
        }
        rightButton.snp.makeConstraints { make in
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(8)
            make.size.equalTo(detailImage).multipliedBy(0.9)
            make.centerY.equalTo(contentView.safeAreaLayoutGuide)
        }
    }

}
