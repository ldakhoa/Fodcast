//
//  UIApplication.swift
//  FobCasts
//
//  Created by Le Doan Anh Khoa on 21/11/18.
//  Copyright © 2018 Le Doan Anh Khoa. All rights reserved.
//

import UIKit

extension UIApplication {
    
    static func mainTabBarController() -> MainTabBarController? {
        return shared.keyWindow?.rootViewController as? MainTabBarController
    }
    
}
