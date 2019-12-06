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
    @IBOutlet weak var serviceTagLabel: UILabel!
    @IBOutlet weak var spartanRankValue: UILabel!
    @IBOutlet weak var csrRankLabel: UILabel!
    @IBOutlet weak var xpLabel: UILabel!
    
    @IBOutlet weak var levelProgressView: UIProgressView!
    
    @IBOutlet weak var csrImageView: UIImageView!
    
    var profileStatistics: ProfileStatistics = ProfileStatistics()
    var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        levelProgressView.transform = levelProgressView.transform.scaledBy(x: 1, y: 5)
        
        activityIndicatorView.center = self.view.center
        activityIndicatorView.hidesWhenStopped = true
        view.addSubview(activityIndicatorView)
        
        activityIndicatorView.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        profileStatistics.getProfileData(completion: {
            
            self.gamertagLabel.text = String(self.profileStatistics.gamertag)
            self.serviceTagLabel.text = String(self.profileStatistics.serviceTag)
            self.spartanRankValue.text = String(self.profileStatistics.spartanRank)
            
            self.levelProgressView.progress = Float(self.profileStatistics.xp) / Float(self.profileStatistics.xpToNextRank)
            self.xpLabel.text = String(self.profileStatistics.xp) + "/" + String(self.profileStatistics.xpToNextRank) + "XP"
            
            self.profileStatistics.getHighestCsr(completion: { hasCsr in
                if(hasCsr) {
                    self.csrRankLabel.text = self.profileStatistics.highestCSR.rankName
                    self.csrImageView.image = self.profileStatistics.highestCSR.rankImage
                }
                else
                {
                    self.csrRankLabel.text = "Invalid"
                }
                
                self.activityIndicatorView.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
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
