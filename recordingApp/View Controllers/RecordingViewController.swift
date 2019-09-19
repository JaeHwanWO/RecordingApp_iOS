//
//  ViewController.swift
//  recordingApp
//
//  Created by 조예진 on 03/05/2019.
//  Copyright © 2019 조예진. All rights reserved.
//

import UIKit
import AVFoundation
import UserNotifications

class RecordingViewController: UIViewController, AVAudioRecorderDelegate {
  
  var isAudioRecordingGranted:Bool!
  var isRecordingOn:Bool = false
  var meterTimer:Timer!
  
  //녹음을 위한 버튼
  @IBOutlet weak var recordingTimeLabel: UILabel!
  @IBOutlet weak var recordingBtn: UIButton!
  @IBOutlet weak var settingBtn: UIButton!
  
  //오디오 녹음을 위한 변수들
  var recordingSession: AVAudioSession!
  var audioRecorder: AVAudioRecorder!
  
  @IBOutlet weak var swipeMeLabel: UILabel!
  @IBOutlet weak var swipeButton: UIButton!
  
  @IBAction func swipeButton(_ sender: Any) {
    //ScheduleVC로 화면을 전환한다
    performSegue(withIdentifier: "SetScheduleVC", sender: sender)
  }
  
  @IBAction func settingBtn(_ sender: Any) {
    print("setting btn pushed, change to SettingVC")
  }
  
  @IBAction func recordingOnAndOff(_ sender: Any) {
    if (isRecordingOn == false){
      //녹음을 킨다
      //turnRecordingOn
      turnRecordingOn()
    }
    else{
      //녹음을 끈다
      //turnRecordingOff
      turnRecordingOff()
    }
  }
  
  func goPushAlarm(){
    let content = UNMutableNotificationContent()
    content.title = "🎙✨강의 녹음할 시간이에요🎙✨"
    content.subtitle = "지금은 미적분학 수업을 녹음할 시간입니다! 시험기간을 위해서 미리 녹음해주세요😚"
    content.body = "11:00 AM ~ 1:00 PM 미적분학"
    
    var date = DateComponents()
    date.hour = 00
    date.minute = 40
    let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
    let request = UNNotificationRequest(identifier: "timerdone", content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    goPushAlarm()
    UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound], completionHandler: {didAllow,Error in
      //User가 Notification을 Allow하는지 물어보는 곳
      print(didAllow)
    })
    
    settingBtn.setImage(UIImage(named: "nut-icon 사본"), for: .normal)
    //image 크기 수정 필요!
    swipeButton.setImage(UIImage(named: "downarrow_black.png"), for: .normal)
    swipeButton.setBackgroundImage(UIImage(named: "downarrow_black.png"), for: .normal)
    checkRecordPermission()
    
    // 녹음 버튼에 사진 넣기
    if (isRecordingOn == false){
      //처음 앱을 켰을 때, 녹음중이 아니라면
      recordingBtn.setImage(UIImage(named: "RecordingBtnPic"), for: .normal)
      recordingTimeLabel.text = "지금 바로 녹음을 시작하세요!"
      recordingTimeLabel.font = UIFont.boldSystemFont(ofSize: 20)
      recordingTimeLabel.textAlignment = .center
    }
    else {
      print("error: 처음 앱 켰는데 녹음중이다")
    }
  }
  
  func turnRecordingOn(){
    //뒤에 배경 색을 빨간색으로 바꾼다
    //아이콘 멈춤 아이콘으로 바꾸기
    //설정 아이콘 색깔 흰색으로 바꾸기
    //아래로 스와이프! 이거랑 화살표 끄기
    view.backgroundColor = UIColor.red
    recordingBtn.setImage(UIImage(named: "recordingBtn_recording"), for: .normal)
    swipeButton.setBackgroundImage(UIImage(named: "downarrow_white.png"), for: .normal)
    swipeButton.isHidden = true
    swipeMeLabel.isHidden = true
    setup_recorder()
    audioRecorder.record()
    meterTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self, selector: #selector(updateAudioMeter(_:)), userInfo:nil, repeats:true)
    recordingTimeLabel.textColor = UIColor.white
    isRecordingOn = true
  }
  
  func turnRecordingOff(){
    //뒤에 배경 색을 흰색으로 바꾼다
    //아이콘 시작 아이콘으로 바꾸기
    //설정 아이콘 색깔 검은색으로 바꾸기
    //아래로 스와이프! 이거랑 화살표 보이게
    view.backgroundColor = UIColor.white
    recordingBtn.setBackgroundImage(UIImage(named: "RecordingBtnPic"), for: .normal)
    //        swipeButton.setImage(UIImage(named: "downarrow_black.png"), for: .normal)
    swipeButton.setBackgroundImage(UIImage(named: "downarrow_black.png"), for: .normal)
    recordingTimeLabel.text = "지금 바로 녹음을 시작하세요!"
    recordingTimeLabel.font = UIFont.boldSystemFont(ofSize: 20)
    recordingTimeLabel.textAlignment = .center
    swipeButton.isHidden = false
    swipeMeLabel.isHidden = false
    finishAudioRecording(success: true)
    isRecordingOn = false
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
      print("recorded successfully.")
    }
    else {
      display_alert(msg_title: "Error", msg_desc: "Recording failed.", action_title: "OK")
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
  
  
  //녹음할 파일을 저장할 디렉토리
  func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
    //TODO: 여기 파일구조 어케 되었는지 봐야함!
  }
  
  
  func getFileUrl() -> URL {
    let filename = "test.m4a"
    //**고칠 사항 : 지금 시간 받아와서 파일명에 append
    let filePath = getDocumentsDirectory().appendingPathComponent(filename)
    return filePath
  }
  
  
  func display_alert(msg_title : String, msg_desc : String, action_title : String) {
    let ac = UIAlertController(title: msg_title, message: msg_desc, preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: action_title, style: .default)
    {
      (result : UIAlertAction) -> Void in
      _ = self.navigationController?.popViewController(animated: true)
    })
    present(ac, animated: true)
    
    //아마 이렇게 하면 alert view로 보이는듯???????
    //코드를 잘 읽어보자!!
  }
  
  func setup_recorder() {
    if isAudioRecordingGranted
    {
      let session = AVAudioSession.sharedInstance()
      do
      {
        try session.setCategory(AVAudioSession.Category.playAndRecord, options: .defaultToSpeaker)
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
        display_alert(msg_title: "Error", msg_desc: error.localizedDescription, action_title: "OK")
      }
    }
    else {
      display_alert(msg_title: "Error", msg_desc: "Don't have access to use your microphone.", action_title: "OK")
    }
  }
  
  func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool){
    if !flag {
      finishAudioRecording(success: false)
    }
  }
  
  //swipe gesture을 감지하는 코드를 짜 보자!
  @IBAction func swipe(_ sender: UISwipeGestureRecognizer) {
    print("swipe")
    //performSegueWithIdentifier로 처리하면 될 듯!
    performSegue(withIdentifier: "SetScheduleVC", sender: sender)
  }
}
