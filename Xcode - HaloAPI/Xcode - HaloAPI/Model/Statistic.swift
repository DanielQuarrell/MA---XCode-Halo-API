//
//  Statistic.swift
//  Xcode - HaloAPI
//
//  Created by Daniel Quarrell on 29/11/2019.
//  Copyright © 2019 Daniel Quarrell. All rights reserved.
//

import Foundation

class Statistic {
    
    var name: String?
    var value: Float?
    var valueString: String?
    var isFloat : Bool?
    
    init(name: String? = nil, value: Float? = nil, valueString: String? = nil, isFloat: Bool? = false){
        self.name = name
        self.value = value
        self.valueString = valueString
        self.isFloat = isFloat
    }
}
