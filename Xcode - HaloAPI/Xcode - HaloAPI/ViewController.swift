//
//  ViewController.swift
//  Xcode - HaloAPI
//
//  Created by Daniel Quarrell on 15/10/2019.
//  Copyright © 2019 Daniel Quarrell. All rights reserved.
//

import UIKit

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
        if let urlToServer = URL.init(string: url) {
            let task = URLSession.shared.dataTask(with: urlToServer, completionHandler: { (data, response, error) in
                if error != nil || data == nil {
                    //Handle error
                }
                else {
                    if let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) {
                        //Determine what is returned from a JSON object
                        
                        //if object is an array of any
                        if jsonObject is [Any] {
                            print("Array: \(jsonObject)")
                        }
                            
                        //else if object is dictionary of any
                        else if jsonObject is [String:Any]{
                            print("Dictionary: \(jsonObject)")
                        }
                        
                    }
                }
            })
            task.resume()
        }
    }


}

