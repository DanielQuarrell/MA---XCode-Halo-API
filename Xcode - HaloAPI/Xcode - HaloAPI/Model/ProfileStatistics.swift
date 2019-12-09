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
        
        //Create dispatch group to deal with multiple API calls
        let group = DispatchGroup()
        group.enter()
        HaloApiInterface.sharedInstance.getProfileJson(completion: {(json) in
            //Get data through SwiftyJSON
            self.gamertag = json["Gamertag"].stringValue
            self.serviceTag = json["ServiceTag"].stringValue
            
            group.leave()
        })
        
        group.enter()
        HaloApiInterface.sharedInstance.getArenaJsonStatistics(completion: {(json) in
            
            //Get rank data through SwiftyJSON
            self.spartanRank = json["Results"][0]["Result"]["SpartanRank"].intValue
            self.xp = json["Results"][0]["Result"]["Xp"].intValue
            
            //Check if data exists in API before assigning
            if(json["Results"][0]["Result"]["ArenaStats"]["HighestCsrAttained"] != JSON.null) {
                self.designationId = json["Results"][0]["Result"]["ArenaStats"]["HighestCsrAttained"]["DesignationId"].intValue
            }
            
            //Once spartan rank is known, request information about the rank above
            HaloApiInterface.sharedInstance.getXpToNextRank(rank: self.spartanRank, completion: {(xpNeeded) in
                self.xpToNextRank = xpNeeded
                group.leave()
            })
        })

        group.notify(queue: .main) {
            //Return through escape function only once all the calls have been made
            completion()
        }
    }
    
    public func getHighestCsr(completion: @escaping (_ hasCsr: Bool) -> ()) {
        
        //Get metadata information of CSR rank based on ID from previous request
        if(designationId != nil)
        {
            HaloApiInterface.sharedInstance.fetchCsrDesignation(desingnationId: self.designationId, completion: {(csrName, csrImage) in
                
                self.highestCSR = CsrRank(rankName: csrName, rankImage: csrImage)
                
                //Return true in escaping function if the player has achieved a CSR rank
                completion(true)
            })
        }
        else
        {
            //Return false in escaping function if the player has not achieved a CSR rank
            completion(false)
        }
    }
}
