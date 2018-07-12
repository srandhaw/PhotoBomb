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
    
    let x = MapVC()
    var urlArray: [String] = [String]()
    var imageArray: [UIImage] = [UIImage]()
    
    
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
    
    func retrieveImages(completion: @escaping CompletionHandler){
        imageArray = []
       
        
        
        for url in urlArray{
            Alamofire.request(url).responseImage { (response) in
                guard let image = response.result.value else {return}
                self.imageArray.append(image)
                self.x.setProgessLabel(number: self.imageArray.count)
                
                if(self.urlArray.count == self.imageArray.count){
                    completion(true)
                }
                
            }
        }
        
        
       
        
    }
    
    func cancelSession(){
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadTask, downloadTask) in
            
            for task in sessionDataTask{
                task.cancel()
            }
            
            for task in downloadTask{
                task.cancel()
            }
        }
    }
}
