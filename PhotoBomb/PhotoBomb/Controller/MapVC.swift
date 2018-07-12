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

class MapVC: UIViewController,UIGestureRecognizerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
   
    //Variables
    var locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    let regionRadius: Double = 1000
    var spinner: UIActivityIndicatorView?
    var propgressLabel: UILabel?
    var collectionView: UICollectionView?
    var flowLayout = UICollectionViewFlowLayout()

    //Outlets
    @IBOutlet weak var pullUpViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pullUpView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
       self.mapView.showsUserLocation = true
        configureLocationService()
       addDoubleTap()
        
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView?.register(PhotoCell.self, forCellWithReuseIdentifier: "PhotoCell")
        collectionView?.delegate = self
        collectionView?.dataSource  = self
        collectionView?.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        pullUpView.addSubview(collectionView!)
        
        
    }
    
    func addDoubleTap(){
        let doubleTap  = UITapGestureRecognizer(target: self, action: #selector(MapVC.dropPin(_:)))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.delegate = self
        mapView.addGestureRecognizer(doubleTap)
        
    }
    
    func addSwipe(){
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(MapVC.animateViewDown(_:)))
        swipe.direction = .down
        pullUpView.addGestureRecognizer(swipe)
    }
    
    @objc func animateViewDown(_ recog: UISwipeGestureRecognizer){
        pullUpViewHeightConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        DataService.instance.cancelSession()
    }
    
    func addSpinner(){
        spinner = UIActivityIndicatorView()
        spinner?.center = CGPoint(x: (UIScreen.main.bounds.width/2) - ((spinner?.frame.width)!/2), y: 150)
        spinner?.activityIndicatorViewStyle = .whiteLarge
        spinner?.color = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        spinner?.startAnimating()
        collectionView?.addSubview(spinner!)
        
    }
    
    func removeSpinner(){
        if(spinner != nil){
            spinner?.removeFromSuperview()
        }
    }
    
    func animateViewUp(){
        pullUpViewHeightConstraint.constant = 300
        UIView.animate(withDuration: 0.3) {
             self.view.layoutIfNeeded()
        }
       
    }
    
    func addProgressLabel(){
        propgressLabel = UILabel()
        propgressLabel?.frame = CGRect(x: (UIScreen.main.bounds.width/2) - ((200)/2), y: 175, width: 200, height: 40)
        propgressLabel?.font = UIFont(name: "Avenir Next", size: 18)
        propgressLabel?.textColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        propgressLabel?.textAlignment = .center
        propgressLabel?.text = "0/40 PHOTOS LOADED"
        collectionView?.addSubview(propgressLabel!)
    }
    
    func setProgessLabel(number: Int){
        propgressLabel?.text = "\(number)/40 PHOTOS LOADED"
    }
    
    func removeProgressLabel(){
        if propgressLabel != nil {
            propgressLabel?.removeFromSuperview()
        }
    }
    
    

    @IBAction func centerMapBtnPressed(_ sender: Any) {
        if(authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse){
            centerMapOnUserLocation()
        }
    }
    
    //CollectionView functions
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataService.instance.imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath)  as? PhotoCell else{ return UICollectionViewCell()}
        let imageView = UIImageView(image: DataService.instance.imageArray[indexPath.row])
        cell.addSubview(imageView)
        return cell
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
        removeSpinner()
        removeProgressLabel()
        DataService.instance.cancelSession()
        DataService.instance.imageArray = []
        DataService.instance.urlArray = []
        collectionView?.reloadData()
        
        animateViewUp()
        addSwipe()
        addSpinner()
        addProgressLabel()
        
        let touchPoint = recog.location(in: mapView)
        let touchCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        let annotation: DroppablePin = DroppablePin(coordinate: touchCoordinate, identifier: "droppablePin")
        mapView.addAnnotation(annotation)
     
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(touchCoordinate, regionRadius*2, regionRadius*2)
        mapView.setRegion(coordinateRegion, animated: true)
        
        
        DataService.instance.downloadURL(annotation: annotation) { (success) in
            if(success){
                DataService.instance.retrieveImages(completion: { (success) in
                    if(success){
                        self.removeSpinner()
                        self.removeProgressLabel()
                        self.collectionView?.reloadData()
                    }
                })
            }
        }
        
        
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

