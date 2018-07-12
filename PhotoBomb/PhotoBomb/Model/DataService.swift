//
//  DataService.swift
//  PhotoBomb
//
//  Created by Sehajbir Randhawa on 7/11/18.
//  Copyright © 2018 Sehajbir. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON


class DataService{
     static let instance = DataService()
    
    
    var urlArray: [String] = [String]()
    
    
    func downloadURL(annotation: DroppablePin,completion: @escaping CompletionHandler){
        
        urlArray = []
        
        Alamofire.request(flickURL(annotation: annotation, apikey: API_KEY, numOfPhotos: 40)).responseJSON { (response) in
            
            
            
            if(response.result.error == nil){
                
                
                guard let data = response.data else { return }
                
                do {
                    let json = try JSON(data: data)
                    
                    if let array = json["photos"]["photo"].array{
                        for item in array{
                            let url = "https://farm\(item["farm"].stringValue).staticflickr.com/\(item["server"].stringValue)/\(item["id"].stringValue)_\(item["secret"].stringValue)_h_d.jpg"
                            self.urlArray.append(url)
                            
                        }
                    }
                   
                    
                    
                }catch{
                    
                }
                
                completion(true)
            }
            else{
                completion(false)
            }
        }
    }
}
