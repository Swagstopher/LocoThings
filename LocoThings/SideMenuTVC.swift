//
//  SideMenuTVC.swift
//  LocoThings
//
//  Created by Tung Ly on 11/12/16.
//  Copyright © 2016 Tung Ly. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class SideMenuTVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 1 {
            SessionManager().logout()
            NSUserDefaults.standardUserDefaults().removeObjectForKey("UID")
            NSUserDefaults.standardUserDefaults().synchronize()
            self.presentingViewController!.presentingViewController!.dismissViewControllerAnimated(true, completion: {})
        }
    }
}
