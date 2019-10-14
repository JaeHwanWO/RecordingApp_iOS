//
//  AudioPlayViewController.swift
//  recordingApp
//
//  Created by 조예진 on 19/09/2019.
//  Copyright © 2019 조예진. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class AudioPlayViewController: UIViewController, AVAudioPlayerDelegate {
  var isPlaying: Bool = false
  var player: AVAudioPlayer!
  var updater: CADisplayLink! = nil
  
  @IBOutlet weak var progressBar: UISlider!
  @IBOutlet weak var playButton: UIButton!
  @IBOutlet weak var fastnessButton: RoundedBorderButton!
  @IBOutlet weak var songNameTitleLabel: UILabel!
  var urlOfFile = URL(string: "")
  var selectedFileName:String = ""
  
  func setupNowPlayingInfoCenter(){
    UIApplication.shared.beginReceivingRemoteControlEvents()
    MPRemoteCommandCenter.shared().playCommand.addTarget {event in
      self.play()
      return .success
    }
    MPRemoteCommandCenter.shared().pauseCommand.addTarget {event in
      self.pause()
      return .success
    }
    MPRemoteCommandCenter.shared().nextTrackCommand.addTarget {event in
      self.goForward()
      return .success
    }
    MPRemoteCommandCenter.shared().previousTrackCommand.addTarget {event in
      self.goBackward()
      return .success
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let path = selectedFileName
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    urlOfFile = documentsURL.appendingPathComponent(path)
    
    do {
      player = try AVAudioPlayer(contentsOf: urlOfFile!)
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
    
    setupNowPlayingInfoCenter()
    MPNowPlayingInfoCenter.default().nowPlayingInfo = [
      MPMediaItemPropertyTitle: selectedFileName,
      MPMediaItemPropertyArtist: "self"
    ]
    
    songNameTitleLabel.text = selectedFileName
    let session = AVAudioSession.sharedInstance()
    do{
      try session.setCategory(AVAudioSession.Category.playback)
    }
    catch{
    }
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
    playButton.setImage(UIImage(named:"stop")!, for: .normal)
  }
  
  @objc func trackAudio() {
    progressBar.value = Float(player.currentTime / player.duration)
  }
  
  func pause(){
    player.stop()
    playButton.setImage(UIImage(named:"play")!, for: .normal)
  }
  func goForward(){
    // 다음곡으로 간다
  }
  func goBackward(){
    // 이 음악의 처음으로 간다, 이미 처음이면 이전곡으로 간다.
  }
  
  func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    isPlaying = !isPlaying
    pause()
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
    let audioToShare = [urlOfFile]
    let activityViewController = UIActivityViewController(activityItems: audioToShare as [Any], applicationActivities: nil)
    activityViewController.popoverPresentationController?.sourceView = self.view
    self.present(activityViewController, animated: true, completion: nil)
  }
}
