//
//  MoreCollectionViewcell.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 3/3/24.
//

import UIKit
import SnapKit
final class ModeCollectionViewCell: BaseCollectionViewCell {

    private var label: UILabel = {
       let view = UILabel()
        view.text = "더보기"
        view.font = .systemFont(ofSize: 30, weight: .semibold)
        view.textColor = .mypurple
        return view
    }()

    override func configureHierarchy() {
        contentView.addSubview(label)
    }
    override func configureLayout() {
        label.snp.makeConstraints { make in
            make.verticalEdges.trailing.equalToSuperview()
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(12)
        }
    }
}
