//
//  MoodWrapper.swift
//  Skroman
//
//  Created by ananadmahajan on 9/24/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class MoodWrapper: Codable {
	var mood_id : String?
	var mood_name : String?
  	var mood_time : String?
	var mood_repeat : String?
	var mood_status : Int? = 0
	var arraySwitches:  [SwitchBox]?
	var arraySelectedDaysForMoodRepeat : [Int] = []
}
