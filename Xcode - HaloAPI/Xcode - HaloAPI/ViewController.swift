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

    @IBOutlet weak var spartanImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchURL(url: "https://www.haloapi.com/profile/h5/profiles/Danny%20Q%2077/spartan", param: ["size" : 512, "crop" : "full"])
    }
    
    func fetchURL(url : String, param : [String:Any]) {
        let headers : HTTPHeaders = [
            "Ocp-Apim-Subscription-Key" : "0bf9c5f6ddc64f7c8e34262bfd326b33"
        ]
        
        AF.request(url, parameters: param, headers: headers).responseData{ (response) in
            debugPrint(response)
            let img = UIImage.init(data: response.data!)
            self.spartanImage.image = img
        }
    }


}

