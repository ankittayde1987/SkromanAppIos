//
//  SkromanDateFormatter.swift
//  Skroman
//
//  Created by ananadmahajan on 9/21/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit

class SkromanDateFormatter: NSObject {
	var dateFormatter = DateFormatter()
	class var sharedInstance : SkromanDateFormatter {
		struct Static {
			static let instance : SkromanDateFormatter = SkromanDateFormatter()
		}
		return Static.instance
	}
	
	func getStartTimeToShow(dateToConvert : String) -> String{
		dateFormatter.dateFormat = kTimeFormatFor24Hours
 //		dateFormatter.locale = Locale.current
		
		//now current date time
		let dt = dateFormatter.date(from: dateToConvert)
		
		
		dateFormatter.timeZone = TimeZone.current;
		dateFormatter.locale = Locale.current
		
		dateFormatter.dateFormat = kTimeFormatFor12Hours
		
		let strDate = dateFormatter.string(from: dt!)
		return strDate
	}
}
