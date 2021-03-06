//
//  View.swift
//  kkh-handbook
//
//  Created by Sean Lim on 10/6/18.
//  Copyright © 2018 sstinc. All rights reserved.
//

import Foundation
import UIKit
import Charts

class BMICalculatorView: GlobalController, UIPickerViewDelegate, UITextFieldDelegate {
	
	var model: BMIModel?
	
	var color: UIColor = .appBlue()
	
	@IBOutlet var wrapper: UIView!
	@IBOutlet var headerView: UIView!
	@IBOutlet var avatar: UIImageView!
	@IBOutlet var message: UILabel!
	@IBOutlet var bmiLabel: UILabel!
	
	@IBOutlet var genderPicker: UISegmentedControl!
	@IBOutlet var weight: UITextField!
	@IBOutlet var height: UITextField!
	@IBOutlet var agePicker: UIPickerView!
	
	@IBOutlet var chart: LineChartView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		model = BMIModel(bind: self)
		headerView.roundify(15)
		wrapper.roundify(10)
		headerView.drawGradientBackground(color1: .appPink(),
										  color2: .appPinkSecondary())
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		chart.noDataTextColor = .white
		chart.xAxis.drawLabelsEnabled = false
		chart.leftYAxisRenderer.axis?.axisLineColor = .white
		chart.leftYAxisRenderer.axis?.labelTextColor = .white
		chart.rightYAxisRenderer.axis?.drawLabelsEnabled = false
		chart.rightYAxisRenderer.axis?.drawAxisLineEnabled = false
		chart.gridBackgroundColor = .white
		chart.chartDescription?.text = "BMI percentile"
		chart.chartDescription?.textColor = .white
		model!.notifyFormChanged()
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		model!.notifyFormChanged()
	}
	
	@IBAction func genderChanged(_ sender: Any) {
		model!.notifyFormChanged()
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		model!.notifyFormChanged()
	}
	
	public func getForm() -> (Bool, Float, Int)? {
		let w = self.weight.text?.valueCheck()
		let h = self.height.text?.valueCheck()
		
		if w != nil && h != nil && self.weight.text != "" && self.height.text != "" {
			return (genderPicker.selectedSegmentIndex == 0, w!/(h! * h!), agePicker.selectedRow(inComponent: 0) + 1)
		} else {
			self.message.text = "Please enter valid patient details"
			bmiLabel.text = "BMI: -"
			return nil
		}
		
	}
	
	
	// Update view
	func update(message: String, BMI: Float) {
		self.message.text = message
		self.bmiLabel.text = "BMI: \(BMI)"
		self.chart.highlightValue(Highlight.init(x: 0, y: Double(BMI), dataSetIndex: 0))
	}
	
}

extension BMICalculatorView: UIPickerViewDataSource {
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		return 17
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		return String(row + 1)
	}
	
}
