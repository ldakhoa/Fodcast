//
//  String.swift
//  FobCasts
//
//  Created by Le Doan Anh Khoa on 16/11/18.
//  Copyright © 2018 Le Doan Anh Khoa. All rights reserved.
//

import Foundation

extension String {
    
    func toSecureHTTPS() -> String {
        return self.contains("https") ? self : self.replacingOccurrences(of: "http", with: "https")
    }
    
}
