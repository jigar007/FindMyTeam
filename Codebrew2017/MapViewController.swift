//
//  MapViewController.swift
//  Getit
//
//  Created by Federico Malesani on 20/03/2016.
//  Copyright © 2016 UniMelb. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import CoreData

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {


    var locationManager:CLLocationManager?
//    var locationsArray: [CLLocation] = [];
    
    var games = [Game]()

    
    var appIsTracking: Bool = false
    
//    var responseData = NSMutableData()
//    var activityIndicatorView:UIView?
//    var activityIndicator:UIActivityIndicatorView?
    
    @IBOutlet weak var map: MKMapView! {
        didSet {
            map.delegate = self
            map.mapType = .satellite
            map.showsCompass = true
            map.showsScale = true
        }
    }
    
    // MARK: - ViewLoading
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //CLLocation manager setup
        locationManager = CLLocationManager()
        locationManager!.delegate = self
        locationManager!.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        //locationManager!.distanceFilter = 5
        locationManager!.allowsBackgroundLocationUpdates = true
        locationManager!.requestAlwaysAuthorization()
        
        //MKMap setup
        map.showsUserLocation = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        locationManager!.startUpdatingLocation()
        
        if (map.annotations.count > 0) {
            map.showAnnotations(map.annotations, animated: true)
        } else {
            let spanX = 0.5
            let spanY = 0.5
            if ((locationManager!.location?.coordinate) != nil) {
                let newRegion = MKCoordinateRegionMake((locationManager!.location?.coordinate)!, MKCoordinateSpanMake(spanX, spanY))
                map.setRegion(newRegion, animated: true)
                map.showsUserLocation = true
            }
        }
        map.showsUserLocation = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (games.count != 0) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            for game in games {
                let annotation = MKPointAnnotation()
                annotation.coordinate.longitude = game.longitude!
                annotation.coordinate.latitude = game.latitude!
                annotation.title = game.sport
                
                let date = game.date
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd 'at' HH:mm"
                annotation.subtitle = formatter.string(from: date!)
                
                self.map.addAnnotation(annotation)
            }
            
        }
        map.showAnnotations(map.annotations, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        locationManager!.stopUpdatingLocation()
    }
    
    // MARK: - Map Delegate
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        map.showAnnotations(map.annotations, animated: true)
        
        for annotationView in views {
            let endFrame = annotationView.frame
            annotationView.frame = endFrame.offsetBy(dx: 0, dy: -self.view.layer.frame.size.height)
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                annotationView.frame = endFrame
                }, completion: nil)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyPin"
        
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        
        // Reuse the annotation if possible
        var annotationView:MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd 'at' HH:mm"
        let date = dateFormatter.date(from: annotation.subtitle!!)
        
        let leftIconView = CalendarThumbnailView(frame: CGRect(x: 0, y: 0, width: 53, height: 53))
        annotationView?.leftCalloutAccessoryView = leftIconView
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM"
        var monthStringForCalendar:String?
        let monthNumber = Int(formatter.string(from: date! as Date))
        
        if (monthNumber != nil) {
            switch monthNumber! {
            case 01:
                monthStringForCalendar = "JAN"
            case 02:
                monthStringForCalendar = "FEB"
            case 03:
                monthStringForCalendar = "MAR"
            case 04:
                monthStringForCalendar = "APR"
            case 05:
                monthStringForCalendar = "MAY"
            case 06:
                monthStringForCalendar = "JUN"
            case 07:
                monthStringForCalendar = "JUL"
            case 08:
                monthStringForCalendar = "AUG"
            case 09:
                monthStringForCalendar = "SEP"
            case 10:
                monthStringForCalendar = "OCT"
            case 11:
                monthStringForCalendar = "NOV"
            case 12:
                monthStringForCalendar = "DEC"
            default:
                monthStringForCalendar = "ERR"
            }
        } else {
            monthStringForCalendar = "NIL"
        }
        
        leftIconView.month = monthStringForCalendar! as NSString
        
        formatter.dateFormat = "dd"
        leftIconView.day = formatter.string(from: date! as Date) as NSString
        
//        leftIconView.layer.cornerRadius = leftIconView.layer.bounds.size.width/2
//        leftIconView.layer.borderColor = UIColor.black.cgColor
//        leftIconView.layer.borderWidth = 1
//        leftIconView.clipsToBounds = true
//        leftIconView.transform = CGAffineTransform(rotationAngle: CGFloat(-0.3))
        
        return annotationView
    }
    
//    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
//        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
//        if overlay is MKPolyline {
//            polylineRenderer.strokeColor = UIColor.blueColor()
//            polylineRenderer.lineWidth = 15
//        }
//        
//        return polylineRenderer
//    }
    
    
    // MARK: - Location manager
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //TODO: Location manager error handling
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let spanX = 0.5
//        let spanY = 0.5
//        let newRegion = MKCoordinateRegionMake(locations.first!.coordinate, MKCoordinateSpanMake(spanX, spanY))
//                        map.setRegion(newRegion, animated: true)
        
        //TODO: Filter for location accuracy
//        if appIsTracking {
//            
//            locationsArray.append(locations.first!)
//            
//            let spanX = 0.01
//            let spanY = 0.01
//            let newRegion = MKCoordinateRegionMake(locations.first!.coordinate, MKCoordinateSpanMake(spanX, spanY))
//            map.setRegion(newRegion, animated: true)
//            
//            if (locationsArray.count>1) {
//                let sourceIndex = locationsArray.count - 2
//                let destinationIndex = locationsArray.count - 1
//                let firsCoordinate = locationsArray[sourceIndex].coordinate
//                let secondCoordinate = locationsArray[destinationIndex].coordinate
//                var coordinateArray = [firsCoordinate, secondCoordinate]
//                let tripPolyline = MKPolyline(coordinates: &coordinateArray,count: coordinateArray.count)
//                map.addOverlay(tripPolyline)
//            }
//        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //TODO: handle possible changes
        switch status {
        case CLAuthorizationStatus.authorizedAlways:
            print("CLAuthorizationStatus.AuthorizedAlways");
        case CLAuthorizationStatus.authorizedWhenInUse:
            print("CLAuthorizationStatus.AuthorizedWhenIsUse");
        case CLAuthorizationStatus.denied:
            print("CLAuthorizationStatus.Denied");
        case CLAuthorizationStatus.restricted:
            print("CLAuthorizationStatus.Restricted");
        case CLAuthorizationStatus.notDetermined:
            print("CLAuthorizationStatus.NotDetermined");
        }
    }

    
    // MARK: - Navigation
    
    @IBAction func backToList(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

    
}

