//
//  AddTimeViewController.swift
//  recordingApp
//
//  Created by 조예진 on 05/05/2019.
//  Copyright © 2019 조예진. All rights reserved.
//

import UIKit

class AddTimeViewController: UITableViewController {
  
  @IBOutlet var myTableView: UITableView!
  @IBOutlet weak var datePickerForStartTime: UIDatePicker!
  @IBOutlet weak var datePickerForEndTime: UIDatePicker!
  @IBOutlet weak var cell_startTime: UITableViewCell!
  @IBOutlet weak var cell_endTime: UITableViewCell!
  @IBOutlet weak var dayLabel: UILabel!
  @IBOutlet weak var startTimeLabel: UILabel!
  @IBOutlet weak var endTimeLabel: UILabel!
  
  var isDatePicker1Clicked:Bool = false
  var isDatePicker2Clicked:Bool = false
  
  override func viewDidLoad() {
    print("print is working...")
    self.tableView.delegate = self
    self.tableView.dataSource = self
    datePickerForStartTime.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
    datePickerForEndTime.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    var heightForRow:CGFloat = 43.67
    if (indexPath.row == 2 && isDatePicker1Clicked == false){
      heightForRow = 0.0
    }
    else if (indexPath.row == 2 && isDatePicker1Clicked == true){
      heightForRow = 163
      datePickerForStartTime.isHidden = false
    }
    else if (indexPath.row == 4 && isDatePicker2Clicked == false){
      heightForRow = 0.0
    }
    else if (indexPath.row == 4 && isDatePicker2Clicked == true){
      heightForRow = 163
      datePickerForEndTime.isHidden = false
    }
    return heightForRow
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if (indexPath.row == 1){
      print("cell 1 selected")
      if (isDatePicker1Clicked == true){
        isDatePicker1Clicked = false
      }
      else if (isDatePicker1Clicked == false){
        isDatePicker1Clicked = true
      }
    }
    else if (indexPath.row == 3){
      print("cell 2 selected")
      if (isDatePicker2Clicked == true){
        isDatePicker2Clicked = false
      }
      else if (isDatePicker2Clicked == false){
        isDatePicker2Clicked = true
      }
    }
    tableView.beginUpdates()
    tableView.endUpdates()
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  
  @objc func handleDatePicker(_ datePicker: UIDatePicker){
    if (datePicker == datePickerForStartTime){
      startTimeLabel.text  = (datePicker.date.formatted)
    }
    else {
      endTimeLabel.text  = (datePicker.date.formatted)
    }
  }
  
  
}
extension Date {
  static let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE, dd MMM yyyy HH:mm:ss Z"
    return formatter
  }()
  var formatted: String {
    return Date.formatter.string(from: self)
  }
}

