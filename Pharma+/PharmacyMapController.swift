//
//  PharmacyMapController.swift
//  Pharma+
//
//  Created by Thony on 12/21/18.
//  Copyright © 2018 Thony. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PharmacyMapController: BaseViewController {

    @IBOutlet var lbadrresee: UILabel!
    
    @IBOutlet var mapView: MKMapView!
    
    let regionInMeters:Double = 1000
    let locationManager = CLLocationManager()
    
    var previousLocation:CLLocation?
    var directionsArray: [MKDirections] = []
    
   var PharmacyArray:[NSManagedObject] = []
    
    
    func fetchPharmacyData()
    {
        guard let mydelegate = UIApplication.shared.delegate as? AppDelegate else
        {
            return
        }
        
        
        let managedContext = mydelegate.persistentContainer.viewContext
        
        let fetchrequest = NSFetchRequest<NSManagedObject>(entityName: "SessionPharmacy")
        
        do
        {
            PharmacyArray = try managedContext.fetch(fetchrequest)
        }
        catch let error as NSError
        {
            print("Error: \(error.userInfo)")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSlideMenuButton()
        fetchPharmacyData()
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
            let alert = UIAlertController(title: "Turn ON", message: "You must turn om your location", preferredStyle: .alert)
            
            let action  = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alert.addAction(action)
            
            self.present(alert,animated: true)
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
            //
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
   
    
    func createDirectionRequest(from coordinate: CLLocationCoordinate2D) ->MKDirections.Request
    {
        let destinationCoordinate = getCenterLocation(for: mapView).coordinate
    
        let mypharmacy = PharmacyArray[0]
        
         let pharmalatitude = mypharmacy.value(forKey: "latitude")  as! Double 
        let pharmalongitude = mypharmacy.value(forKey: "longitude") as! Double
        let pharmacoordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: pharmalatitude, longitude: pharmalongitude)
        
        let startingLocation = MKPlacemark(coordinate: coordinate)
        let destination = MKPlacemark(coordinate: pharmacoordinate)
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

extension PharmacyMapController: CLLocationManagerDelegate
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

extension PharmacyMapController:MKMapViewDelegate
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
