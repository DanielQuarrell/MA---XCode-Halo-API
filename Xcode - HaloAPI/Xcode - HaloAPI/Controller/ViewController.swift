//
//  ViewController.swift
//  Xcode - HaloAPI
//
//  Created by Daniel Quarrell on 15/10/2019.
//  Copyright © 2019 Daniel Quarrell. All rights reserved.
//

import UIKit
import Alamofire

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
    
    func fetchImageURL(url: String, param: [String:Any], imageView: UIImageView) {
        let headers : HTTPHeaders = [
            "Ocp-Apim-Subscription-Key" : "0bf9c5f6ddc64f7c8e34262bfd326b33"
        ]
        
        AF.request(url, parameters: param, headers: headers).responseData{ (response) in
            debugPrint(response)
            
            switch response.result{
            case .success :
                let img = UIImage.init(data: response.data!)
                imageView.image = img
                
            case .failure(let error):
                print("Error : \(error)" )
            }
        }
    }
    
    func validateGamertag(gamertag: String){
        let url : String = "//www.haloapi.com/profile/h5/profiles/" + gamertag + "/appearance"
        let headers : HTTPHeaders = [
            "Ocp-Apim-Subscription-Key" : "0bf9c5f6ddc64f7c8e34262bfd326b33"
        ]
        
        AF.request(url, headers: headers).responseJSON{ (response) in
            debugPrint(response)
            
            switch response.result{
            case .success :
                if(response.response?.statusCode != 404)
                {
                    print("Gamertag is valid")
                }
                else
                {
                    print("Please enter valid gamertag")
                    self.gamertagField.text = ""
                }
                
            case .failure(let error):
                print("Error : \(error)" )
                print("Please enter valid gamertag")
                self.gamertagField.text = ""
            }
        }
    }

    @IBAction func checkStatsButtonPressed(_ sender: Any) {
        
        gamertagField.resignFirstResponder()
        let gamertag : String = gamertagField.text!.replacingOccurrences(of: " ", with: "%20")
        
        //validateGamertag(gamertag : gamertag)
        
        fetchImageURL(url: "https://www.haloapi.com/profile/h5/profiles/" + gamertag + "/spartan", param: ["size" : 512, "crop" : "full"], imageView: self.spartanImage)
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
