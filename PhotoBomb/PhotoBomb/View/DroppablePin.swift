//
//  DroppablePin.swift
//  PhotoBomb
//
//  Created by Sehajbir Randhawa on 7/7/18.
//  Copyright © 2018 Sehajbir. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class DroppablePin: NSObject, MKAnnotation{
    
    init(coordinate: CLLocationCoordinate2D, identifier: String){
        
        self.coordinate = coordinate
        self.identifier = identifier
        super.init()
    }
    dynamic var coordinate: CLLocationCoordinate2D
    var identifier: String
    
    
    
}
