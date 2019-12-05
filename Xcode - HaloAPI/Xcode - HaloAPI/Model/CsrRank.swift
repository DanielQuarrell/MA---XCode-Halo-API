//
//  CsrRank.swift
//  Xcode - HaloAPI
//
//  Created by Daniel Quarrell on 05/12/2019.
//  Copyright © 2019 Daniel Quarrell. All rights reserved.
//

import Foundation
import UIKit

class CsrRank {
    
    var playlistName: String?
    var rankName: String?
    var rankImage: UIImage?
    
    init(rankName: String? = nil, rankImage: UIImage? = nil){
        self.rankName = rankName
        self.rankImage = rankImage
    }
}
