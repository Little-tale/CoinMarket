//
//  BaseTableViewCell.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 2/27/24.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        all()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func all(){
        configureHierarchy()
        configureLayout()
        designView()
        registers()
    }
    
    func configureHierarchy(){
        
    }
    func configureLayout(){
        
    }
    func designView(){
        
    }
    func registers(){
        
    }
    
}
