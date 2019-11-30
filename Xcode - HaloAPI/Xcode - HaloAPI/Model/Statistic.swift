//
//  Statistic.swift
//  Xcode - HaloAPI
//
//  Created by Daniel Quarrell on 29/11/2019.
//  Copyright © 2019 Daniel Quarrell. All rights reserved.
//

import Foundation

class Statistic
{
    var name: String?
    var value: Float?
    
    init(name: String? = nil, value: Float? = nil){
        self.name = name
        self.value = value
    }
}
