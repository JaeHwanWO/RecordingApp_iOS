//
//  SettingViewController.swift
//  recordingApp
//
//  Created by 조예진 on 03/05/2019.
//  Copyright © 2019 조예진. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  @IBAction func didTapBackButton(_ sender: Any) {
    navigationController?.popViewController(animated: true)
  }
}
