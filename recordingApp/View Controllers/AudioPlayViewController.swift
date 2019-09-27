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

class AudioPlayViewController: UIViewController {
  
  @IBOutlet weak var progreeBar: UIProgressView!
  override func viewDidLoad() {
    super.viewDidLoad()
    // todo: 앨범 아트 세팅하기
    //
  }
  
  @IBAction func didPressDismissButton(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  func play(){
    
  }
  func pause(){
    
  }
  func goForward(){
    // 다음곡으로 간다
  }
  func goBackward(){
    // 이 음악의 처음으로 간다, 이미 처음이면 이전곡으로 간다.
  }
  
  @IBAction func didTapPlayOrPauseButton(_ sender: Any) {
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
