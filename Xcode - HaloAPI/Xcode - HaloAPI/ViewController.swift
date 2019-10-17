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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchURL(url: "http://orangevalleycaa.org/api/videos.php")
    }
    
    func fetchURL(url : String) {
        AF.request(url).responseString{ (response) in
            print (response.value ?? "no value")
        }.responseJSON{ (response) in
            print (response.value ?? "no value")
        }
    }


}

