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
    @IBOutlet weak var haloImage: UIImageView!
    
    var gamertagString : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gamertagField.delegate = self
        
        haloImage.image = haloImage.image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        haloImage.tintColor = UIColor(named: "LightBlue")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
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
                self.changeStoryboard()
            }
            else
            {
                self.createValidationAlertBox(errorCode: errorCode)
            }
        }
    }
    
    func changeStoryboard() {
        let storyboard = UIStoryboard(name: "Stats", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Stats Tab Controller") as UIViewController
        show(vc, sender: self)
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
