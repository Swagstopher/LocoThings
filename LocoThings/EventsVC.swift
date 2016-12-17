//
//  EventsVC.swift
//  LocoThings
//
//  Created by Tung Ly on 11/15/16.
//  Copyright © 2016 Tung Ly. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FirebaseDatabase

class EventsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var faves = [Event]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        self.title = "⭐ Bookmarks"
        super.viewDidLoad()
        self.fetchData()
    }
    
    func fetchData() {
        if let uid = NSUserDefaults.standardUserDefaults().objectForKey("UID") {
            let ref = FIRDatabase.database().referenceWithPath("\(uid)")
            ref.queryOrderedByChild("\(uid)").observeEventType(.Value, withBlock: { (snapshot) in
                if let snapshotDict = snapshot.value as? NSDictionary {
                    var data = [Event]()
                    for item in (snapshot.value?.allKeys)! {
                        if let edict = snapshotDict.objectForKey(item) as? NSDictionary {
                            let formatter = NSDateFormatter()
                            formatter.dateFormat = "MM-dd-yyyy HH:mm"
                            
                            var name: String = ""
                            var venue_name: String = ""
                            var venue_id: String = ""
                            var venue_address: String = ""
                            var city_name: String = ""
                            var region_name: String = ""
                            var postal_code: String = ""
                            var url: String = ""
                            var lat: Double = 0.0
                            var long: Double = 0.0
                            var id: String = ""
                            var startDateTime = NSDate()
                            
                            if let n = edict.objectForKey("name")           as? String { name = n }
                            if let n = edict.objectForKey("venue_name")     as? String { venue_name = n }
                            if let n = edict.objectForKey("venue_id")       as? String { venue_id = n }
                            if let n = edict.objectForKey("venue_address")  as? String { venue_address = n }
                            if let n = edict.objectForKey("city_name")      as? String { city_name = n }

                            if let n = edict.objectForKey("region_name")    as? String { region_name = n }
                            if let n = edict.objectForKey("postal_code")    as? String { postal_code = n }
                            if let n = edict.objectForKey("url")            as? String { url = n }
                            if let n = edict.objectForKey("id")             as? String { id = n }
                            if let n = edict.objectForKey("latitude")       as? Double { lat = n }
                            if let n = edict.objectForKey("longitude")      as? Double { long = n }
                            let coord = CLLocationCoordinate2D(latitude: lat, longitude: long)
                            if let n = edict.objectForKey("longitude")      as? Double { long = n }
                            if let n = edict.objectForKey("startDateTime")  as? String { startDateTime = formatter.dateFromString(n)! }
                            
                            let e = Event(name: name, venue: venue_name, startDateTime: startDateTime, thumbnailImageURL: "", venue_id: venue_id, venue_address: venue_address, city_name: city_name, coordinate: coord, url: url, region_name: region_name, postal_code: postal_code, id: id)
                            data.append(e)
                            
                        }
                    }
                    self.faves = data
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                    })
                }
            })
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faves.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("feCell", forIndexPath: indexPath) as! EventDetailCell
        cell.nameLbl.text       = faves[indexPath.row].name
        cell.addressLbl.text    = faves[indexPath.row].venue_address
        cell.venueLocLbl.text   = faves[indexPath.row].venue_name
        cell.dateLbl.text       = faves[indexPath.row].startDateTime.dateStringWithFormat("MM-dd-yyyy HH:mm")
        
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
    
    func webClicked(sender: UIButton) {
        let r = sender.tag
        let wvc = self.storyboard?.instantiateViewControllerWithIdentifier("WebVC") as! WebVC
        wvc.url = self.faves[r].url
        self.navigationController?.pushViewController(wvc, animated: true)
    }
    
    func navClicked(sender: UIButton) {
        let r = sender.tag
        let coordinate = CLLocationCoordinate2DMake(0.0, 0.0)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        mapItem.name = "\(self.faves[r].venue_address) \(self.faves[r].postal_code)"
        mapItem.openInMapsWithLaunchOptions([MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
    
    func shareClicked(sender: UIButton) {
        let r = sender.tag
        let first = "Check out this event ! "
        let last = "\n\n- Sent from LocoThings with love"
        
        if let link = NSURL(string: self.faves[r].url) {
            let contents = [first, link, last]
            let activityVC = UIActivityViewController(activityItems: contents, applicationActivities: nil)
            
            activityVC.popoverPresentationController?.sourceView = sender
            self.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
}