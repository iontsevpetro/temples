//
//  ViewController.swift
//  Temples
//
//  Created by Peter Iontsev on 2018/10/15.
//  Copyright © 2018 Peter Iontsev. All rights reserved.
//
import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    let locationManager = CLLocationManager()


//  var name: String = ""
    
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func updateButton(_ sender: CustomButton) {
        locationManager.requestLocation()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
}
extension ViewController: CLLocationManagerDelegate, MKMapViewDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: false)
            print(location)
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = "shrine"
            request.region = mapView.region
            let search = MKLocalSearch(request: request)
            search.start(completionHandler: {(response, error) in
                if error != nil {
                    print("Error occurred in search")
                } else if response!.mapItems.count == 0 {
                    print("No matches found")
                } else {
                    print("Matches found")
                    for item in response!.mapItems {
//                      self.name = item.name ?? "Shrine"
                        print("Name = \(item.name ?? "Shrine")")
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = item.placemark.coordinate
                        annotation.title = item.name
                        if let city = item.placemark.locality,
                            let street = item.placemark.thoroughfare,
                            let address = item.placemark.subThoroughfare {
                            annotation.subtitle = "\(city) \(street) \(address)"
                        }
                        self.mapView.addAnnotation(annotation)
                    }
                }
            })
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: (error)")
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else if annotation is MKUserLocation {
            let dot = mapView.view(for: annotation) as? MKMarkerAnnotationView
            return dot
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.markerTintColor = UIColor.white
            view.glyphText = "⛩"
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            view.rightCalloutAccessoryView?.isHidden = true
        }
    return view
  }
    
//to be implemented later. Why safari isn't opening with the constructed string, do search on this issue
//should pick up not the first name from massive, but the name of selected location
//    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        let str1 = "https://google.com/search?rls=en&q="
//        let str2 = "\(name)"
//        let str3 = "&ie=UTF-8&oe=UTF-8"
//        let str = str1 + str2 + str3
//        if control == view.rightCalloutAccessoryView {
//            if let url = NSURL(string: str){
//                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
//            }
//        }
//    }

}
