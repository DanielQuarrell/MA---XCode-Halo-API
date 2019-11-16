//
//  ViewController.swift
//  Xcode - HaloAPI
//
//  Created by Daniel Quarrell on 15/10/2019.
//  Copyright © 2019 Daniel Quarrell. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    @IBOutlet weak var gamertagField: UITextField!
    @IBOutlet weak var spartanImage: UIImageView!
    
    var gamertagString : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gamertagField.delegate = self;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func validateGamertag(gamertag: String){
        let url : String = "https://www.haloapi.com/profile/h5/profiles/" + gamertag + "/appearance"
        let headers : HTTPHeaders = [
            "Ocp-Apim-Subscription-Key" : "0bf9c5f6ddc64f7c8e34262bfd326b33"
        ]
        
        AF.request(url, headers: headers).responseJSON{ (response) in
            debugPrint(response)
            
            switch response.result{
            case .success(let value) :
                if(response.response?.statusCode != 404)
                {
                    print("Gamertag is valid")
                    
                    let json = JSON(value)
                    print(json["Gamertag"].stringValue)
                }
                else
                {
                    print("Please enter valid gamertag")
                    self.createValidationAlertBox()
                }
                
            case .failure(let error):
                print("Error : \(error)" )
                self.createValidationAlertBox()
            }
        }
    }
    
    func createValidationAlertBox(){
        let alert = UIAlertController(title: "Gamertag not found", message: "Please enter a valid Xbox Live Gamertag", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
        
        self.present(alert, animated: true)
        self.gamertagField.text = ""
    }

    @IBAction func checkStatsButtonPressed(_ sender: Any) {
        
        gamertagField.resignFirstResponder()
        let gamertag : String = gamertagField.text!
        
        HaloApiInterface.sharedInstance.validateGamertag(gamertag: gamertag){ (isValid) in
            if isValid
            {
                HaloApiInterface.sharedInstance.fetchSpartanImage(param: ["size" : 512, "crop" : "full"]){ (image) in
                    self.spartanImage.image = image
                }
                //Continue to next page
            }
            else
            {
                self.createValidationAlertBox()
            }
        }
        

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        gamertagField.resignFirstResponder()
    }
    
}

extension ViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
