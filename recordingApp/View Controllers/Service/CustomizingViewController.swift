//
//  CustomizingViewController.swift
//  recordingApp
//
//  Created by 조예진 on 02/10/2019.
//  Copyright © 2019 조예진. All rights reserved.
//

import UIKit

class CustomizingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
  @IBAction func didTapDismiss(_ sender: Any) {
     self.dismiss(animated: true, completion: nil)
   }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
