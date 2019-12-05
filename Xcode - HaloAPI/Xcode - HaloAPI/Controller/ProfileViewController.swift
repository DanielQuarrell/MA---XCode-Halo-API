//
//  ProfileViewController.swift
//  Xcode - HaloAPI
//
//  Created by Daniel Quarrell on 22/11/2019.
//  Copyright © 2019 Daniel Quarrell. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var topView: GradiantView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var spartanImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topView.setgradientBackground(startColour: UIColor.black, endColour: UIColor.white)
        
        HaloApiInterface.sharedInstance.fetchSpartanImage(param: ["size" : 512, "crop" : "full"]){ (image) in
            self.spartanImage.image = image
        }
        
        HaloApiInterface.sharedInstance.fetchEmblemImage(param: ["size" : 512]){ (image) in
            self.logoImage.image = image
        }
    }
}
