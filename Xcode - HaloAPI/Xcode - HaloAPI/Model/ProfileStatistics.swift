//
//  ProfileStatistics.swift
//  Xcode - HaloAPI
//
//  Created by Daniel Quarrell on 05/12/2019.
//  Copyright © 2019 Daniel Quarrell. All rights reserved.
//

import Foundation
import SwiftyJSON

class ProfileStatistics {
    
    var gamertag: String!
    var serviceTag: String!
    
    var spartanRank: Int!
    var xp: Int!
    var xpToNextRank: Int!
    
    var designationId: Int!
    var highestCSR: CsrRank!
    
    public func getProfileData (completion: @escaping () -> ()) {
        let group = DispatchGroup()
        group.enter()
        HaloApiInterface.sharedInstance.getProfileJson(completion: {(json) in
            self.gamertag = json["Gamertag"].stringValue
            self.serviceTag = json["ServiceTag"].stringValue
            
            group.leave()
        })
        
        group.enter()
        HaloApiInterface.sharedInstance.getArenaJsonStatistics(completion: {(json) in
            
            self.spartanRank = json["Results"][0]["Result"]["SpartanRank"].intValue
            self.xp = json["Results"][0]["Result"]["Xp"].intValue
            
            if(json["Results"][0]["Result"]["ArenaStats"]["HighestCsrAttained"] != JSON.null) {
                self.designationId = json["Results"][0]["Result"]["ArenaStats"]["HighestCsrAttained"]["DesignationId"].intValue
            }
            
            HaloApiInterface.sharedInstance.getXpToNextRank(rank: self.spartanRank, completion: {(xpNeeded) in
                self.xpToNextRank = xpNeeded
                group.leave()
            })
        })

        group.notify(queue: .main) {
            completion()
        }
    }
    
    public func getHighestCsr(completion: @escaping (_ hasCsr: Bool) -> ()) {
        if(designationId != nil)
        {
            HaloApiInterface.sharedInstance.fetchCsrDesignation(desingnationId: self.designationId, completion: {(csrName, csrImage) in
                
                self.highestCSR = CsrRank(rankName: csrName, rankImage: csrImage)
                completion(true)
            })
        }
        else
        {
            completion(false)
        }
    }
}
