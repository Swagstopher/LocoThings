//
//  Extensions.swift
//  LocoThings
//
//  Created by Tung Ly on 11/29/16.
//  Copyright © 2016 Tung Ly. All rights reserved.
//

import Foundation
import Alamofire
import Fuzi
import MapKit
import UIKit

extension String {
    func toDouble() -> Double? {
        return NSNumberFormatter().numberFromString(self)?.doubleValue
    }
    func toInt() -> Int? {
        return NSNumberFormatter().numberFromString(self)?.integerValue
    }
    func toEventfulCategoryFormat() -> String {
        return self.stringByReplacingOccurrencesOfString(" ", withString: "_").lowercaseString
    }
}

extension Coordinates {
    func latlongFormat() -> String {
        return "\(self.latitude),\(self.longitude)"
    }
}

extension Double {
    func roundToDecimal(fractionDigits: Int) -> Double {
        let multiplier = pow(10.0, Double(fractionDigits))
        return round(self * multiplier) / multiplier
    }
}

extension Float {
    func toInt() -> Int? {
        if self > Float(Int.min) && self < Float(Int.max) {
            return Int(self)
        } else {
            return nil
        }
    }
}

extension UIColor {
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension NSDate {
    func dateStringWithFormat(format: String) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.stringFromDate(self)
    }
}

extension Event {
    class func fromXML(xml: XMLElement) -> Event {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let name                = xml.firstChild(tag: "title")!.stringValue
        let venue               = xml.firstChild(tag: "venue_name")!.stringValue
        let startDateTime       = formatter.dateFromString((xml.firstChild(tag: "start_time")?.stringValue)!)!
        let thumbnailImageURL   = xml.firstChild(tag: "image")?.firstChild(tag: "thumb")?.firstChild(tag: "url")?.stringValue
        let venue_id            = xml.firstChild(tag: "venue_id")!.stringValue
        let venue_address       = xml.firstChild(tag: "venue_address")!.stringValue
        let city_name           = xml.firstChild(tag: "city_name")!.stringValue
        let la                  = xml.firstChild(tag: "latitude")!.stringValue
        let lo                  = xml.firstChild(tag: "longitude")!.stringValue
        let coordinate          = CLLocationCoordinate2D(latitude: la.toDouble()!.roundToDecimal(7),
                                                         longitude: lo.toDouble()!.roundToDecimal(7))
        let url                 = xml.firstChild(tag: "url")!.stringValue
        let region_name         = xml.firstChild(tag: "region_name")!.stringValue
        let postal_code         = xml.firstChild(tag: "postal_code")!.stringValue
        let id                  = xml.attr("id")
        
        return Event(name: name,
                     venue: venue,
                     startDateTime: startDateTime,
                     thumbnailImageURL: thumbnailImageURL,
                     venue_id: venue_id,
                     venue_address: venue_address,
                     city_name: city_name,
                     coordinate: coordinate,
                     url: url,
                     region_name: region_name,
                     postal_code: postal_code,
                     id: id!
        )
    }
}