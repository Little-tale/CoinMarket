//
//  UserButton.swift
//  SeSacRecap2
//
//  Created by Jae hyung Kim on 3/3/24.
//

import UIKit

final class UserButton: UIBarButtonItem{
    
    init(image: UIImage?, style: UIBarButtonItem.Style, target: Any?, action: Selector?) {
        super.init()
        let imageView = CircleImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        imageView.image =  image
        self.customView = imageView
        self.action = action
        self.target = target as AnyObject?
        self.style = style
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
