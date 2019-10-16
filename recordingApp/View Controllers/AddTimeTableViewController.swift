
//
//  AddTimeTableVCViewController.swift
//  recordingApp
//
//  Created by 조예진 on 06/05/2019.
//  Copyright © 2019 조예진. All rights reserved.
//

import UIKit
import NotificationCenter
import UserNotifications

class AddTimeTableViewController: UIViewController {
  
  @IBOutlet weak var registerButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
    self.view.endEditing(true)
  }
  
  @IBAction func didTapCancel(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
  
  @IBAction func didTapRegister(_ sender: Any) {
    if let addTimeVC = self.children.first as? AddTimeViewController{
      addTimeVC.didTapRegister()
    }
    self.dismiss(animated: true, completion: nil)
  }
  
  // 애니메이션 확인해보고 삭제하기
  @IBAction func returnBtnClicked(_ sender: Any) {
    let transition = CATransition()
    transition.duration = 0.5
    transition.type = CATransitionType.push
    transition.subtype = CATransitionSubtype.fromBottom
    view.window!.layer.add(transition, forKey: kCATransition)
    self.dismiss(animated: true, completion: nil)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    if let view = self.presentingViewController as? ScheduleViewController{
      view.viewWillAppear(true)
    }
  }
}
