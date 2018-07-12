//
//  Constants.swift
//  PhotoBomb
//
//  Created by Sehajbir Randhawa on 7/11/18.
//  Copyright © 2018 Sehajbir. All rights reserved.
//

import Foundation

let API_KEY  = "9061233f8b8f7fa78962b5d7461cf37d"

typealias CompletionHandler = (_ Success: Bool)->()


func flickURL(annotation: DroppablePin, apikey: String, numOfPhotos: Int) -> String{
    return "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(API_KEY)&lat=\(annotation.coordinate.latitude)&lon=\(annotation.coordinate.longitude)&radius=1&radius_units=mi&per_page=\(numOfPhotos)&format=json&nojsoncallback=1"
}
