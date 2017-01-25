//
//  CustomNavigationBar.swift
//  LooseFoot
//
//  Created by Alexander McArdle on 1/22/17.
//  Copyright © 2017 Alexander McArdle. All rights reserved.
//

import UIKit
import FontAwesome_swift
import ChameleonFramework

class CustomNavigationBar: UINavigationBar {
    
    let titleButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.setAttributedTitle(NSAttributedString(string: "Reddit"), for: .normal)
        button.titleLabel?.font = AppFont()
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.textColor = UIColor.flatWhite
        return button
    }()
    
    let settingsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clear
        button.setTitle(String.fontAwesomeIcon(name: .cog), for: .normal)
        button.titleLabel?.font = UIFont.fontAwesome(ofSize: 20)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(UIColor.flatWhite, for: .normal)
        button.sizeToFit()
        return button
    }()
    
//    let settingsLabel: UILabel = {
//        let label = UILabel()
//        label.backgroundColor = UIColor.clear
//        label.text = String.fontAwesomeIcon(name: .cog)
//        label.font = AppFont()
//        label.textAlignment = .center
//        label.textColor = UIColor.flatRed
//        label.sizeToFit()
//        return label
//    }()
    
    let statusIndicator: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.strokeColor = UIColor.white.cgColor
        layer.lineWidth = 1
        layer.fillColor = UIColor.black.cgColor
        let size: CGFloat = 8
        let frame = CGRect(x: 0, y: 0, width: size, height: size)
        layer.path = UIBezierPath(roundedRect: frame, cornerRadius: size/2).cgPath
        layer.frame = frame
        return layer
    }()
    
    let highlightLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.flatOrangeDark.cgColor
        return layer
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        layer.addSublayer(highlightLayer)
        //layer.addSublayer(statusIndicator)
        addSubview(titleButton)
        addSubview(settingsButton)
        barTintColor = UIColor.flatBlackDark
        //updateStatus()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let titleWidth: CGFloat = 130
        let borderHeight: CGFloat = 4
        
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: titleWidth, y: 0))
        path.addLine(to: CGPoint(x: titleWidth, y: bounds.height - borderHeight))
        path.addLine(to: CGPoint(x: bounds.width, y: bounds.height - borderHeight))
        path.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
        path.addLine(to: CGPoint(x: 0, y: bounds.height))
        path.close()
        highlightLayer.path = path.cgPath
        
        titleButton.frame = CGRect(x: 0, y: 0, width: titleWidth, height: bounds.height)
        settingsButton.frame = CGRect(
            x: bounds.width - settingsButton.bounds.width - CommonInsets.right,
            y: bounds.height - borderHeight - settingsButton.bounds.height - 6,
            width: settingsButton.bounds.width,
            height: settingsButton.bounds.height
        )
    
        //statusIndicator.position = CGPoint(x: settingsLabel.center.x - 50, y: settingsLabel.center.y - 1)
    }
    
    var statusOn = false
    
    func setTitle(title: String, backEnabled: Bool = true) {
        if(backEnabled) {
            let mutableString = NSMutableAttributedString(string: "\(String.fontAwesomeIcon(name: .chevronLeft)) Comments")
            mutableString.addAttributes([NSFontAttributeName: UIFont.fontAwesome(ofSize: 18)], range: NSRange(location: 0, length: 1))
            mutableString.addAttribute(NSFontAttributeName, value: AppFont(), range: NSRange(location: 2, length: (mutableString.string.characters.count - 5)))
            titleButton.setAttributedTitle(mutableString, for: .normal)
        } else {
            let mutableString = NSMutableAttributedString(string: title)
            mutableString.addAttribute(NSFontAttributeName, value: AppFont(), range: NSRange(location: 0, length: mutableString.string.characters.count))
            titleButton.setAttributedTitle(mutableString, for: .normal)
        }
    }
    
    func setSettings(title: String) {
        settingsButton.setTitle(title, for: .normal)
    }
    func updateStatus() {
        statusOn = !statusOn
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        statusIndicator.fillColor = (statusOn ? UIColor.white : UIColor.black).cgColor
        CATransaction.commit()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.6) {
            self.updateStatus()
        }
    }
    
}

