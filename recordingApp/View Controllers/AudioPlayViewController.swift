//
//  AudioPlayViewController.swift
//  recordingApp
//
//  Created by 조예진 on 19/09/2019.
//  Copyright © 2019 조예진. All rights reserved.
//

import UIKit
import AVFoundation
// AVAudioPlayer을 쓰기 위해서!

class AudioPlayViewController: UIViewController, AVAudioPlayerDelegate {
  var isPlaying: Bool = false
  var player: AVAudioPlayer!
  var updater: CADisplayLink! = nil
  
  @IBOutlet weak var progressBar: UISlider!
  @IBOutlet weak var playButton: UIButton!
  @IBOutlet weak var fastnessButton: RoundedBorderButton!
  @IBOutlet weak var songNameTitleLabel: UILabel!
  
  var selectedFileName:String = ""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // todo: 앨범 아트 세팅하기
    guard let path = Bundle.main.path(forResource:"Boogie On & On", ofType: "mp3") else { return }
    let url = URL(fileURLWithPath : path)
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
    songNameTitleLabel.text = URL(string:selectedFileName)?.lastPathComponent
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
    let text = "내가 공유할 텍스트⭐️"
    let textToShare = [text]
    let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
    activityViewController.popoverPresentationController?.sourceView = self.view
    self.present(activityViewController, animated: true, completion: nil)
  }
}
