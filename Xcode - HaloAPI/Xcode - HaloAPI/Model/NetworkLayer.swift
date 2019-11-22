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
    static let sharedInstance = HaloApiInterface()
    
    var playerName : String = "Danny%20Q%2077"
    
    let baseURL : String = "https://www.haloapi.com/profile/h5/"
    let profileURL : String = "profiles/"
    let serviceRecordURL : String = "servicerecords/"
    let arenaURL : String = "arena?players="
    let warzoneURL : String = "warzone?players="
    
    let headers : HTTPHeaders = [
        "Ocp-Apim-Subscription-Key" : "0bf9c5f6ddc64f7c8e34262bfd326b33"
    ]
    
    func validateGamertag(gamertag: String, completion: @escaping (_ isValid: Bool) -> ()){
        let url : String = baseURL + "profiles/" + gamertag.replacingOccurrences(of: " ", with: "%20") + "/appearance"
        
        AF.request(url, headers: headers).responseJSON{ (response) in
            debugPrint(response)
            
            switch response.result{
            case .success(let value) :
                if(response.response?.statusCode != 404)
                {
                    let json = JSON(value)
                    let playerNameFromJson = json["Gamertag"].stringValue
                    print("Gamertag is valid:" + playerNameFromJson)
                    
                    self.playerName = playerNameFromJson.replacingOccurrences(of: " ", with: "%20")
                    
                    completion(true)
                }
                else
                {
                    print("Please enter valid gamertag")
                    completion(false)
                }
                
            case .failure(let error):
                print("Error : \(error)" )
                completion(false)
            }
        }
    }
    
    func fetchImage(imageURL: String, param: [String:Any], completion: @escaping (_ image: UIImage) -> ())
    {
        let url = baseURL + imageURL
        
        AF.request(url, parameters: param, headers: headers).responseData{ (response) in
            debugPrint(response)
            
            switch response.result{
            case .success :
                let img = UIImage.init(data: response.data!)
                completion(img!)
                
            case .failure(let error):
                print("Error : \(error)" )
            }
        }
    }
    
    func fetchSpartanImage(param: [String:Any], completion: @escaping (_ spartanImage: UIImage) -> ())
    {
        let imageURL : String = profileURL + playerName + "/spartan"
        //www.haloapi.com/profile/h5/profiles/{player}/spartan[?size][&crop]
        
        fetchImage(imageURL: imageURL, param: param) { (spartanImage) in
            completion(spartanImage)
        }
    }
    
    func fetchEmblemImage(param: [String:Any], completion: @escaping (_ emblemImage: UIImage) -> ())
    {
        let imageURL : String = profileURL + playerName + "/emblem"
        //www.haloapi.com/profile/h5/profiles/{player}/spartan[?size][&crop]
        
        fetchImage(imageURL: imageURL, param: param) { (emblemImage) in
            completion(emblemImage)
        }
    }
}
