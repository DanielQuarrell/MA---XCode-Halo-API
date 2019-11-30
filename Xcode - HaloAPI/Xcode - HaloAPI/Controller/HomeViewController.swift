//
//  HomeViewController.swift
//  Xcode - HaloAPI
//
//  Created by Daniel Quarrell on 15/10/2019.
//  Copyright © 2019 Daniel Quarrell. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HomeViewController: UIViewController {

    @IBOutlet weak var gamertagField: UITextField!
    @IBOutlet weak var spartanImage: UIImageView!
    
    var gamertagString : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gamertagField.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        HaloApiInterface.sharedInstance.getArenaStatistics(completion: {() in })
    }
    
    func createValidationAlertBox(errorCode: String){
        let alert = UIAlertController(title: "Gamertag not found", message: errorCode, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
        
        self.present(alert, animated: true)
        self.gamertagField.text = ""
    }

    @IBAction func checkStatsButtonPressed(_ sender: Any) {
        
        gamertagField.resignFirstResponder()
        let gamertag : String = gamertagField.text!
        
        HaloApiInterface.sharedInstance.validateGamertag(gamertag: gamertag){ (isValid, errorCode) in
            if isValid
            {
                HaloApiInterface.sharedInstance.fetchSpartanImage(param: ["size" : 512, "crop" : "full"]){ (image) in
                    self.spartanImage.image = image
                }
                //Continue to next page
            }
            else
            {
                self.createValidationAlertBox(errorCode: errorCode)
            }
        }
        

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        gamertagField.resignFirstResponder()
    }
    
}

extension HomeViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
