//
//  SearchHomeView.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 2/27/24.
//

import UIKit
import SnapKit

class SearchHomeView: BaseView {
    let tableView = UITableView(frame: .zero)
    
    override func configureHierarchy() {
        self.addSubview(tableView)
    }
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    override func register() {
        super.register()
        tableView.register(CoinDetailButtonCell.self, forCellReuseIdentifier: CoinDetailButtonCell.reusableIdentifier)
    }
}
