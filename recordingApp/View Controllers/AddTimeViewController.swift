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
  
  @IBOutlet weak var classNameLabel: UITextField!
  @IBOutlet weak var dayLabel: UILabel!
  @IBOutlet weak var startTimeLabel: UILabel!
  @IBOutlet weak var endTimeLabel: UILabel!
  @IBOutlet weak var professorNameLabel: UITextField!
  @IBOutlet weak var placeLabel: UITextField!
  @IBOutlet weak var memoLabel: UITextField!
  
  @IBOutlet weak var mon: UIButton!
  @IBOutlet weak var tue: UIButton!
  @IBOutlet weak var wed: UIButton!
  @IBOutlet weak var thu: UIButton!
  @IBOutlet weak var fri: UIButton!
  @IBOutlet weak var sat: UIButton!
  @IBOutlet weak var sun: UIButton!
  
  lazy var daysArray: [UIButton] = [mon, tue, wed, thu, fri, sat, sun]
  var isDatePicker1Clicked:Bool = false
  var isDatePicker2Clicked:Bool = false
  
  override func viewDidLoad() {
    self.tableView.delegate = self
    self.tableView.dataSource = self
    datePickerForStartTime.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
    datePickerForEndTime.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
    self.view.endEditing(true)
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    var heightForRow:CGFloat = 43.67
    if (indexPath.row == 3 && isDatePicker1Clicked == false){
      heightForRow = 0.0
    }
    else if (indexPath.row == 3 && isDatePicker1Clicked == true){
      heightForRow = 163
      datePickerForStartTime.isHidden = false
    }
    else if (indexPath.row == 5 && isDatePicker2Clicked == false){
      heightForRow = 0.0
    }
    else if (indexPath.row == 5 && isDatePicker2Clicked == true){
      heightForRow = 163
      datePickerForEndTime.isHidden = false
    }
    return heightForRow
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if (indexPath.row == 2){
      if (isDatePicker1Clicked == true){
        isDatePicker1Clicked = false
      }
      else if (isDatePicker1Clicked == false){
        isDatePicker1Clicked = true
      }
    }
    else if (indexPath.row == 4){
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
  func returnDay() -> UIButton{
    var button2: UIButton = UIButton()
    daysArray.forEach { (button) in
      if button.isSelected{
        button2 = button
      }}
    return button2
  }
  
  // TODO: 월요일 버튼을 받으면 OrdinaryTime의 월요일 리턴해주기.
  func ButtonToLectureDay(button: UIButton) -> LectureTime.LectureDay{
    if button.titleLabel?.text == "월"{
      return .mon
    }
    else if button.titleLabel?.text == "화"{
      return .tue
    }
    else if button.titleLabel?.text == "수"{
      return .wed
    }
    else if button.titleLabel?.text == "목"{
      return .thu
    }
    else if  button.titleLabel?.text == "금"{
      return .fri
    }
    else { return .mon }
  }
  
  @IBAction func didTapDayButton(sender: UIButton){
    sender.backgroundColor = .black
    sender.setTitleColor(.white, for: .normal)
  }
  
  
  func dateToOrdinaryTime(_ date:Date) -> OrdinaryTime {
    let new = OrdinaryTime(hour: Calendar.current.component(.hour, from: date),
                           min: Calendar.current.component(.minute, from: date))
    return new
  }
  
  func didTapRegister(){
    let returnedDay = returnDay()
    let lectureTime = LectureTime(day: ButtonToLectureDay(button: returnedDay),
                                  startTime: dateToOrdinaryTime(datePickerForStartTime!.date),
                                  endTime: dateToOrdinaryTime(datePickerForEndTime!.date))
    let lecture = Lecture(name: classNameLabel.text!,
                          time: lectureTime,
                          professor:professorNameLabel.text,
                          room: placeLabel.text,
                          memo: memoLabel.text)
    StateStore.shared.classArray.append(lecture)
    StateStore.registerPushAlarm(lecture: lecture)
  }
}

extension Date {
  static let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm:ss Z"
    return formatter
  }()
  var formatted: String {
    return Date.formatter.string(from: self)
  }
}

