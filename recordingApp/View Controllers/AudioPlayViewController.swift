//
//  AudioPlayViewController.swift
//  recordingApp
//
//  Created by 조예진 on 19/09/2019.
//  Copyright © 2019 조예진. All rights reserved.
//

import UIKit
import AVFoundation

class AudioPlayViewController: UIViewController, AVAudioPlayerDelegate {
  var isPlaying: Bool = false
  var player: AVAudioPlayer!
  var updater: CADisplayLink! = nil
  
  @IBOutlet weak var progressBar: UISlider!
  @IBOutlet weak var playButton: UIButton!
  @IBOutlet weak var fastnessButton: RoundedBorderButton!
  @IBOutlet weak var songNameTitleLabel: UILabel!
  var url_2 = URL(string: "")
  
  var selectedFileName:String = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // todo: 앨범 아트 세팅하기
    // todo: 받아온 파일 플레이하기
    let path = selectedFileName
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let url = documentsURL.appendingPathComponent(path)
    url_2 = url

      //Bundle.main.path(forResource:"Boogie On & On", ofType: "mp3") else { return }
    do {
      player = try AVAudioPlayer(contentsOf: url)
      updater = CADisplayLink(target: self, selector: #selector(self.trackAudio))
      updater.preferredFramesPerSecond = 1
      updater.add(to: RunLoop.current, forMode: RunLoop.Mode.common)
      player.prepareToPlay()
      player.delegate = self
      progressBar.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    }
    catch {
      print(error)
    }
    print(selectedFileName)
    songNameTitleLabel.text = selectedFileName
  }
  
  @IBAction func sliderValueChanged(_ sender: UISlider) {
    if sender.isTracking { return }
    self.player.currentTime = TimeInterval(sender.value) * self.player.duration
  }
  
  @IBAction func didPressDismissButton(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  func play(){
    player.play()
    playButton.setImage(UIImage(named:"stop"), for: .normal)
  }
  
  @objc func trackAudio() {
    progressBar.value = Float(player.currentTime / player.duration)
  }
  
  func pause(){
    player.stop()
    playButton.setImage(UIImage(named:"play"), for: .normal)
  }
  func goForward(){
    // 다음곡으로 간다
  }
  func goBackward(){
    // 이 음악의 처음으로 간다, 이미 처음이면 이전곡으로 간다.
  }
  
  @IBAction func didTapPlayOrPauseButton(_ sender: Any) {
    isPlaying = !isPlaying
    if isPlaying{
      play()
    } else{
      pause()
    }
  }
  @IBAction func didTapGoBackwardButton(_ sender: Any) {
  }
  @IBAction func didTapGoForwardButton(_ sender: Any) {
  }
  @IBAction func didTapModifyButton(_ sender: Any) {
  }
  @IBAction func didTapShareButton(_ sender: Any) {
    // todo: UIActivityViewController 이용해서 공유하는 기능 만들기.
    // todo: 텍스트가 아니라 파일 공유하게 만들기
    
    let textToShare = [url_2]
    let activityViewController = UIActivityViewController(activityItems: textToShare as [Any], applicationActivities: nil)
    activityViewController.popoverPresentationController?.sourceView = self.view
    self.present(activityViewController, animated: true, completion: nil)
  }
}
