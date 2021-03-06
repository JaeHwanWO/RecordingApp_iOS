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
  
  // 수정을 위해서, lecture 받아오기
  var modifyingLecture: Lecture?
  
  override func viewDidLoad() {
    self.tableView.delegate = self
    self.tableView.dataSource = self
    datePickerForStartTime.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
    datePickerForEndTime.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
    
    if let modifyingLecture = modifyingLecture{
      // fill out
      classNameLabel.text = modifyingLecture.name
      //TODO: 요일 바꾸는 기능...? weekDayToButton(a: modifyingLecture.time.weekDay)
      startTimeLabel.text = modifyingLecture.time.startTime.returnTimeString()
      endTimeLabel.text = modifyingLecture.time.endTime.returnTimeString()
      professorNameLabel.text = modifyingLecture.professor
      placeLabel.text = modifyingLecture.room
      memoLabel.text = modifyingLecture.memo
    }
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
    return daysArray.filter({$0.isSelected}).first ?? UIButton()
  }
  
  func weekDayToButton(a: Int) -> UIButton{
    if a == 2{
      return daysArray[0]
    } else if a == 3{
      return daysArray[1]
    } else if a == 4{
      return daysArray[2]
    } else if a == 5{
      return daysArray[3]
    } else if a == 6{
      return daysArray[4]
    } else {
      return UIButton()
    }
  }
  
  // TODO: 월요일 버튼을 받으면 OrdinaryTime의 월요일 리턴해주기.
  // TODO: 항상 1이 오는거 수정하기
  func selectButtonReturnsLectureDay(button: UIButton) -> Int {
    if button.titleLabel?.text == "월"{
      return 1
    }
    else if button.titleLabel?.text == "화"{
      return 2
    }
    else if button.titleLabel?.text == "수"{
      return 3
    }
    else if button.titleLabel?.text == "목"{
      return 4
    }
    else if  button.titleLabel?.text == "금"{
      return 5
    }
    else { return 1 }
  }
  
  @IBAction func didTapDayButton(sender: UIButton){
    sender.backgroundColor = .black
    sender.setTitleColor(.white, for: .normal)
    sender.isSelected = true
  }
  
  func dateToOrdinaryTime(_ date:Date) -> OrdinaryTime {
    let new = OrdinaryTime(hour: Calendar.current.component(.hour, from: date),
                           min: Calendar.current.component(.minute, from: date))
    return new
  }
  
  func didTapRegister(){
    let returnedDay = returnDay()
    let lectureTime = LectureTime(
                                  weekDay: selectButtonReturnsLectureDay(button: returnedDay),
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
    formatter.dateFormat = "HH:mm"
    return formatter
  }()
  var formatted: String {
    return Date.formatter.string(from: self)
  }
}

