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
    let baseMetadataURL : String = "https://www.haloapi.com/metadata/h5/metadata/"
    let serviceRecordURL : String = "servicerecords/"
    let arenaURL : String = "arena?players="
    let warzoneURL : String = "warzone?players="
    let csrDesignations : String = "csr-designations"
    let spartanRanks : String = "spartan-ranks"
    
    let headers : HTTPHeaders = [
        "Ocp-Apim-Subscription-Key" : "0bf9c5f6ddc64f7c8e34262bfd326b33"
    ]
    
    public func validateGamertag(gamertag: String, completion: @escaping (_ isValid: Bool, _ errorString: String) -> ()){
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
    
    private func getJsonStatistics(statURL: String, completion: @escaping (_ Json: JSON) -> ()) {
        let url = statURL
        
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
                    
                    completion(json)
                }
                
            case .failure(let error):
                print("Error : \(error)" )
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
    
    private func fetchImage(imageURL: String, param: [String:Any], completion: @escaping (_ image: UIImage) -> ())
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
                completion(UIImage())
            }
        }
    }
    
    private func fetchRawImage(imageURL: String, completion: @escaping (_ image: UIImage) -> ()) {
        
        AF.request(imageURL).responseData{ (response) in
            switch response.result{
            case .success :
                let img = UIImage.init(data: response.data!)
                completion(img!)
                
            case .failure(let error):
                print("Error : \(error)" )
                completion(UIImage())
            }
        }
    }
    
    
    public func fetchSpartanImage(param: [String:Any], completion: @escaping (_ spartanImage: UIImage) -> ())
    {
        let imageURL : String = playerName + "/spartan"
        //www.haloapi.com/profile/h5/profiles/{player}/spartan[?size][&crop]
        
        fetchImage(imageURL: imageURL, param: param) { (spartanImage) in
            completion(spartanImage)
        }
    }
    
    public func fetchEmblemImage(param: [String:Any], completion: @escaping (_ emblemImage: UIImage) -> ())
    {
        let imageURL : String = playerName + "/emblem"
        //www.haloapi.com/profile/h5/profiles/{player}/spartan[?size][&crop]
        
        fetchImage(imageURL: imageURL, param: param) { (emblemImage) in
            completion(emblemImage)
        }
    }
    
    public func fetchCsrDesignation(desingnationId: Int, completion: @escaping (_ csrName: String, _ csrImage: UIImage) -> ())
    {
        getJsonStatistics(statURL: baseMetadataURL + csrDesignations) {(json) in
            
            let csrName = json[desingnationId]["name"].stringValue
            let imageURL = json[desingnationId]["tiers"][0]["iconImageUrl"].stringValue
            
            self.fetchRawImage(imageURL: imageURL) { (csrImage) in
                completion(csrName, csrImage)
            }
        }
    }
    
    public func getXpToNextRank(rank: Int, completion: @escaping (_ xpNeeded: Int) -> ())
    {
        let url = baseMetadataURL + spartanRanks
        
        getJsonStatistics(statURL: url) {(json) in
            
            let startXp = json[rank + 1]["startXp"].intValue
            completion(startXp)
        }
    }
}
