
//
//  RecordListViewController.swift
//  recordingApp
//
//  Created by 조예진 on 03/05/2019.
//  Copyright © 2019 조예진. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class RecordListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MGSwipeTableCellDelegate {
  
  // dummy data
  var list: [String] = ["190504_미적분학_1200_1300",
                        "190511_미적분학_1200_1300",
                        "190518_미적분학_1200_1300",
                        "190504_미적분학_1200_1300",
                        "190602_미적분학_1200_1300"]
  
  @IBOutlet weak var recordListTableView: UITableView!
  @IBOutlet weak var upBtn: UIButton!
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return list.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let reuseIdentifier = "programmaticCell"
    var cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MGSwipeTableCell
    
    cell.textLabel!.text = list[indexPath.row]
    cell.delegate = self //optional
    
    //configure right buttons
    cell.rightButtons = [MGSwipeButton(title: "삭제",backgroundColor: .red),
                         MGSwipeButton(title: "공유", backgroundColor: .blue)]
    cell.rightSwipeSettings.transition = .drag
    
    return cell
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
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
