//
//  CustomerMapViewController.swift
//  Pharma+
//
//  Created by Thony on 12/15/18.
//  Copyright © 2018 Thony. All rights reserved.
//

import UIKit
 import MapKit
import CoreLocation

class CustomerMapViewController: UIViewController
{

    @IBOutlet var mapView: MKMapView!
    let regionInMeters:Double = 1000
    
    @IBOutlet var lbadrresee: UILabel!
    let locationManager = CLLocationManager()
    
    var previousLocation:CLLocation?
    var directionsArray: [MKDirections] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
    }
    
    
    func checkLocationServices()
    {
        if(CLLocationManager.locationServicesEnabled())
        {
            setUpLocationManager()
            checkLocationAuthorization()
        }
        else
        {
            //show alert letting user know they have to turn this on.
        }
    }
    
    func centerViewOnUserLocation()
    {
        if let location = locationManager.location?.coordinate{
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func setUpLocationManager()
    {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationAuthorization()
    {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            //do map stuf
            startTrackingUserLocation()
            print("we are authorished")
            break
        case .denied:
            //show aleert an instructing them how to turn permissions
            break
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
            
        case .restricted:
            break
        case .authorizedAlways:
            break
        default:
            break
        }
    }
    
    func startTrackingUserLocation()
    {
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapView)
    }
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation
    {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func createDirectionRequest(from coordinate: CLLocationCoordinate2D) ->MKDirections.Request
    {
    let destinationCoordinate = getCenterLocation(for: mapView).coordinate
    let startingLocation = MKPlacemark(coordinate: coordinate)
    let destination = MKPlacemark(coordinate: destinationCoordinate)
    let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)
        request.transportType = .automobile
        request.requestsAlternateRoutes = true
        
        return request
    }
    
    func getDirections()
    {
        guard let location = locationManager.location?.coordinate else{return}
     
        let request = createDirectionRequest(from: location)
        
        let directions = MKDirections(request: request)
        
        resetMapView(withView: directions)
        directions.calculate{
            [unowned self] (response,error) in
            //if error we handle it
            
            guard let response = response else {return}
            
            for route in response.routes
            {
           self.mapView.addOverlay(route.polyline)
           self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    func resetMapView(withView directions: MKDirections)
    {
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(directions)
        let number = directionsArray.map{$0.cancel()}
        
        for i in 0..<directionsArray.count
        {
            directionsArray.remove(at: i)
        }
        
        print("number\(number.count)")
    }
    
    @IBAction func goButtonTapped(_ sender: UIButton)
    {
        getDirections()
    }
  
}

extension CustomerMapViewController: CLLocationManagerDelegate
{
  
 
   /* func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        guard  let location = locations.last else{return}
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }*/
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        checkLocationAuthorization()
    }
    
    
}

extension CustomerMapViewController:MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool)
    {
      //  print("Ok We are in this function")
     let center = getCenterLocation(for: mapView)
     let geocoder = CLGeocoder()
        
        guard let previousLocation = self.previousLocation  else{ print("previouslocation is null"); return}
        
        guard center.distance(from: previousLocation) > 60 else{ print("distance is not greater than 60"); return}
        self.previousLocation = center
        
        geocoder.cancelGeocode()
        geocoder.reverseGeocodeLocation(center){
         [weak self] (placemarks, error) in
            
            guard let self = self else{return}
            
            if let _ = error
            {
       //show an alert to informe user
            }
            guard let placemark = placemarks?.first else{return}
            
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            let placeName = placemark.name ?? ""
            let areaname = placemark.administrativeArea ?? ""
            
            
            /*print("placemark\(placemark)")
            print("streetenumber\(streetNumber)")
            print("streetName\(streetName)")*/
        //    print("placename\(placeName)")
          //  print("areaname\(areaname)")
            DispatchQueue.main.async
                {
                 //   print("oklkndf,mnmvv")
        self.lbadrresee.text = "\(streetNumber) \(streetName)"
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer
    {
     let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .blue
        return renderer
    }
    
}
















