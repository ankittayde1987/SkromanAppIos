//
//  LineChartViewTableViewCell.swift
//  Skroman
//
//  Created by ananadmahajan on 10/29/18.
//  Copyright © 2018 admin. All rights reserved.
//

import UIKit
import Charts

class LineChartViewTableViewCell: UITableViewCell {
  private let dateFormatter = DateFormatter()
    var objEnergyDataWrapper = EnergyDataWrapper()
	@IBOutlet weak var vwSeprator: UIView!
	@IBOutlet weak var chartView: LineChartView!
	override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		dateFormatter.dateFormat = "hh:mm"
		
		
		vwSeprator.backgroundColor = UICOLOR_SEPRATOR
		
		chartView.chartDescription?.enabled = false
		chartView.dragEnabled = true
		chartView.setScaleEnabled(true)
		chartView.pinchZoomEnabled = true
		chartView.xAxis.labelPosition = XAxis.LabelPosition.bottom
        
		
		// x-axis limit line
		let llXAxis = ChartLimitLine(limit: 10, label: "Index 10")
		llXAxis.lineWidth = 2
		llXAxis.labelPosition = .rightBottom
		llXAxis.valueFont = Font_SanFranciscoText_Regular_H10!
        
		
		
		let leftAxis = chartView.leftAxis
		leftAxis.removeAllLimitLines()
//        leftAxis.axisMinimum = 0
//        leftAxis.axisMaximum = 200
		leftAxis.drawLimitLinesBehindDataEnabled = false
		leftAxis.drawAxisLineEnabled = false
		leftAxis.drawGridLinesEnabled = false
		
		chartView.xAxis.labelTextColor = UIColor.white
		chartView.leftAxis.labelTextColor = UIColor.white
		
		
		chartView.rightAxis.enabled = false
		
		
		chartView.leftAxis.gridColor = NSUIColor.clear
		chartView.translatesAutoresizingMaskIntoConstraints = false
	
		
		chartView.legend.form = .line
		
		
		chartView.animate(xAxisDuration: 0.5)
		
        chartView.backgroundColor = UICOLOR_MAIN_BG
        if Utility.isIpad()
        {
            chartView.backgroundColor = UICOLOR_ROOM_CELL_BG
        }
		
		
    }
    func configureCellWithEnergyDataWrapperForWeeklyLineGraph(obj : EnergyDataWrapper)
    {
        self.objEnergyDataWrapper = obj
        SSLog(message: "Obj : \(self.objEnergyDataWrapper)")
        self.setDataCount((objEnergyDataWrapper.energy_data?.count)!, range: 100)
        
    }
	func setDataCount(_ count: Int, range: UInt32) {
		let values = (0..<count).map { (i) -> ChartDataEntry in
            let objEneData = self.objEnergyDataWrapper.energy_data![i]
                let val = Double(objEneData.weekly_total_usage ?? "0.0")
                return ChartDataEntry(x: Double(i + 1), y: val!, icon: nil)
		}
		
		let set1 = LineChartDataSet(values: values, label: SSLocalizedString(key: "data_usage_in_kw"))
		set1.drawIconsEnabled = false
		
		
//		set1.setColor(UIColor.init(red: 6/255, green: 78/255, blue: 214/255, alpha: 1))
		set1.setCircleColor(.white)
		set1.lineWidth = 2
		set1.circleRadius = 0
		set1.drawCircleHoleEnabled = false
		set1.valueFont = Font_SanFranciscoText_Regular_H09!
		set1.formLineWidth = 1
		set1.formSize = 15
		set1.drawCirclesEnabled = false
		set1.drawValuesEnabled = false
		
		
//        let gradientColors = [ChartColorTemplates.colorFromString("#06B2D600").cgColor,
//                              ChartColorTemplates.colorFromString("#ffff0000").cgColor]
//
//        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors as CFArray, locations: nil)!
		
//        set1.fillAlpha = 1
//        set1.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
//        set1.drawFilledEnabled = true
        
        
        
        let gradientColors = [UIColor.cyan.cgColor, UIColor.white.cgColor] as CFArray // Colors of the gradient
//        let colorLocations:[CGFloat] = [1.0, 0.1] // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: nil) // Gradient Object
        set1.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0) // Set the Gradient
        set1.drawFilledEnabled = true // Draw the Gradient
		
		let data = LineChartData(dataSet: set1)
		
//		chartView.xAxis.valueFormatter = DateValueFormatter()
		chartView.xAxis.granularity = 1.0
		chartView.data = data
		chartView.xAxis.drawLimitLinesBehindDataEnabled = true

	}
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	final class MonthNameFormater: NSObject, IAxisValueFormatter {
		func stringForValue( _ value: Double, axis _: AxisBase?) -> String {
			return Calendar.current.shortMonthSymbols[Int(value)]
		}
	}
	
}


public class DateValueFormatter: NSObject, IAxisValueFormatter {
	private let dateFormatter = DateFormatter()
	
	override init() {
		super.init()
		dateFormatter.dateFormat = "hh:mm"
	}
	
	public func stringForValue(_ value: Double, axis _: AxisBase?) -> String {
		return dateFormatter.string(from: Date(timeIntervalSinceReferenceDate: value))
	}
}
