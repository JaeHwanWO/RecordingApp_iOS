
//
//  RecordListViewController.swift
//  recordingApp
//
//  Created by 조예진 on 03/05/2019.
//  Copyright © 2019 조예진. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class RecordListViewController: UIViewController {
  
  @IBOutlet weak var upBtn: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    upBtn.setImage(UIImage(named:"uparrow_black"), for: .normal)
  }
  
  @IBAction func upBtnPressed(_ sender: Any) {
    let transition = CATransition()
    transition.duration = 0.5
    transition.type = CATransitionType.push
    transition.subtype = CATransitionSubtype.fromBottom
    view.window!.layer.add(transition, forKey: kCATransition)
    self.dismiss(animated: true, completion: nil)
    
  }
  
}
