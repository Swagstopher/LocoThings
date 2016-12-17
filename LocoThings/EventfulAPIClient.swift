//
//  EventfulAPIClient.swift
//  LocoThings
//
//  Created by Tung Ly on 11/15/16.
//  Copyright © 2016 Tung Ly. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import Fuzi

class EventfulAPIClient {

    private let appKey = "6w3gG9cqF495NkDD"
    private let searchURL = "http://api.eventful.com/rest/events/search?"
    private let distanceUnits = "miles"
    
    func fetchEvents(dummy1: Int,
                     dummy2: Int,
                     location: Coordinates,
                     category: String,
                     radius: Float,
                     completionHandler: ([Event] -> Void)) {
        
        var events = [Event]()
        Alamofire.request(.GET, searchURL, parameters: [
            "app_key": appKey,
            "category": category.toEventfulCategoryFormat(),
            "units": distanceUnits,
            "where": location.latlongFormat(),
            "within": radius.toInt()!,
            "images_sizes": "thumb",
            "date": "future"
            ]).responseXMLDocument({ response in
                if response.result.isSuccess {
                    print(response.request?.URLString)
                    let xmlResponseDocument = response.result.value!
                    for element in (xmlResponseDocument.firstChild(xpath: "events")?.children)! {
                        //print(element)
                        events.append(Event.fromXML(element))
                    }
                    //for e in events { print("\(e.name) \(e.coordinate) \(e.startDateTime)") }
                }
                completionHandler(events)
            })
    }
}