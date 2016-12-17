//
//  EventsDetailVC.swift
//  LocoThings
//
//  Created by Tung Ly on 12/3/16.
//  Copyright © 2016 Tung Ly. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseDatabase

class EventsDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var clicked_events = [Event]()
    var userLocation: CLLocation!
    private let liked = UIImage(named:"star")
    private let unlike = UIImage(named:"add")
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clicked_events.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("edCell", forIndexPath: indexPath) as! EventDetailCell
        cell.nameLbl.text       = clicked_events[indexPath.row].name
        cell.addressLbl.text    = clicked_events[indexPath.row].venue_address
        cell.venueLocLbl.text   = clicked_events[indexPath.row].venue_name
        cell.dateLbl.text       = clicked_events[indexPath.row].startDateTime.dateStringWithFormat("MM-dd-yyyy HH:mm")

        cell.favoriteBtn.tag    = indexPath.row
        cell.favoriteBtn.addTarget(self, action: #selector(EventsDetailVC.favClicked(_:)),
                                   forControlEvents: UIControlEvents.TouchUpInside)
        cell.webBtn.tag         = indexPath.row
        cell.webBtn.addTarget(self, action: #selector(EventsDetailVC.webClicked(_:)),
                              forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.shareBtn.tag       = indexPath.row
        cell.shareBtn.addTarget(self, action: #selector(EventsDetailVC.shareClicked(_:)),
                                forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.navBtn.tag         = indexPath.row
        cell.navBtn.addTarget(self, action: #selector(EventsDetailVC.navClicked(_:)),
                              forControlEvents: UIControlEvents.TouchUpInside)
        return cell
    }
    
    func favClicked(sender: UIButton) {
        let r = sender.tag
        let e = self.clicked_events[r]
        if (sender.selected) {
            sender.setImage(unlike, forState: UIControlState.Normal)
            sender.selected = false
            deleteBookmark(e)
        }
        else{
            sender.setImage(liked, forState: UIControlState.Normal)
            sender.selected = true
            self.saveBookmark(e)
        }
    }
    
    func deleteBookmark(e: Event) {
        if let uid = NSUserDefaults.standardUserDefaults().objectForKey("UID") {
            let rootRef = FIRDatabase.database().reference()
            _ = rootRef.child("\(uid)/\(e.id)").removeValue()
        }
    }
    
    func saveBookmark(e: Event) {
        if let uid = NSUserDefaults.standardUserDefaults().objectForKey("UID") {
            let rootRef = FIRDatabase.database().reference()
            let social_uid = rootRef.child("\(uid)")
            _ = social_uid.child("\(e.id)").setValue(e.id)
            rootRef.child("\(uid)/\(e.id)/name").setValue(e.name)
            rootRef.child("\(uid)/\(e.id)/venue_name").setValue(e.venue_name)
            rootRef.child("\(uid)/\(e.id)/startDateTime").setValue(e.startDateTime.dateStringWithFormat("MM-dd-yyyy HH:mm"))
            rootRef.child("\(uid)/\(e.id)/venue_id").setValue(e.venue_id)
            rootRef.child("\(uid)/\(e.id)/venue_address").setValue(e.venue_address)
            rootRef.child("\(uid)/\(e.id)/city_name").setValue(e.city_name)
            rootRef.child("\(uid)/\(e.id)/region_name").setValue(e.region_name)
            rootRef.child("\(uid)/\(e.id)/postal_code").setValue(e.postal_code)
            rootRef.child("\(uid)/\(e.id)/longitude").setValue(e.coordinate.longitude)
            rootRef.child("\(uid)/\(e.id)/latitude").setValue(e.coordinate.latitude)
            rootRef.child("\(uid)/\(e.id)/url").setValue(e.url)
            rootRef.child("\(uid)/\(e.id)/id").setValue(e.id)
        }
    }
    
    func webClicked(sender: UIButton) {
        let r = sender.tag
        let wvc = self.storyboard?.instantiateViewControllerWithIdentifier("WebVC") as! WebVC
        wvc.url = self.clicked_events[r].url
        self.navigationController?.pushViewController(wvc, animated: true)
    }
    func navClicked(sender: UIButton) {
        let r = sender.tag
        let coordinate = CLLocationCoordinate2DMake(self.userLocation.coordinate.latitude, self.userLocation.coordinate.longitude)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = "\(self.clicked_events[r].venue_address) \(self.clicked_events[r].postal_code)"
        mapItem.openInMapsWithLaunchOptions([MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
    func shareClicked(sender: UIButton) {
        let r = sender.tag
        let first = "Check out this event ! "
        let last = "\n\n- Sent from LocoThings with love"

        if let link = NSURL(string: self.clicked_events[r].url) {
            let contents = [first, link, last]
            let activityVC = UIActivityViewController(activityItems: contents, applicationActivities: nil)
            
            activityVC.popoverPresentationController?.sourceView = sender
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var myTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
