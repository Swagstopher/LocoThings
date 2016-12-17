//
//  AppDelegate.swift
//  LocoThings
//
//  Created by Tung Ly on 10/5/16.
//  Copyright © 2016 Tung Ly. All rights reserved.
//

import UIKit
import CoreData
import Auth0
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        FIRApp.configure()
        return true
    }
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        return Auth0.resumeAuth(url, options: options)
    }
    func applicationDidBecomeActive(application: UIApplication) {
    }
}

