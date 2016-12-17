//
//  WebVC.swift
//  LocoThings
//
//  Created by Tung Ly on 12/4/16.
//  Copyright © 2016 Tung Ly. All rights reserved.
//

import UIKit

class WebVC: UIViewController {
    
    var url: String = ""
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nsurl = NSURL(string: self.url)
        webView.userInteractionEnabled = true
        webView.scrollView.scrollEnabled = true
        webView.opaque = false
        webView.backgroundColor = UIColor.clearColor()
        webView.loadRequest(NSURLRequest(URL: nsurl!))
    }
}
