//
//  Event.swift
//  LocoThings
//
//  Created by Tung Ly on 11/15/16.
//  Copyright © 2016 Tung Ly. All rights reserved.
//

import Foundation
import Alamofire
import Fuzi
import MapKit
import UIKit


class Event: NSObject {
    var name: String
    var venue_name: String
    var startDateTime: NSDate
    var thumbnailImageURL: String?
    var thumbnailImage: UIImage?
    var venue_id: String
    var venue_address: String
    var city_name: String
    var region_name: String
    var postal_code: String
    var coordinate: CLLocationCoordinate2D
    var url: String
    var title: String?
    var subtitle: String?
    var id: String
    
    init(name: String,
         venue: String,
         startDateTime: NSDate,
         thumbnailImageURL: String?,
         venue_id: String,
         venue_address: String,
         city_name: String,
         coordinate: CLLocationCoordinate2D,
         url: String,
         region_name: String,
         postal_code: String,
         id: String
        ) {
        self.name = name
        self.venue_name = venue
        self.startDateTime = startDateTime
        self.thumbnailImageURL = thumbnailImageURL
        self.venue_id = venue_id
        self.city_name = city_name
        self.venue_address = venue_address
        self.coordinate = coordinate
        self.url = url
        self.region_name = region_name
        self.postal_code = postal_code
        self.id = id
    }
}

struct Coordinates {
    var latitude: Double
    var longitude: Double
}

class FIREvent: NSObject {
    var eid: String
    init(eid: String) {
        self.eid = eid
    }
}

class EventPin: NSObject, MKAnnotation {
    var title: String?
    let count: String
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, count: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.count = count
        self.coordinate = coordinate
        super.init()
    }
    func pinColor() -> UIColor  {
        switch count {
        case "1":
            return UIColor(red:0.00, green:0.70, blue:0.00, alpha:1.0)
        default:
            return UIColor(red:0.20, green:0.20, blue:1.00, alpha:1.0)
        }
    }
}

// models
