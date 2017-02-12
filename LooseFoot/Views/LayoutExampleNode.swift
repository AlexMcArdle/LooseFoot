//
//  LayoutExampleNode.swift
//  LooseFoot
//
//  Created by Alexander McArdle on 2/6/17.
//  Copyright © 2017 Alexander McArdle. All rights reserved.
//

import AsyncDisplayKit

class LayoutExampleNode: ASDisplayNode {
    override required init() {
        super.init()
        automaticallyManagesSubnodes = true
        backgroundColor = .white
    }
    
    class func title() -> String {
        assertionFailure("All layout example nodes must provide a title!")
        return ""
    }
    
    class func descriptionTitle() -> String? {
        return nil
    }
}

class HeaderWithRightAndLeftItems : LayoutExampleNode {
    let userNameNode     = ASTextNode()
    let postLocationNode = ASTextNode()
    let postTimeNode     = ASTextNode()
    
    required init() {
        super.init()
        userNameNode.attributedText = NSAttributedString(string: "hannahmbanana", attributes: ["fontSize": 20, "color": UIColor.flatBlueDark])
        userNameNode.maximumNumberOfLines = 1
        userNameNode.truncationMode = .byTruncatingTail
        
        postLocationNode.attributedText = NSAttributedString(string: "Sunset Beach, San Fransisco, CA", attributes: ["fontSize": 20, "color": UIColor.flatSkyBlue])
        postLocationNode.maximumNumberOfLines = 1
        postLocationNode.truncationMode = .byTruncatingTail
        
        postTimeNode.attributedText = NSAttributedString(string: "30m", attributes: ["fontSize": 20, "color": UIColor.flatGray])
        postTimeNode.maximumNumberOfLines = 1
        postTimeNode.truncationMode = .byTruncatingTail
    }
    
    override class func title() -> String {
        return "Header with left and right justified text"
    }
    
    override class func descriptionTitle() -> String? {
        return "try rotating me!"
    }
}

class PhotoWithInsetTextOverlay : LayoutExampleNode {
    let photoNode = ASNetworkImageNode()
    let titleNode = ASTextNode()
    
    required init() {
        super.init()
        
        backgroundColor = .clear
        
        photoNode.url = URL(string: "http://asyncdisplaykit.org/static/images/layout-examples-photo-with-inset-text-overlay-photo.png")
        photoNode.willDisplayNodeContentWithRenderingContext = { context in
            let bounds = context.boundingBoxOfClipPath
            UIBezierPath(roundedRect: bounds, cornerRadius: 10).addClip()
        }
        
        titleNode.attributedText = NSAttributedString(string: "family fall hikes", attributes: ["fontSize": 16, "color": UIColor.flatWhite])
            titleNode.truncationAttributedText = NSAttributedString(string: "...", attributes: ["fontSize": 16, "color": UIColor.flatWhite])
        titleNode.maximumNumberOfLines = 2
        titleNode.truncationMode = .byTruncatingTail
    }
    
    override class func title() -> String {
        return "Photo with inset text overlay"
    }
    
    override class func descriptionTitle() -> String? {
        return "try rotating me!"
    }
}

class PhotoWithOutsetIconOverlay : LayoutExampleNode {
    let photoNode = ASNetworkImageNode()
    let iconNode  = ASNetworkImageNode()
    
    required init() {
        super.init()
        
        photoNode.url = URL(string: "http://asyncdisplaykit.org/static/images/layout-examples-photo-with-outset-icon-overlay-photo.png")
        
        iconNode.url = URL(string: "http://asyncdisplaykit.org/static/images/layout-examples-photo-with-outset-icon-overlay-icon.png")
        
        iconNode.imageModificationBlock = { image in
            let profileImageSize = CGSize(width: 60, height: 60)
            return image.makeCircularImage(size: profileImageSize, borderWidth: 10)
        }
    }
    
    override class func title() -> String {
        return "Photo with outset icon overlay"
    }
    
    override class func descriptionTitle() -> String? {
        return nil
    }
}

class FlexibleSeparatorSurroundingContent : LayoutExampleNode {
    let topSeparator    = ASImageNode()
    let bottomSeparator = ASImageNode()
    let textNode        = ASTextNode()
    
    required init() {
        super.init()
        
        topSeparator.image = UIImage.as_resizableRoundedImage(withCornerRadius: 1.0, cornerColor: .black, fill: .black)
        
        textNode.attributedText = NSAttributedString.attributedString(string: "this is a long text node", fontSize: 16, color: .black)
        
        bottomSeparator.image = UIImage.as_resizableRoundedImage(withCornerRadius: 1.0, cornerColor: .black, fill: .black)
    }
    
    override class func title() -> String {
        return "Top and bottom cell separator lines"
    }
    
    override class func descriptionTitle() -> String? {
        return "try rotating me!"
    }
}
