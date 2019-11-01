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
  
  /*
   한 시간은 (collection view 높이 / 10) 정도로 하고,
   collection view는 위아래 스크롤 가능하게 한다.
   
   공백은 자기 셀 높이! 안에서 해결한다. inner공백으로! 여백을 따로 주면 안됨.
   
   셀을 요일별로 분류한다.
   월~금 제일 빠른 시간 중, 가장 빠른 시간을 찾는다.
   
   그럼 제일 빠른 시간이, Lecture 타입으로 리턴된다.
   
   전체 lectureArray를 정렬한다.
   월, 화, 수, 목, 금 array를 만들어서 넣는다.
   
   월요일부터, 방금 찾은 가장 빠른 시간 기준으로 채우기 시작한다.
   
   공강 길이 만큼 채운다. 없는 시간은 흰색 칸으로 채운다.
   월~금 중 제일 늦은 시간까지 채우면 끝!
   */
  
  let colorBlue = [UIColor(named: "Blue_1"), UIColor(named:"Blue_2")]
  let colorGreen = [UIColor(named:"Green_1"), UIColor(named:"Green_2")]
  let colorOrange = [UIColor(named:"Orange_1"), UIColor(named:"Orange_2")]
  
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
      lectureArray.append(oneData) }
    
    var monArray = makeDaysArray(lectureArray: data, day: 1)
    var tueArray = makeDaysArray(lectureArray: data, day: 1)
    var wedArray = makeDaysArray(lectureArray: data, day: 1)
    var thuArray = makeDaysArray(lectureArray: data, day: 1)
    var friArray = makeDaysArray(lectureArray: data, day: 1)
    let earliestLectureIndex = findEarliestLecture(lectureArray: lectureArray)
    let latiestLectureIndex = findLatiestLecture(lectureArray: lectureArray)
    
    let startHr = lectureArray[earliestLectureIndex].time.startTime.hour
    let startMin = lectureArray[earliestLectureIndex].time.startTime.min
    
    let finishHr = lectureArray[latiestLectureIndex].time.startTime.hour
    let finishMin = lectureArray[latiestLectureIndex].time.startTime.min
    
    monArray = sortInTimeOrder(lectureArray: monArray)
    tueArray = sortInTimeOrder(lectureArray: tueArray)
    wedArray = sortInTimeOrder(lectureArray: wedArray)
    thuArray = sortInTimeOrder(lectureArray: thuArray)
    friArray = sortInTimeOrder(lectureArray: friArray)
    
    /*
     월요일부터, 방금 찾은 가장 빠른 시간 기준으로 채우기 시작한다.
     (Lecture.swift의 sortInTimeOrder함수 쓰기)
       공강 길이 만큼 채운다. 없는 시간은 흰색 칸으로 채운다.
       월~금 중 제일 늦은 시간까지 채우면 끝! Lecture에 투명한지 bool값을 만들어서 넣어둬야하나?
     */
   
    
    // TODO: 가짜 흰색 셀들을 더해줘야 함. fillInTimes
    if monArray[0].time.startTime.hour > startHr {
      // 빈 칸 만들어서 넣어준다.
      
      
    }
    
    // 필요한 함수: 최초 시간 /  분, 끝 시간 / 분 받아와서 빈칸을 다 채워주는 기능.
    // 해결할 문제: 빈 칸이랑, 일반 셀이랑 색깔 구분하는 기능.
    
    timeTable.reloadData()
    
  }
  
  func addEmptyLecture(_ argument: [Lecture]) -> [Lecture] {
    var argument = argument
    
    // URGENT TODO: 여기 배열 잘 돌아가는지 확인하기. 
    for i in 0...argument.count{
      if ((argument[i+1].time.startTime.hour) * 60 + argument[i+1].time.startTime.min > (argument[i].time.endTime.hour) * 60 + argument[i].time.endTime.min) {
        // 빈 곳에 fillInTimes
        // temporary 월요일(1)로 설정해둠.
        argument.insert(Lecture.init(time: LectureTime.init(weekDay: 1,
                                                            startTime: OrdinaryTime(hour: argument[i].time.endTime.hour,
                                                                                    min: argument[i].time.endTime.min),
                                                            endTime: OrdinaryTime(hour: argument[i+1].time.startTime.hour,
                                                                                  min: argument[i+1].time.startTime.min))), at: i)
      }
    }
    return argument
  }
  
  func findEarliestLecture(lectureArray: [Lecture]) -> Int {
    var lecture: Lecture = lectureArray.first ?? Lecture()
    var lectureIndex: Int = -1
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
    var lectureIndex: Int = -1
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
