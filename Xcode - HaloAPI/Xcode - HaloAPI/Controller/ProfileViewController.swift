//
//  ProfileViewController.swift
//  Xcode - HaloAPI
//
//  Created by Daniel Quarrell on 22/11/2019.
//  Copyright © 2019 Daniel Quarrell. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var gradientView: GradiantView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var spartanImage: UIImageView!
    
    @IBOutlet weak var gamertagLabel: UILabel!
    @IBOutlet weak var levelProgressView: UIProgressView!
    
    @IBOutlet weak var csrboi: UIImageView!
    
    var profileStatistics = ProfileStatistics()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        levelProgressView.transform = levelProgressView.transform.scaledBy(x: 1, y: 5)
        
        profileStatistics.getProfileData(completion: {
            
            self.gamertagLabel.text = String(self.profileStatistics.spartanRank)
            
            self.profileStatistics.getHighestCsr(completion: {
                self.csrboi.image = self.profileStatistics.highestCSR.rankImage
            })
        })
        
        gradientView.setgradientBackground(startColour: UIColor.black, endColour: UIColor.clear)
        
        HaloApiInterface.sharedInstance.fetchSpartanImage(param: ["size" : 512, "crop" : "full"]){ (image) in
            self.spartanImage.image = image
        }
        
        HaloApiInterface.sharedInstance.fetchEmblemImage(param: ["size" : 512]){ (image) in
            self.logoImage.image = image
        }
    }
}
