//
//  FilterVC.swift
//  LocoThings
//
//  Created by Tung Ly on 11/27/16.
//  Copyright © 2016 Tung Ly. All rights reserved.
//

import UIKit
import ASValueTrackingSlider

class FilterVC: UIViewController, UITableViewDataSource, UITableViewDelegate, ASValueTrackingSliderDelegate, ASValueTrackingSliderDataSource {
    
    @IBOutlet weak var categoryTable: UITableView!
    @IBOutlet weak var radiusSlide: ASValueTrackingSlider!
    private var maxRadius: Float = 100.0
    private var stepRadius: Float = 5.0
    private var minRadius: Float = 5.0
    var radius: Float = 5.0
    var category = "Any"
    private var dummy = [
        "Any",
        "Music",
        "Comedy",
        "Learning",
        "Family Fun",
        "Film",
        "Food",
        "Holiday",
        "Sports",
        "Art"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSlider()
    }
    
    private func setSlider() {
        radiusSlide.maximumValue = maxRadius
        radiusSlide.minimumValue = minRadius
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "unwindBacktoMap"{
            let ml = segue.destinationViewController as? MapLanding
            ml?.category = category
            ml?.radius = radius
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cCell", forIndexPath: indexPath) as! CategoryCell
        cell.catLbl.text = dummy[indexPath.row]
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        category = dummy[indexPath.row]
        if let cell = categoryTable.cellForRowAtIndexPath(indexPath) {
            if cell.selected {
                cell.accessoryType = .Checkmark
            }
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        category = ""
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            cell.accessoryType = .None
        }
    }
    
    @IBAction func radiusSliderChanged(sender: ASValueTrackingSlider) {
        let roundedVal = round(sender.value/stepRadius)*stepRadius
        radiusSlide.value = roundedVal
        radius = roundedVal
    }
    
    @IBAction func closeBtnPressed(sender: UIButton) { self.dismissViewControllerAnimated(true, completion: {})}
    @IBAction func goBtnPressed(sender: UIButton) {}
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return dummy.count }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int { return 1 }
    func slider(slider: ASValueTrackingSlider!, stringForValue value: Float) -> String! { return ""}
    func sliderWillDisplayPopUpView(slider: ASValueTrackingSlider!) {}
}
