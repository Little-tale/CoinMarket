//
//  BaseCollectionViewCell.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 2/28/24.
//

import UIKit
class BaseCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        all()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func all(){
        configureHierarchy()
        configureLayout()
        designView()
    }
    
    func configureHierarchy(){
        
    }
    func configureLayout(){
        
    }
    func designView(){
        
    }
    
}
