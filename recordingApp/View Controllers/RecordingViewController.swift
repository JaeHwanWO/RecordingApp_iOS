//
//  ViewController.swift
//  recordingApp
//
//  Created by 조예진 on 03/05/2019.
//  Copyright © 2019 조예진. All rights reserved.
//

import UIKit
import AVFoundation

class RecordingViewController: UIViewController, AVAudioRecorderDelegate {
  
  var isAudioRecordingGranted:Bool!
  var isRecordingOn:Bool = false
  var meterTimer: Timer!
  var backgroundTimer: Timer!
  
  //현재 시각, 강의명 라벨들
  @IBOutlet weak var currentTimeLabel: UILabel!
  @IBOutlet weak var currentClassNameLabel: UILabel!
  @IBOutlet weak var guideTextLabel: UILabel!
  
  //녹음을 위한 버튼
  @IBOutlet weak var recordingTimeLabel: UILabel!
  @IBOutlet weak var recordingBtn: UIButton!
  @IBOutlet weak var settingBtn: UIButton!
  @IBOutlet weak var pauseButton: RoundedBorderButton!
  
  //오디오 녹음을 위한 변수들
  var recordingSession: AVAudioSession!
  var audioRecorder: AVAudioRecorder!
  
  // 시간을 트랙킹하기 위한 변수들
  var currentDate = Date()
  var currentCalendar = Calendar.current
  
  @IBOutlet weak var swipeMeLabel: UILabel!
  @IBOutlet weak var swipeButton: UIButton!
  
  @IBAction func swipeButton(_ sender: Any) {
    //ScheduleVC로 화면을 전환한다
    performSegue(withIdentifier: "SetScheduleVC", sender: sender)
  }
  
  @IBAction func settingBtn(_ sender: Any) {
    
  }
  
  @IBAction func recordingOnAndOff(_ sender: Any) {
    if (isRecordingOn == false){
      turnRecordingOn()
    }
    else{
      turnRecordingOff()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    backgroundTimer = Timer.scheduledTimer(timeInterval: 0.1,
               target: self,
               selector: #selector(displayIfNowIsClassTime),
               userInfo: nil,
               repeats: true)
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound], completionHandler: {didAllow,Error in
      //User가 Notification을 Allow하는지 물어보는 곳
      
    })
    checkRecordPermission()
    pauseButton.isHidden = true
    // 녹음 버튼에 사진 넣기
    if (isRecordingOn == false){
      recordingTimeLabel.text = "지금 바로 녹음을 시작하세요!"
      recordingTimeLabel.font = UIFont.boldSystemFont(ofSize: 20)
      recordingTimeLabel.textAlignment = .center
    }
    else {
      
    }
  }
  
  func turnRecordingOn(){
    //뒤에 배경 색을 빨간색으로 바꾼다
    //아이콘 멈춤 아이콘으로 바꾸기
    //설정 아이콘 색깔 흰색으로 바꾸기
    //아래로 스와이프! 이거랑 화살표 끄기
    view.backgroundColor = UIColor.red
    swipeButton.isHidden = true
    swipeMeLabel.isHidden = true
    currentTimeLabel.isHidden = true
    currentClassNameLabel.isHidden = true
    guideTextLabel.isHidden = true
    pauseButton.setTitleColor(.black, for: .normal)
    
    setupRecorder()
    audioRecorder.record()
    meterTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                      target:self,
                                      selector: #selector(updateAudioMeter(_:)),
                                      userInfo:nil,
                                      repeats:true)
    recordingTimeLabel.textColor = UIColor.white
    isRecordingOn = true
    pauseButton.isHidden = false
  }
  
  func turnRecordingOff(){
    //뒤에 배경 색을 흰색으로 바꾼다
    //아이콘 시작 아이콘으로 바꾸기
    //설정 아이콘 색깔 검은색으로 바꾸기
    //아래로 스와이프! 이거랑 화살표 보이게
    view.backgroundColor = UIColor.white
    recordingTimeLabel.text = "지금 바로 녹음을 시작하세요!"
    recordingTimeLabel.font = UIFont.boldSystemFont(ofSize: 20)
    recordingTimeLabel.textAlignment = .center
    swipeButton.isHidden = false
    swipeMeLabel.isHidden = false
    currentTimeLabel.isHidden = false
    currentClassNameLabel.isHidden = false
    guideTextLabel.isHidden = false
    finishAudioRecording(success: true)
    isRecordingOn = false
    pauseButton.isHidden = true
  }
  
  var isPause: Bool = true
  @IBAction func didTapPauseAndResume(_ sender: Any) {
    isPause = !isPause
    if isPause {
      print("about to resume")
      resume() }
    else {
      print("about to pause")
      pause()
    }
  }
  
  @objc func updateAudioMeter(_ timer: Timer) {
    if audioRecorder.isRecording {
      let hr = Int((audioRecorder.currentTime / 60) / 60)
      let min = Int(audioRecorder.currentTime / 60)
      let sec = Int(audioRecorder.currentTime.truncatingRemainder(dividingBy: 60))
      //한 시간보다 작다면 시간쪽은 표시 안하고, 한 시간 넘어가면 시간도 기록하는 기능 만들어야 함!
      let totalTimeString = String(format: "%d시간 %d분 %d초 녹음중", hr, min, sec)
      recordingTimeLabel.text = totalTimeString
      audioRecorder.updateMeters()
    }
  }
  
  func finishAudioRecording(success: Bool) {
    if success {
      audioRecorder.stop()
      audioRecorder = nil
      meterTimer.invalidate()
      // TODO: save
    }
    else {
      displayAlert(msg_title: "에러!",
                   msg_desc: "녹음 저장에 실패했습니다😭😭 왜지...",
                   action_title: "확인이염")
    }
  }
  
  func checkRecordPermission() {
    switch AVAudioSession.sharedInstance().recordPermission {
    case AVAudioSessionRecordPermission.granted:
      isAudioRecordingGranted = true
      break
    case AVAudioSessionRecordPermission.denied:
      isAudioRecordingGranted = false
      break
    case AVAudioSessionRecordPermission.undetermined:
      AVAudioSession.sharedInstance().requestRecordPermission({ (allowed) in
        if allowed {
          self.isAudioRecordingGranted = true
        } else {
          self.isAudioRecordingGranted = false
        }
      })
      break
    default:
      break
    }
  }
  
  @objc func displayIfNowIsClassTime(){
    // 현재 시간 라벨
    currentDate = Date()
    currentCalendar = Calendar.current
    
    let weekDay = currentCalendar.component(.weekday, from: currentDate)
    let hour = currentCalendar.component(.hour, from: currentDate)
    let minutes = currentCalendar.component(.minute, from: currentDate)
    // 라벨 디스플레이까지 해준다!

    for lecture in StateStore.shared.classArray {
      print(StateStore.shared.classArray.count)
      // 요일이 같고, 시간이 10분 전까지 이면
      let _a: Bool = (lecture.time.weekDay == weekDay)
      let _b: Bool = ((lecture.time.startTime.hour * 60 + lecture.time.startTime.min) - 10 <= (hour * 60 + minutes))
      let _c: Bool = ((lecture.time.endTime.hour * 60 + lecture.time.endTime.min) > (hour * 60 + minutes))
      
      if _a && _b && _c{
        currentTimeLabel.text = lecture.returnTimeString(lecture: lecture)
        currentClassNameLabel.text = "\(lecture.name)" + " 시간입니다"
        guideTextLabel.text = "지금 바로 녹음을 시작하세요!"
      }
      else{
        // 지금은 수업이 없는 시간~~
        currentTimeLabel.text = currentDate.description
        currentClassNameLabel.text = "쉴때는 열심히 쉬라구!"
        guideTextLabel.text = "아 집에 가고싶다"
      }
    }
  }
  
  func getFileUrl() -> URL {
    let documentsURL = FileManager.default.urls(for: .documentDirectory,
                                                in: .userDomainMask)[0]
    let filename = "1901002_미적분학_0900_1103.m4a"
    let filePath = documentsURL.appendingPathComponent(filename)
    return filePath
  }
  
  func displayAlert(msg_title : String, msg_desc : String, action_title : String) {
    let ac = UIAlertController(title: msg_title,
                               message: msg_desc,
                               preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: action_title, style: .default) { (result : UIAlertAction) -> Void in
      _ = self.navigationController?.popViewController(animated: true)
    })
    present(ac, animated: true)
  }
  
  func setupRecorder() {
    if isAudioRecordingGranted
    {
      let session = AVAudioSession.sharedInstance()
      do
      {
        try session.setCategory(AVAudioSession.Category.playAndRecord,
                                options: .defaultToSpeaker)
        try session.setActive(true)
        let settings = [
          AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
          AVSampleRateKey: 44100,
          AVNumberOfChannelsKey: 2,
          AVEncoderAudioQualityKey:AVAudioQuality.high.rawValue
        ]
        audioRecorder = try AVAudioRecorder(url: getFileUrl(), settings: settings)
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
      }
      catch let error {
        displayAlert(msg_title: "Error", msg_desc: error.localizedDescription, action_title: "OK")
      }
    }
    else {
      displayAlert(msg_title: "Error", msg_desc: "Don't have access to use your microphone.", action_title: "OK")
    }
  }
  
  func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool){
    if !flag {
      finishAudioRecording(success: false)
    }
  }
  
  func pause(){
    // 백그라운드 세팅 해주기
    view.backgroundColor = UIColor(red: 5/255, green: 83/255, blue: 212/255, alpha: 1)
    audioRecorder.pause()
    meterTimer.invalidate()
    pauseButton.setTitle("재개하기", for: .normal)
    pauseButton.setTitleColor(.black, for: .normal)
    
  }
  
  func resume(){
    view.backgroundColor = UIColor.red
    pauseButton.setTitleColor(.black, for: .normal)
    audioRecorder.record()
    meterTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                      target:self,
                                      selector: #selector(updateAudioMeter(_:)),
                                      userInfo:nil,
                                      repeats:true)
  }
  
  //swipe gesture을 감지하는 코드를 짜 보자!
  @IBAction func swipe(_ sender: UISwipeGestureRecognizer) {
    //performSegueWithIdentifier로 처리하면 될 듯!
    performSegue(withIdentifier: "SetScheduleVC", sender: sender)
  }
}
