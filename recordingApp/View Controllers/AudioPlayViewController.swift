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
  @IBOutlet weak var progressBar: UIProgressView!
  
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
    }
    catch {
      print(error)
    }
  }
  
  @IBAction func didPressDismissButton(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  func play(){
    player.play()
  }
  
  @objc func trackAudio() {
    progressBar.setProgress(Float(player.currentTime), animated: true)
  }
  
  func pause(){
    player.stop()
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
  }
}
