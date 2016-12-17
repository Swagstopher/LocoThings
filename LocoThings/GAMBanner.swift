//
//  GAMBanner.swift
//  LocoThings
//
//  Created by Tung Ly on 11/15/16.
//  Copyright © 2016 Tung Ly. All rights reserved.
//

import UIKit
import GoogleMobileAds

class GAMBanner: GADBannerView, GADBannerViewDelegate {
    var showAds: Bool = true
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: frame.size.height-50, width: frame.size.width, height: 50))
        self.delegate = self
    }
    
    internal func displayAd() {
        let request = GADRequest()
        self.adUnitID = "ca-app-pub-2326504635481877/2033098146"
        self.loadRequest(request)
    }
}
