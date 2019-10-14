//
//  FAQViewController.swift
//  recordingApp
//
//  Created by 조예진 on 02/10/2019.
//  Copyright © 2019 조예진. All rights reserved.
//

import UIKit

class FAQViewController: UIViewController {
  
  @IBOutlet weak var faqTableView: UITableView!
  var data: [String:String] = [
    "녹음을 하는것에 법적인 문제가 없나요?":
    "공유 자체에는 문제가 없습니다",
    "녹음을 파는것에는 법적 문제가 있나요?":
    "녹음을 파는것은 법적으로 문제가 됩니다."
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  @IBAction func didTapDismiss(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }

}
