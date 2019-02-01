//
//  ViewController.swift
//  MapDemoTest
//
//  Created by Ashwinee on 02/01/19.
//  Copyright © 2018 Magneto It Solutions. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import Alamofire
import SwiftyJSON
import ARCarMovement

class ViewController: UIViewController,GMSMapViewDelegate,ARCarMovementDelegate {

    var mapView : GMSMapView?
    var locationManager = CLLocationManager()
    var didFindMyLocation = false
    var marker = GMSMarker()
    let marker2 = GMSMarker()
    var destinationCoordinate = CLLocationCoordinate2D(latitude: 18.591814, longitude: 73.739448)
    var CoordinateArr = [[String:String]]()
    var timeOut: Timer!
    var counter = 0
    var moveMent = ARCarMovement()
    var oldCoordinate = CLLocationCoordinate2D(latitude: 18.589953, longitude: 73.774003)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dic1 = ["lat": "18.592295",
                    "long" : "73.762869"]
        let dic3 = ["lat": "18.591814",
                    "long" : "73.739448"]
        
        CoordinateArr =  [dic1,dic3]
        moveMent.delegate = self
        
        mapView = GMSMapView()
        //Create a GMSCameraPosition that tells the map to display the
        let camera = GMSCameraPosition.camera(withLatitude: 18.590798, longitude: 73.752928, zoom: 13.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        //Setting the Mapview
        self.mapView?.delegate = self
        self.mapView?.isMyLocationEnabled = true
        self.mapView?.settings.myLocationButton = true
        self.mapView?.settings.compassButton = true
        self.mapView?.settings.zoomGestures = true
        self.mapView?.animate(to: camera)
        view = mapView
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        //Setting the start and end location
        let origin = "\(18.591814),\(73.739448)"
        let destination = "\(18.590187),\(73.774108)"
        
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=\("AIzaSyC3jN_gm4M9Hdo3alINUVaUSeX8MzQ8bWs")"
        
        //Calling the API and getting the Rsponces
        Alamofire.request(url).responseJSON { response in
            let json = try! JSON(data: response.data!)
            print("json : ",json)
            let routes = json["routes"].arrayValue
            print("routes : ",routes)
            
            for route in routes{
                let routeOverviewPolyline = route["overview_polyline"].dictionary
                let points = routeOverviewPolyline?["points"]?.stringValue
                let path = GMSPath.init(fromEncodedPath: points!)
                let polyline = GMSPolyline.init(path: path)
                polyline.strokeColor = UIColor.blue
                polyline.strokeWidth = 5
                polyline.map = self.mapView
            }
        }
        
        
        //Marker 0
        marker.position = CLLocationCoordinate2D(latitude: 18.589953, longitude: 73.774003)
        marker.title = "Kaspate Chowk"
        marker.snippet = "Pune"
        marker.map = mapView
        marker.icon = UIImage(named:"CarIcon")
        
        //Marker 1
        let marker1 = GMSMarker()
        marker1.position = CLLocationCoordinate2D(latitude: 18.592295, longitude: 73.762869)
        marker1.title = "Wakad"
        marker1.snippet = "Pune"
        marker1.map = mapView
        
        //Marker 2
        marker2.position = CLLocationCoordinate2D(latitude: 18.591814, longitude: 73.739448)
        marker2.title = "Hinjewadi chowk"
        marker2.snippet = "Pune"
        marker2.map = mapView
        
        self.timeOut = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(ViewController.timerTriggered), userInfo: nil, repeats: true)
    }
    
    @objc func timerTriggered() {
        
        if (self.counter < self.CoordinateArr.count)
        {
            
            let newCoordinate = CLLocationCoordinate2DMake((self.CoordinateArr[self.counter]["lat"]! as NSString).doubleValue, (self.CoordinateArr[self.counter]["long"]! as NSString).doubleValue)
            
            self.moveMent.ARCarMovement(marker: marker, oldCoordinate: self.oldCoordinate, newCoordinate: newCoordinate, mapView: mapView!, bearing: 0)
            
            self.oldCoordinate = newCoordinate
            self.counter += 1
        }
        else {
            self.timeOut.invalidate()
            self.timeOut = nil
        }
    }

    
    // UpdteLocationCoordinate
    func updateLocationoordinates(coordinates:CLLocationCoordinate2D) {
        if marker == nil{
            marker.position = coordinates
            let image = UIImage(named:"destinationmarker")
            marker.icon = image
            marker.map = mapView
            marker.appearAnimation = GMSMarkerAnimation.pop
        }
        else{
            CATransaction.begin()
            CATransaction.setAnimationDuration(5.0)
            marker.position =  coordinates
            CATransaction.commit()
        }
    }
    

    func ARCarMovementMoved(_ Marker: GMSMarker) {
        marker = Marker
        marker.map = self.mapView
        let camera = GMSCameraUpdate.setTarget(marker.position)
        self.mapView?.animate(with: camera)
        
    }
}

//MARK:- CLLocationManagerDelegate
extension ViewController : CLLocationManagerDelegate{
    private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.authorizedWhenInUse {
            mapView?.isMyLocationEnabled = true
        }
    }
}
