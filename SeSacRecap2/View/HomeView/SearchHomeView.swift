//
//  SearchHomeView.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 2/27/24.
//

import UIKit
import SnapKit

final class TableHomeView: BaseView {
    let customTableView = UITableView(frame: .zero, style: .grouped)
    
    override func configureHierarchy() {
        self.addSubview(customTableView)
    }
    override func configureLayout() {
        customTableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    override func register() {
        super.register()
        customTableView.register(CoinDetailButtonCell.self, forCellReuseIdentifier: CoinDetailButtonCell.reusableIdentifier)
        
        customTableView.register(TableInCollectionFavoriteTableCell.self, forCellReuseIdentifier: TableInCollectionFavoriteTableCell.reusableIdentifier)
        
        customTableView.register(NewTableInCollectionFavoriteTableCell.self, forCellReuseIdentifier: NewTableInCollectionFavoriteTableCell.reusableIdentifier)
    }
    override func designView() {
        customTableView.backgroundColor = .white
        // MARK: 테이블뷰 구분선 제거
        customTableView.separatorStyle = .none
    }
}
