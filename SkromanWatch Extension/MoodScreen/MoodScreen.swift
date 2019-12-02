//
//  MoodScreen.swift
//  SkromanWatch Extension
//
//  Created by Skroman on 30/11/19.
//  Copyright © 2019 admin. All rights reserved.
//

import WatchKit
import Foundation


//
//  MoodScreen.swift
//  SkromanWatch Extension
//
//  Created by Skroman on 30/11/19.
//  Copyright © 2019 admin. All rights reserved.
//

import Foundation
import WatchKit

class MoodScreen: WKInterfaceController {

@IBOutlet weak var tableMoodList: WKInterfaceTable!
    
    var moodData = NSMutableArray()

    
       override func awake(withContext context: Any?) {
           super.awake(withContext: context)
           
        if let theData = context as? NSMutableArray {
            self.moodData = theData
        }

           setMoodTableProperties()
       }
    
    func setMoodTableProperties()  {
 
        self.tableMoodList.setNumberOfRows(moodData.count, withRowType: "MoodScreenCell")
        
        for x in 0 ..< moodData.count {
            
            let dict : NSDictionary = moodData.object(at: x) as! NSDictionary
            var row = MoodScreenCell()
            row = self.tableMoodList.rowController(at: x ) as! MoodScreenCell
            row.listGroup.setBackgroundColor(UIColor(red: 25/255, green: 27/255, blue: 42/255, alpha: 1.0))
            row.labelMood.setText((dict.value(forKey: mood_name) as! String))
        }
    }
    
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        
        let jsonToBeSent = NSMutableDictionary()
        
         /* for mood id and mood type  */
        
        let dict : NSDictionary = moodData.object(at: rowIndex) as! NSDictionary

        let mood_ID : String = dict.value(forKey: mood_id) as! String
        jsonToBeSent.setValue(mood_ID, forKey: mood_id)
        jsonToBeSent.setValue(3, forKey: mood_type)

        SKAPIManager.sharedInstance().sendHardwareMood(dictonary: jsonToBeSent)
        self.presentController(withName: "LoaderaView", context: nil)
    }
}
