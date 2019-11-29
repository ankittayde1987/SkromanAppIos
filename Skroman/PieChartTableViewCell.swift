//
//  PieChartTableViewCell.swift
//  Skroman
//
//  Created by ananadmahajan on 10/25/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import Charts

class PieChartTableViewCell: UITableViewCell,ChartViewDelegate {
	
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var vwSeprator: UIView!
	var arrSwitch = [Switch]()
    var arrDataUsage = [DataUsage]()
	@IBOutlet weak var chartView: PieChartView!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.backgroundColor =  UICOLOR_MAIN_BG
		vwSeprator.backgroundColor = UICOLOR_SEPRATOR
		
		chartView.usePercentValuesEnabled = false
		chartView.drawSlicesUnderHoleEnabled = false
		chartView.holeRadiusPercent = 0.0
		chartView.transparentCircleRadiusPercent = 0.0
		chartView.chartDescription?.enabled = false
		chartView.setExtraOffsets(left: 0, top: 0, right: 0, bottom: 0)
		chartView.drawEntryLabelsEnabled = false
		chartView.drawCenterTextEnabled = false
		chartView.centerAttributedText = nil;
		chartView.drawHoleEnabled = false
		chartView.rotationAngle = 0
		chartView.rotationEnabled = false
		chartView.highlightPerTapEnabled = false
    
		chartView.entryLabelColor = .red
		chartView.entryLabelFont = Font_SanFranciscoText_Regular_H12
        
        self.lblNoData.text = SSLocalizedString(key: "no_chart_data_found")
        self.lblNoData.font = Font_SanFranciscoText_Regular_H14
		self.lblNoData.textColor = UIColor.white
        self.lblNoData.isHidden = true
        self.chartView.isHidden = false
        
		let l = chartView.legend
		l.horizontalAlignment = .right
		l.verticalAlignment = .center
		l.orientation = .vertical
		l.drawInside = false
		l.xEntrySpace = 5
		l.yEntrySpace = 0
		l.yOffset = 0
		l.textColor = UICOLOR_WHITE
		l.font = Font_SanFranciscoText_Regular_H12!
        chartView.backgroundColor = UICOLOR_MAIN_BG
        if Utility.isIpad()
        {
           chartView.backgroundColor = UICOLOR_ROOM_CELL_BG
        }
        
		chartView.stopSpinAnimation()
//		chartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
    }
	func configureCellWithSwitchArray(arr : [Switch])
	{
		self.arrSwitch = arr
        
		self.setDataCount(arrSwitch.count, range: 100)
		chartView.usePercentValuesEnabled = false
		chartView.setNeedsDisplay()
		
	}
    
    func configureCellWithDataUsageArray(arr : [DataUsage])
    {
        self.arrDataUsage = arr
        var range = 0.0
        for obj in arrDataUsage
        {
//            SSLog(message: "Room name : \(obj.name!),  Wattage : \(obj.kw!)")
            range = range + Double(obj.kw!)!
        }
        
        if range > 0
        {
            self.chartView.isHidden = false
            self.lblNoData.isHidden = true
            self.setDataCount(arrDataUsage.count, range: 100)
            chartView.usePercentValuesEnabled = false
            chartView.setNeedsDisplay()
        }
        else
        {
            self.chartView.isHidden = true
            self.lblNoData.isHidden = false
        }
     
    }
	
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	func setDataCount(_ count: Int, range: UInt32) {
		let entries = (0..<count).map { (i) -> PieChartDataEntry in
			// IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
			
			let dataObj = arrDataUsage[i]
			let nameToShow = dataObj.name

            return PieChartDataEntry(value: Double(dataObj.kw!)!,
                                     label: nameToShow,
                                     icon: nil)
            
		}
		
		let set = PieChartDataSet(values: entries, label: "")
		set.drawIconsEnabled = false
		set.sliceSpace = 0
		set.drawValuesEnabled = false
		set.colors = ChartColorTemplates.skromanColor()
//        set.colors = ChartColorTemplates.vordiplom()
//            + ChartColorTemplates.joyful()
//            + ChartColorTemplates.colorful()
//            + ChartColorTemplates.liberty()
//            + ChartColorTemplates.pastel()
//            + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
		let data = PieChartData(dataSet: set)
		chartView.data = data
	}
}
