//
//  NetworkLayer.swift
//  Xcode - HaloAPI
//
//  Created by Daniel Quarrell on 12/11/2019.
//  Copyright © 2019 Daniel Quarrell. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class HaloApiInterface
{
    var playerName : String = ""
    
    let baseURL : String = "https://www.haloapi.com/profile/h5/"
    
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
}
