//
//  EventDetailCell.swift
//  LocoThings
//
//  Created by Tung Ly on 12/3/16.
//  Copyright © 2016 Tung Ly. All rights reserved.
//

import UIKit

class EventDetailCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var venueLocLbl: UILabel!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var webBtn: UIButton!
    @IBOutlet weak var navBtn: UIButton!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func navigationBtnPressed(sender: UIButton) {}
    @IBAction func shareBtnPressed(sender: UIButton) {}
    @IBAction func webBtnPressed(sender: UIButton) {}
}
