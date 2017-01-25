//
//  PostCellExpanded.swift
//  LooseFoot
//
//  Created by Alexander McArdle on 1/22/17.
//  Copyright © 2017 Alexander McArdle. All rights reserved.
//

import UIKit
import ChameleonFramework
import Cartography

class PostCellExpanded: UICollectionViewCell {
    
    static let titleHeight: CGFloat = 30
    static let imageHeight: CGFloat = 80
    static let imageWidth: CGFloat = 80
    static let font = AppFont(size: 15)
    static let smallFont = AppFont(size: 12, bold: true)
    
    static func cellSize(width: CGFloat, text: String) -> CGSize {
        let labelBounds = TextSize.size(text, font: PostCellExpanded.font, width: width, insets: CommonInsets)
        var cellHeight = labelBounds.height + PostCellExpanded.titleHeight
        if(cellHeight < (imageHeight + 6)) {
            cellHeight += ((imageHeight + 6) - cellHeight)
        }
        return CGSize(width: width, height: cellHeight)
    }
    
    let pointsLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.font = PostCellExpanded.smallFont
        label.textColor = UIColor.flatOrangeDark
        return label
    }()
    
    let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage()
        imageView.sizeToFit()
        return imageView
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.numberOfLines = 0
        label.font = PostCellExpanded.font
        label.textColor = UIColor.flatWhiteDark
        return label
    }()
    
    let authorLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.font = PostCellExpanded.smallFont
        label.textColor = UIColor.flatBlue
        return label
    }()
    
    let authorButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = PostCellExpanded.smallFont
        button.setTitleColor(UIColor.flatBlue, for: .normal)
        return button
    }()
    
    let subredditLabel: UILabel = {
        let label = UILabel()
        //label.layer.borderColor = UIColor.flatGray.cgColor
        //label.layer.borderWidth = 1
        label.backgroundColor = UIColor.clear
        label.font = PostCellExpanded.smallFont
        label.textColor = UIColor.flatGray
        label.textAlignment = .center
        return label
    }()
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.layer.borderColor = UIColor.flatGray.cgColor
        label.layer.borderWidth = 1
        label.backgroundColor = UIColor.clear
        label.font = PostCellExpanded.smallFont
        label.textColor = UIColor.flatGray
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor.flatBlack
        contentView.addSubview(postImageView)
        contentView.addSubview(messageLabel)
        //contentView.addSubview(authorLabel)
        contentView.addSubview(authorButton)
        contentView.addSubview(pointsLabel)
        contentView.addSubview(statusLabel)
        contentView.addSubview(subredditLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        constrain(postImageView, pointsLabel) { image, points in
            image.width == 80
            image.height == 80
            image.left == image.superview!.left + 3
            image.top == image.superview!.top + 3
            image.right == points.left - 5
            image.bottom <= image.superview!.bottom - 3
            
            points.top == image.top
        }
        constrain(pointsLabel, authorButton) { points, author in
            points.right == author.left - 3
            
            author.centerY == points.centerY
            //author.top == author.superview!.top + 3
            //author.bottom == points.bottom
        }
        constrain(authorButton, subredditLabel) { author, sub in
            author.right == sub.left - 3
            
            sub.top == sub.superview!.top + 3
            //sub.right <= sub.superview!.right - 3
        }
        constrain(subredditLabel, statusLabel) { sub, status in
            sub.right <= status.left - 3
            sub.top == status.top
            status.right == status.superview!.right - 3
        }
        constrain(messageLabel, pointsLabel) { message, points in
            message.left == points.left
            message.top == points.bottom + 3
            message.right == message.superview!.right - 3
            message.bottom <= message.superview!.bottom - 3
        }
        constrain(authorButton, messageLabel) { author, message in
            //author.bottom == message.top - 3
        }
        
        //        postImageView.frame = CGRect(x: 3, y: 3, width: PostCellExpanded.imageWidth, height: PostCellExpanded.imageHeight)
        //        authorLabel.frame = CGRect(x: CommonInsets.left + PostCellExpanded.imageWidth, y: 0, width: bounds.width - CommonInsets.left - CommonInsets.right - PostCellExpanded.imageWidth, height: PostCellExpanded.titleHeight)
        //        //authorLabel.frame = CGRect(x: CommonInsets.left, y: 0, width: bounds.width - CommonInsets.left - CommonInsets.right, height: PostCellExpanded.titleHeight)
        //        statusLabel.frame = CGRect(x: bounds.width - 82, y: 4, width: 70, height: 18)
        //        let messageFrame = CGRect(x: 0, y: authorLabel.frame.maxY, width: bounds.width, height: bounds.height - PostCellExpanded.titleHeight)
        //        messageLabel.frame = UIEdgeInsetsInsetRect(messageFrame, UIEdgeInsets(top: CommonInsets.top, left: PostCellExpanded.imageWidth + 6, bottom: CommonInsets.bottom, right: CommonInsets.right))
    }
}
