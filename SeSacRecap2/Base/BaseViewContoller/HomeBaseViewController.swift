//
//  BaseViewController.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 2/27/24.
//

import UIKit

class HomeBaseViewController<T:BaseView>: UIViewController {
    
    let homeView = T()
    
    override func loadView() {
        view = homeView
        homeView.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        delegateDatasource()
    }
    
    func delegateDatasource(){
        
    }
    
}
