//
//  ScheduleViewController.swift
//  recordingApp
//
//  Created by 조예진 on 03/05/2019.
//  Copyright © 2019 조예진. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController {
  
  var lectureArray = [Lecture]()
  var lectureToSend: Lecture?
  
  @IBOutlet weak var upButton: UIButton!
  @IBOutlet weak var downButton: UIButton!
  @IBOutlet weak var timeTable: UICollectionView!
  @IBOutlet weak var monLabel: UILabel!
  
  @IBAction func upButtonPressed(_ sender: Any) {
    let transition = CATransition()
    transition.duration = 0.5
    transition.type = CATransitionType.push
    transition.subtype = CATransitionSubtype.fromBottom
    view.window!.layer.add(transition, forKey: kCATransition)
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func swipeUp(_ sender: UISwipeGestureRecognizer) {
    print("swipe up")
  }
  
  @IBAction func swipeRight(_ sender: UISwipeGestureRecognizer) {
    print("swipe right")
    self.performSegue(withIdentifier: "swipeRight", sender: self)
  }
  @IBAction func swipeDown(_ sender: UISwipeGestureRecognizer) {
    print("swipe down")
    self.performSegue(withIdentifier: "swipeDown", sender: self)
  }
  
  @IBAction func downButtonPressed(_ sender: Any) {
    self.performSegue(withIdentifier: "swipeDown", sender: self)
  }
  
  // 셀을 선택해서 수정할 때, 세그에 정보를 담아서 보내기 위해서 만드는 중.
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.destination is AddTimeViewController{
      let vc = segue.destination as? AddTimeViewController
      vc?.modifyingLecture = lectureToSend
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    lectureArray = []
    let data = StateStore.shared.classArray
    data.forEach(){ (oneData) in
      lectureArray.append(oneData)
    }
    
    var monArray = makeDaysArray(lectureArray: data, day: 1)
    var tueArray = makeDaysArray(lectureArray: data, day: 2)
    var wedArray = makeDaysArray(lectureArray: data, day: 3)
    var thuArray = makeDaysArray(lectureArray: data, day: 4)
    var friArray = makeDaysArray(lectureArray: data, day: 5)
    
    // 0이면 터짐;;
    if (lectureArray.count > 0){
      let earliestLectureIndex = findEarliestLecture(lectureArray: lectureArray)
      let latiestLectureIndex = findLatiestLecture(lectureArray: lectureArray)
      
      let startHr = lectureArray[earliestLectureIndex].time.startTime.hour
      let startMin = lectureArray[earliestLectureIndex].time.startTime.min
      
      let finishHr = lectureArray[latiestLectureIndex].time.endTime.hour
      let finishMin = lectureArray[latiestLectureIndex].time.endTime.min
      
      monArray = sortInTimeOrder(lectureArray: monArray)
      tueArray = sortInTimeOrder(lectureArray: tueArray)
      wedArray = sortInTimeOrder(lectureArray: wedArray)
      thuArray = sortInTimeOrder(lectureArray: thuArray)
      friArray = sortInTimeOrder(lectureArray: friArray)
      
      monArray = addEmptyLecture(monArray, 요일: 1, startHr, startMin, finishHr, finishMin)
      tueArray = addEmptyLecture(tueArray, 요일: 2, startHr, startMin, finishHr, finishMin)
      wedArray = addEmptyLecture(wedArray, 요일: 3, startHr, startMin, finishHr, finishMin)
      thuArray = addEmptyLecture(thuArray, 요일: 4, startHr, startMin, finishHr, finishMin)
      friArray = addEmptyLecture(friArray, 요일: 5, startHr, startMin, finishHr, finishMin)
    }
    
    // 해결할 문제: 빈 칸이랑, 일반 셀이랑 색깔 구분하는 기능.
    // 왜 빈칸이 안들어갔을까? -> 요일별로 더해줘서!
    
    lectureArray = []
    let allDaysArray = [monArray, tueArray, wedArray, thuArray, friArray]
    let countArray = [monArray.count, tueArray.count, wedArray.count, thuArray.count, friArray.count]
    let max = countArray.max()!
    
    for i in 0..<max{
      for j in 0..<allDaysArray.count{
        if (i < countArray[j]){
          lectureArray.append(allDaysArray[j][i])
        }
      }
    }
    timeTable.reloadData()
  }
  
  func addEmptyLecture(_ argument: [Lecture], 요일 weekDay: Int, _ startHr: Int, _ startMin: Int, _ finishHr: Int, _ finishMin: Int) -> [Lecture] {
    var _argument = argument
    var count = argument.count
    // URGENT TODO: 여기 배열 잘 돌아가는지 확인하기. 
    var i: Int = 0
    // 맨 처음 칸 insert
    
    // 하루종일 하나도 없을 때!
    
    if (count == 0){
      // 처음부터 끝까지 셀 추가.
      _argument.insert(Lecture.init(time: LectureTime.init(weekDay: weekDay,
                                                           startTime: OrdinaryTime(hour: startHr,
                                                                                   min: startMin),
                                                           endTime: OrdinaryTime(hour: finishHr,
                                                                                 min: finishMin))), at: 0)
      count += 1
    }
    else {
      if ((_argument[0].time.startTime.hour) * 60 + _argument[0].time.startTime.min > startHr * 60 + startMin){
        // 맨 앞 칸에 insert를 해준다.
        _argument.insert(Lecture.init(time: LectureTime.init(weekDay: weekDay,
                                                             startTime: OrdinaryTime(hour: startHr,
                                                                                     min: startMin),
                                                             
                                                             endTime: OrdinaryTime(hour: _argument[0].time.startTime.hour,
                                                                                   min: _argument[0].time.startTime.min))), at: 0)
        count += 1
      }
      
      // 맨 뒷 칸 insert
      if ((_argument[count-1].time.endTime.hour) * 60 + _argument[count-1].time.endTime.min < finishHr * 60 + finishMin){
        // 맨 뒤 칸에 insert를 해준다.
        _argument.insert(Lecture.init(time: LectureTime.init(weekDay: weekDay,
                                                             startTime: OrdinaryTime(hour: _argument[count-1].time.endTime.hour,
                                                                                     min: _argument[count-1].time.endTime.min),
                                                             
                                                             endTime: OrdinaryTime(hour: finishHr,
                                                                                   min: finishMin))), at: _argument.endIndex)
        
        count += 1
      }
      
      while(i < count - 1 && count > 1){
        // index range
        if ((_argument[i+1].time.startTime.hour) * 60 + _argument[i+1].time.startTime.min > (_argument[i].time.endTime.hour) * 60 + _argument[i].time.endTime.min) {
          // 빈 곳에 fillInTimes
          _argument.insert(Lecture.init(time: LectureTime.init(weekDay: weekDay,
                                                               startTime: OrdinaryTime(hour: _argument[i].time.endTime.hour,
                                                                                       min: _argument[i].time.endTime.min),
                                                               endTime: OrdinaryTime(hour: _argument[i+1].time.startTime.hour,
                                                                                     min: _argument[i+1].time.startTime.min))), at: i)
          count += 1
        }
        i += 1
      }
      
    }
    return _argument
  }
  
  // 문제: -1을 리턴함;;
  func findEarliestLecture(lectureArray: [Lecture]) -> Int {
    var lecture: Lecture = lectureArray.first ?? Lecture()
    var lectureIndex: Int = 0
    for (index, item) in lectureArray.enumerated(){
      if (item.time.startTime.hour * 60 + item.time.startTime.min) <= (lecture.time.startTime.hour * 60 + lecture.time.startTime.min){
        // lecture보다 i가 작으면
        lecture = item
        lectureIndex = index
      }
    }
    return lectureIndex
  }
  
  func findLatiestLecture(lectureArray: [Lecture]) -> Int {
    var lecture: Lecture = lectureArray.first ?? Lecture()
    var lectureIndex: Int = 0
    for (index, item) in lectureArray.enumerated(){
      if (item.time.startTime.hour * 60 + item.time.startTime.min) > (lecture.time.startTime.hour * 60 + lecture.time.startTime.min){
        // lecture보다 i가 작으면
        lecture = item
        lectureIndex = index
      }
    }
    return lectureIndex
  }
  
  func makeDaysArray(lectureArray: [Lecture], day: Int)-> [Lecture]{
    return lectureArray.filter({$0.time.weekDay == day})
  }
  
  // MARK:- [lecture]을 받아서, 시간 순서대로 배열해서 내보냅니다.
  func sortInTimeOrder(lectureArray: [Lecture]) -> [Lecture]{
    var array = lectureArray
    array.sort { $0.time.startTime.hour < $1.time.startTime.hour }
    return array
  }
  
}
// 콜렉션 뷰 관련 처리
extension ScheduleViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return lectureArray.count
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    lectureToSend = lectureArray[indexPath.row]
    performSegue(withIdentifier: "editTimeTableViewSegue", sender: self)
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewCell
    
    // MARK:- cell 안에 넣을 내용 고르는 곳.
    cell.displayContent(lecture: lectureArray[indexPath.row])
    return cell
  }
  
  // layout 관련
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let cellWidth : CGFloat = monLabel.bounds.size.width
    let cellheight : CGFloat = timeTable.frame.size.height / 5
    let cellSize = CGSize(width: cellWidth , height:cellheight)
    return cellSize
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    // 셀들, 헤더, 푸터 사이의 spacing을 Return 해준다.
    return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    // 레이아웃에서 각 줄에서 한 줄 사이사이의 공백을 관리한다.
    return ((collectionView.frame.width - 5 * monLabel.frame.width)/4)
  }
}
