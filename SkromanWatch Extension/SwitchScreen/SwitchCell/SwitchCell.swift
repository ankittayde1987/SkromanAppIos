//
//  SwitchCell.swift
//  SkromanWatch Extension
//
//  Created by Skroman on 13/09/19.
//  Copyright © 2019 admin. All rights reserved.
//

import WatchKit

class SwitchCell: NSObject {

    @IBOutlet weak var groupSwitchNumber: WKInterfaceGroup!
    @IBOutlet weak var groupCell: WKInterfaceGroup!
    @IBOutlet weak var labelSwitchNumber: WKInterfaceLabel!
    @IBOutlet weak var labelSwitchName: WKInterfaceLabel!
    @IBOutlet weak var imageSwitch: WKInterfaceImage!
    @IBOutlet weak var sliderBrightness: WKInterfaceSlider!

    weak var delegate: sliderCellDelegate?

    var tagg : NSInteger?


    @IBAction func sliderValueChanged(value: Float) {
        
        var sliderValue = value
        
        if sliderValue > 4.8 {
            sliderValue = 5.0
        }
        
        self.delegate?.setUpdatedSliderValue(value: sliderValue, tag: self.tagg!)
    }


}
