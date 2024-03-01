//
//  BaseViewController.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 2/27/24.
//

class ObservedTest {
    var notification: Observable<Void?> = Observable(nil)
}

import UIKit

class BaseViewController: UIViewController {
    
    let myNotification = ObservedTest()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        all()
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
