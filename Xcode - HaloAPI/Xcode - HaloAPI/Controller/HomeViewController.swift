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
    
    var gamertagString: String = ""
    
    var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gamertagField.delegate = self
        
        //Tint image
        haloImage.image = haloImage.image!.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        haloImage.tintColor = UIColor.lightGray
        
        //Create and position activity indicator in the center of the screen
        activityIndicatorView.center = self.view.center
        activityIndicatorView.hidesWhenStopped = true
        view.addSubview(activityIndicatorView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @IBAction func checkStatsButtonPressed(_ sender: Any) {
        //Remove keyoboard on button press
        gamertagField.resignFirstResponder()
        let gamertag : String = gamertagField.text!
        
        //Indicator to show that calls to the network are being made
        activityIndicatorView.startAnimating()
        //Stop User interaction
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        //Check if the inputed gamertag is valid
        HaloApiInterface.sharedInstance.validateGamertag(gamertag: gamertag){ (isValid, errorCode) in
            if isValid
            {
                self.changeStoryboard()
            }
            else
            {
                self.createValidationAlertBox(errorCode: errorCode)
            }
            
            //Stop indicator
            self.activityIndicatorView.stopAnimating()
            //Resume user interaction
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    func createValidationAlertBox(errorCode: String){
        let alert = UIAlertController(title: "Gamertag not found", message: errorCode, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: nil))
        
        //Create alert
        self.present(alert, animated: true)
        //Clear text box
        self.gamertagField.text = ""
    }
    
    func changeStoryboard() {
        //Swap to the stats storyboard and go to the profile page
        let storyboard = UIStoryboard(name: "Stats", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Stats Tab Controller") as UIViewController
        show(vc, sender: self)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Remove keyboard if the screen is tapped
        gamertagField.resignFirstResponder()
    }
    
}

extension HomeViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Remove keyboard if return is pressed
        textField.resignFirstResponder()
        return true
    }
}
