//
//  MapLanding.swift
//  LocoThings
//
//  Created by Tung Ly on 10/6/16.
//  Copyright © 2016 Tung Ly. All rights reserved.
//

import MapKit
import UIKit
import Auth0
import CoreLocation
import Alamofire
import SideMenu

class MapLanding: BaseVC, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager = CLLocationManager()
    var userLocation: CLLocation!
    var loginCredentials: Credentials!
    var events = [Event]()
    var clicked_events = [Event]()
    var coordinates: Coordinates?
    var latitude: Double = 0.0
    var longtitude: Double = 0.0
    var category: String = "Any"
    var radius: Float = 5.0
    var tappedCoord: CLLocationCoordinate2D?
    var cityZip: String? {
        didSet {
            self.title = cityZip
        }
    }
    
    private var defaultRadius: Float = 5.0
    override func viewWillAppear(animated: Bool) {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        self.title = "Hello"
        setUpSideMenu()
    }
    
    func loadEvents() {
        EventfulAPIClient().fetchEvents(1, dummy2: 2, location: coordinates!, category: category, radius: radius, completionHandler: { data in
                if data.count > 0 {
                    self.events += data
                    //print(self.events.count)
                    self.drawAnnotations()
                }
            }
        )
    }
    
    func drawAnnotations() {
        let distinct_geos = NSCountedSet()
        var count_geo_arr = [Int]()
        var geo_str_arr = [String]()
        
        // Get unique geolocation
        for e in self.events { distinct_geos.addObject("\(e.coordinate.latitude) \(e.coordinate.longitude)")}
        
        // Get occurences for a geolocation
        for s in distinct_geos {
            geo_str_arr.append(s as! String)
            count_geo_arr.append(distinct_geos.countForObject(s))
            //print("\(s) \(distinct_geos.countForObject(s))")
        }
        
        // draw pins
        for (index, c) in count_geo_arr.enumerate() {
            let str = geo_str_arr[index]
            let geos = str.characters.split{$0 == " "}.map(String.init)
            let coord = CLLocationCoordinate2D(latitude: geos[0].toDouble()!, longitude: geos[1].toDouble()!)
            let point = EventPin(title: "\(c) event(s) found", count: String(c), coordinate: coord)
            self.mapView.addAnnotation(point)
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if userLocation == nil {
            if let location = locations.first {
                userLocation = location
                self.locationManager.stopUpdatingLocation()
                let latestLocation = locations.last
                let la = String(format: "%.4f", latestLocation!.coordinate.latitude)
                let lo = String(format: "%.4f", latestLocation!.coordinate.longitude)
                CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error)->Void in
                    if (error != nil) { return }
                    if placemarks!.count > 0 {
                        let pm = placemarks![0]
                        self.displayLocationInfo(pm)
                    } else { }
                })
                self.latitude = Double(la)!
                self.longtitude = Double(lo)!
                
                NSUserDefaults.standardUserDefaults().removeObjectForKey("latitude")
                NSUserDefaults.standardUserDefaults().setDouble(latitude, forKey: "latitude")
                NSUserDefaults.standardUserDefaults().removeObjectForKey("longtitude")
                NSUserDefaults.standardUserDefaults().setDouble(longtitude, forKey: "longtitude")
                NSUserDefaults.standardUserDefaults().synchronize()
                
                self.coordinates = Coordinates(latitude: self.latitude, longitude: self.longtitude)
                loadEvents()
                let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
                mapView.setRegion(region, animated: true)

                /* Drop pin */
                let mee: MKPointAnnotation = MKPointAnnotation()
                mee.coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
                mee.title = "You are Here"
                mapView.addAnnotation(mee)
            }
        }
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? EventPin {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
            }
            view.pinTintColor = annotation.pinColor()
            return view
        }
        return nil
    }
    
    func displayLocationInfo(placemark: CLPlacemark?) {
        if let containsPlacemark = placemark {
            let city = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let zipCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            self.title = city! + ", " + zipCode!
        }
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView){
        let annotation = view.annotation
        let latitude = (annotation?.coordinate.latitude)!
        let longitude = (annotation?.coordinate.longitude)!
        clicked_events.removeAll(keepCapacity: false)

        for e in self.events {
            if ((e.coordinate.latitude == latitude) && (e.coordinate.longitude == longitude)) {
                clicked_events.append(e)
            }
        }
        self.performSegueWithIdentifier("EventsDetail", sender: self)
        mapView.deselectAnnotation(view.annotation, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EventsDetail"{
            let edvc = segue.destinationViewController as? EventsDetailVC
            edvc?.clicked_events = self.clicked_events
            edvc?.userLocation = self.userLocation
        }
    }
    
    private func setUpSideMenu() {
        let menuLeftNavigationController = UISideMenuNavigationController()
        menuLeftNavigationController.leftSide = true
        SideMenuManager.menuLeftNavigationController = menuLeftNavigationController
        let menuRightNavigationController = UISideMenuNavigationController()
        SideMenuManager.menuRightNavigationController = menuRightNavigationController
        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        SideMenuManager.menuFadeStatusBar = false
    }
    
    @IBAction func logOut(sender: UIButton) {
        SessionManager().logout()
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func menuPressed(sender: UIBarButtonItem) {}
    @IBAction func unwindBacktoMap(segue: UIStoryboardSegue) { loadEvents()}
}
