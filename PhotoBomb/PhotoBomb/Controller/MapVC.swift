//
//  MapVC.swift
//  PhotoBomb
//
//  Created by Sehajbir Randhawa on 6/21/18.
//  Copyright © 2018 Sehajbir. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController,UIGestureRecognizerDelegate {
    
    //Variables
    var locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    let regionRadius: Double = 1000

    //Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
       self.mapView.showsUserLocation = true
        configureLocationService()
       addDoubleTap()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func addDoubleTap(){
        let doubleTap  = UITapGestureRecognizer(target: self, action: #selector(MapVC.dropPin(_:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delegate = self
        mapView.addGestureRecognizer(doubleTap)
        
    }
    

    @IBAction func centerMapBtnPressed(_ sender: Any) {
        if(authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse){
            centerMapOnUserLocation()
        }
    }
    
}

extension MapVC: MKMapViewDelegate{
    
    func centerMapOnUserLocation(){
        guard let coordinate = locationManager.location?.coordinate else { return }
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, regionRadius*2, regionRadius*2)
        mapView.setRegion(coordinateRegion, animated: true)
        
    }
    
    @objc func dropPin(_ recog: UITapGestureRecognizer){
        removePin()
        
        let touchPoint = recog.location(in: mapView)
        let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        let annotation: DroppablePin = DroppablePin(coordinate: touchCoordinate, identifier: "droppablePin")
        mapView.addAnnotation(annotation)
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(touchCoordinate, regionRadius*2, regionRadius*2)
        mapView.setRegion(coordinateRegion, animated: true)
        
        
    }
    
    func removePin(){
        for annotations in mapView.annotations{
            mapView.removeAnnotation(annotations)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        let pinAnnotation =  MKPinAnnotationView(annotation: annotation, reuseIdentifier: "droppablePin")
        pinAnnotation.pinTintColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        pinAnnotation.animatesDrop = true
        return  pinAnnotation
    }
    
}

extension MapVC: CLLocationManagerDelegate{
    
    func configureLocationService(){
        if(authorizationStatus == .notDetermined){
            locationManager.requestAlwaysAuthorization()
        }
        else{
            return
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        centerMapOnUserLocation()
    }
    
    
    
}

