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

class HaloApiInterface {
    
    static let sharedInstance = HaloApiInterface()
    
    var playerName : String = "Danny%20Q%2077"
    
    let baseProfileURL : String = "https://www.haloapi.com/profile/h5/profiles/"
    let baseStatURL : String = "https://www.haloapi.com/stats/h5/"
    let serviceRecordURL : String = "servicerecords/"
    let arenaURL : String = "arena?players="
    let warzoneURL : String = "warzone?players="
    
    let headers : HTTPHeaders = [
        "Ocp-Apim-Subscription-Key" : "0bf9c5f6ddc64f7c8e34262bfd326b33"
    ]
    
    func validateGamertag(gamertag: String, completion: @escaping (_ isValid: Bool, _ errorString: String) -> ()){
        let url : String = baseProfileURL + gamertag.replacingOccurrences(of: " ", with: "%20") + "/appearance"
        
        AF.request(url, headers: headers).responseJSON{ (response) in
            debugPrint(response)
            
            switch response.result{
            case .success(let value) :
                switch response.response?.statusCode {
                case 404:
                    completion(false, "Please enter valid gamertag")
                case 408:
                    completion(false, "Request timed out")
                case 500:
                    completion(false, "Internal service error")
                default:
                    let json = JSON(value)
                    let playerNameFromJson = json["Gamertag"].stringValue
                    print("Gamertag is valid:" + playerNameFromJson)
                    
                    self.playerName = playerNameFromJson.replacingOccurrences(of: " ", with: "%20")
                    
                    completion(true, "")
                }
                
            case .failure(let error):
                print("Error : \(error)" )
                completion(false, "Please enter valid gamertag")
            }
        }
    }
    
    func getArenaStatistics(completion: @escaping () -> ()){
        let url = baseStatURL + serviceRecordURL + arenaURL + playerName
        
        AF.request(url, headers: headers).responseJSON{ (response) in
            //debugPrint(response)
            
            switch response.result{
            case .success(let value) :
                switch response.response?.statusCode {
                case 404:
                    print("Invalid Request")
                case 408:
                    print("Request Time out")
                case 500:
                    print("Server Error")
                default:
                    let json = JSON(value)
                    let jsonValue = json["ArenaStats"]["ArenaPlaylistStats"]["TotalKills"]
                    print(jsonValue)
                    
                    completion()
                }
                
            case .failure(let error):
                print("Error : \(error)" )
            }
        }
    }

    
    func fetchImage(imageURL: String, param: [String:Any], completion: @escaping (_ image: UIImage) -> ())
    {
        let url = baseProfileURL + imageURL
        
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
        let imageURL : String = playerName + "/spartan"
        //www.haloapi.com/profile/h5/profiles/{player}/spartan[?size][&crop]
        
        fetchImage(imageURL: imageURL, param: param) { (spartanImage) in
            completion(spartanImage)
        }
    }
    
    func fetchEmblemImage(param: [String:Any], completion: @escaping (_ emblemImage: UIImage) -> ())
    {
        let imageURL : String = playerName + "/emblem"
        //www.haloapi.com/profile/h5/profiles/{player}/spartan[?size][&crop]
        
        fetchImage(imageURL: imageURL, param: param) { (emblemImage) in
            completion(emblemImage)
        }
    }
}
