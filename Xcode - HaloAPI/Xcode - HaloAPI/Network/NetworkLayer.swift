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
    
    //Singleton instance
    static let sharedInstance = HaloApiInterface()
    
    //Player to reference for all API calls after validation
    var playerName : String = ""
    
    //API URL's
    let baseProfileURL : String = "https://www.haloapi.com/profile/h5/profiles/"
    let baseStatURL : String = "https://www.haloapi.com/stats/h5/"
    let baseMetadataURL : String = "https://www.haloapi.com/metadata/h5/metadata/"
    let serviceRecordURL : String = "servicerecords/"
    let arenaURL : String = "arena?players="
    let warzoneURL : String = "warzone?players="
    let csrDesignations : String = "csr-designations"
    let spartanRanks : String = "spartan-ranks"
    
    //Developer key to access the API
    let headers : HTTPHeaders = [
        "Ocp-Apim-Subscription-Key" : "0bf9c5f6ddc64f7c8e34262bfd326b33"
    ]
    
    public func validateGamertag(gamertag: String, completion: @escaping (_ isValid: Bool, _ errorString: String) -> ()){
        //Format the gametag to suit the URL
        let url : String = baseProfileURL + gamertag.replacingOccurrences(of: " ", with: "%20") + "/appearance"
        
        //Send get request with developer key
        AF.request(url, headers: headers).responseJSON{ (response) in
            //Print response
            debugPrint(response)
            
            switch response.result{
            //If successful, return server reponse based on the status code
            case .success(let value) :
                switch response.response?.statusCode {
                case 404:
                    completion(false, "Please enter valid gamertag")
                case 408:
                    completion(false, "Request timed out")
                case 500:
                    completion(false, "Internal service error")
                default:
                    //Get formated gamertage from result JSON
                    let json = JSON(value)
                    let playerNameFromJson = json["Gamertag"].stringValue
                    print("Gamertag is valid:" + playerNameFromJson)
                    
                    //Save valid gamertag to network layer
                    self.playerName = playerNameFromJson.replacingOccurrences(of: " ", with: "%20")
                    
                    //Advance to the stats
                    completion(true, "")
                }
                
            case .failure(let error):
                print("Error : \(error)" )
                //If the URL is invalid, the user typed in an invalid gamertag
                completion(false, "Please enter valid gamertag")
            }
        }
    }
    
    private func getJsonStatistics(statURL: String, completion: @escaping (_ Json: JSON) -> ()) {
        let url = statURL
        
        //Request JSON full of statistics for a gamemode
        AF.request(url, headers: headers).responseJSON{ (response) in
            
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
                    
                    //Return JSON into escaping function
                    completion(json)
                }
                
            case .failure(let error):
                print("Error : \(error)" )
                //Return empty JSON into escaping function
                completion(JSON())
            }
        }
    }
    
    public func getProfileJson(completion: @escaping (_ Json: JSON) -> ()) {
        getJsonStatistics(statURL: baseProfileURL + playerName + "/appearance") {(json) in
            completion(json)
        }
    }
    
    public func getArenaJsonStatistics(completion: @escaping (_ Json: JSON) -> ()) {
        getJsonStatistics(statURL: baseStatURL + serviceRecordURL + arenaURL + playerName) {(json) in
            completion(json)
        }
    }
    
    public func getWarzoneJsonStatistics(completion: @escaping (_ Json: JSON) -> ()) {
        getJsonStatistics(statURL: baseStatURL + serviceRecordURL + warzoneURL + playerName) {(json) in
            completion(json)
        }
    }
    
    private func fetchImage(imageURL: String, param: [String:Any], completion: @escaping (_ image: UIImage) -> ()) {
        
        let url = baseProfileURL + imageURL
        
        //Fetch image from the profile section of the API
        AF.request(url, parameters: param, headers: headers).responseData{ (response) in
            debugPrint(response)
            
            switch response.result{
            case .success :
                let img = UIImage.init(data: response.data!)
                
                //Return image in escaping function
                completion(img!)
                
            case .failure(let error):
                print("Error : \(error)" )
                //Return empty image in escaping function
                completion(UIImage())
            }
        }
    }
    
    private func fetchRawImage(imageURL: String, completion: @escaping (_ image: UIImage) -> ()) {
        
        //Fetch image from the metadata section of the API
        AF.request(imageURL).responseData{ (response) in
            switch response.result{
            case .success :
                let img = UIImage.init(data: response.data!)
                //Return image in escaping function
                completion(img!)
                
            case .failure(let error):
                print("Error : \(error)" )
                //Return empty image in escaping function
                completion(UIImage())
            }
        }
    }
    
    
    public func fetchSpartanImage(param: [String:Any], completion: @escaping (_ spartanImage: UIImage) -> ())
    {
        let imageURL : String = playerName + "/spartan"
        //Required URL format: www.haloapi.com/profile/h5/profiles/{player}/spartan[?size][&crop]
        
        //Request player emblem
        fetchImage(imageURL: imageURL, param: param) { (spartanImage) in
            //Return image in escaping function
            completion(spartanImage)
        }
    }
    
    public func fetchEmblemImage(param: [String:Any], completion: @escaping (_ emblemImage: UIImage) -> ())
    {
        let imageURL : String = playerName + "/emblem"
        //Required URL format: www.haloapi.com/profile/h5/profiles/{player}/spartan[?size][&crop]
        
        //Request player emblem
        fetchImage(imageURL: imageURL, param: param) { (emblemImage) in
            //Return image in escaping function
            completion(emblemImage)
        }
    }
    
    public func fetchCsrDesignation(desingnationId: Int, completion: @escaping (_ csrName: String, _ csrImage: UIImage) -> ())
    {
        getJsonStatistics(statURL: baseMetadataURL + csrDesignations) {(json) in
            
            let csrName = json[desingnationId]["name"].stringValue
            let imageURL = json[desingnationId]["tiers"][0]["iconImageUrl"].stringValue
            
            //Get CSR image from URL provided by the returning JSON
            self.fetchRawImage(imageURL: imageURL) { (csrImage) in
                
                //Return name and image into the escaping function
                completion(csrName, csrImage)
            }
        }
    }
    
    public func getXpToNextRank(rank: Int, completion: @escaping (_ xpNeeded: Int) -> ())
    {
        let url = baseMetadataURL + spartanRanks
        
        //Request metadata information about ranks
        getJsonStatistics(statURL: url) {(json) in
            
            let startXp = json[rank + 1]["startXp"].intValue
            
            //Return XP required to get to the next level in escaping function
            completion(startXp)
        }
    }
}
