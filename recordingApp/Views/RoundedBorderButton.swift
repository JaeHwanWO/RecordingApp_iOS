//
//  RoundedBorderButton.swift
//  recordingApp
//
//  Created by 조예진 on 06/05/2019.
//  Copyright © 2019 조예진. All rights reserved.
//
import UIKit

@IBDesignable class RoundedBorderButton: UIButton {
  
  var isSelectableToggleValue: Bool = false
  @IBInspectable dynamic var cornerRadius: CGFloat = 10.0 {
    didSet {
      layer.cornerRadius = cornerRadius
      layer.masksToBounds = true
    }
  }
  
  @IBInspectable dynamic var borderWidth: CGFloat = 1.0 {
    didSet {
      layer.borderWidth = borderWidth
    }
  }
  
  @IBInspectable dynamic var borderColor: UIColor = .white {
    didSet {
      layer.borderColor = borderColor.cgColor
    }
  }
  
  @IBInspectable dynamic var verticalInset: CGFloat = 5.0 {
    didSet {
      contentEdgeInsets.top = verticalInset
      contentEdgeInsets.bottom = verticalInset
    }
  }
  
  @IBInspectable dynamic var horizontalInset: CGFloat = 10.0 {
    didSet {
      contentEdgeInsets.left = horizontalInset
      contentEdgeInsets.right = horizontalInset
    }
  }
  
  @IBInspectable dynamic var isSelectable: Bool = false {
    didSet {
      self.isSelectableToggleValue = isSelectable
    }
  }
  
  @IBInspectable dynamic var isIconIncluded: Bool = false {
    didSet {
      if isIconIncluded{
        // 세팅을 해준다. 근데 이미지 어케 받을지 모르겠음 ;;
      }
    }
  }
  
  @IBInspectable dynamic var setBackgroundColor: UIColor = .white {
    didSet{
      self.backgroundColor = setBackgroundColor
    }
  }
  
  @IBInspectable dynamic var setTextColor: UIColor = .white {
    didSet{
      self.titleLabel!.textColor = setTextColor
    }
  }
  
  // 스토리보드로 만든 버튼용
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    _init()
  }
  
  // 코드로 짠 버튼용
  override init(frame: CGRect) {
    super.init(frame: frame)
    _init()
  }
  
  // IBDesignable이 반영되기 위해서
  override func prepareForInterfaceBuilder() {
    _init()
  }
  
  func _init() {
    clipsToBounds = true
    setTitleColor(setTextColor, for: .normal)
    layer.borderColor = borderColor.cgColor
    layer.cornerRadius = cornerRadius
    layer.borderWidth = borderWidth
    contentEdgeInsets.top = verticalInset
    contentEdgeInsets.bottom = verticalInset
    contentEdgeInsets.left = horizontalInset
    contentEdgeInsets.right = horizontalInset
    layer.borderColor = borderColor.cgColor
  }
}
