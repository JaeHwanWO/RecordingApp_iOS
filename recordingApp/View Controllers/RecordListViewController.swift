
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
  var listWithFullURL: [String] = []
  var listWithFileName: [String] = []
  
  @IBOutlet weak var recordListTableView: UITableView!
  @IBOutlet weak var upBtn: UIButton!
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return listWithFileName.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let reuseIdentifier = "programmaticCell"
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MGSwipeTableCell
    cell.textLabel!.text = listWithFileName[indexPath.row]
    cell.delegate = self //optional
    //configure right buttons
    cell.rightButtons = [MGSwipeButton(title: "삭제",backgroundColor: .red),
                         MGSwipeButton(title: "공유", backgroundColor: .blue)]
    cell.rightSwipeSettings.transition = .drag
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // 오디오를 선택하면 플레이하는 뷰가 init되고, 음악이 재생된다(추후 기능 추가)
    let audioPlayScene = AudioPlayViewController(nibName: "AudioPlay", bundle: nil)
    // 선택된 파일 명을 넘겨준다
    audioPlayScene.selectedFileName = listWithFileName[indexPath.row]
    self.present(audioPlayScene, animated: true, completion: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    getFilesFromLocal()
  }
  
  func getFilesFromLocal(){
    // 기존 녹음 파일 리스트 받아오기
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    do{
      let items = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
      
      for item in items{
        listWithFullURL.append(item.absoluteString)
        listWithFileName.append(item.lastPathComponent)
      }
    } catch{
      NSLog(error as! String)
    }
  }
  
  @IBAction func upBtnPressed(_ sender: Any) {
    let transition = CATransition()
    transition.duration = 0.5
    transition.type = CATransitionType.push
    transition.subtype = CATransitionSubtype.fromBottom
    view.window!.layer.add(transition, forKey: kCATransition)
    self.dismiss(animated: true, completion: nil)
  }
  
  func getSumOf(array:[Int], handler: ((Int)->Void)) {
    //step 2
    var sum: Int = 0
    for value in array {
      sum += value
    }
    //step 3
    handler(sum)
  }
  
}
