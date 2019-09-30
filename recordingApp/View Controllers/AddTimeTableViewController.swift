
//
//  AddTimeTableVCViewController.swift
//  recordingApp
//
//  Created by 조예진 on 06/05/2019.
//  Copyright © 2019 조예진. All rights reserved.
//

import UIKit

class AddTimeTableViewController: UIViewController {

  @IBOutlet weak var registerButton: UIButton!
  
    override func viewDidLoad() {
        super.viewDidLoad()
    }
  
  @IBAction func didTapRegister(_ sender: Any) {
    // 만든 시간표 객체를 StateStore에 추가해주기.
    // AddTimeVC에서 받아오기
//    var lecture = Lecture(name: <#T##String#>,
//                          time: <#T##LectureTime?#>,
//                          professor: <#T##String?#>,
//                          room: <#T##String?#>,
//                          memo: <#T##String?#>)
//    StateStore.shared.classArray.append(<#Lecture#>)
    
    AddTimeViewController.didTapRegister(self)
  }
  
    @IBAction func returnBtnClicked(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromBottom
        view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: true, completion: nil)
    }
}
