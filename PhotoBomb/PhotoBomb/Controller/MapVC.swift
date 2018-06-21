//
//  MapVC.swift
//  PhotoBomb
//
//  Created by Sehajbir Randhawa on 6/21/18.
//  Copyright © 2018 Sehajbir. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {

    //Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func centerMapBtnPressed(_ sender: Any) {
    }
    
}

extension MapVC: MKMapViewDelegate{
    
}

