//
//  BaseVC.swift
//  LocoThings
//
//  Created by Tung Ly on 11/27/16.
//  Copyright © 2016 Tung Ly. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
    private var bannerView: GAMBanner!

    override func viewDidLoad() {
        displayAdBanner()
    }
    
    func displayAdBanner() {
        bannerView = GAMBanner(frame: self.view.frame)
        bannerView.rootViewController = self
        bannerView.displayAd()
        self.view.addSubview(bannerView!)
    }
}
