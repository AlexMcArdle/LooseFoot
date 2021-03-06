//
//  AMSearchCellNode.swift
//  LooseFoot
//
//  Created by Alexander McArdle on 2/11/17.
//  Copyright © 2017 Alexander McArdle. All rights reserved.
//

import AsyncDisplayKit
import ChameleonFramework
import FontAwesome_swift
import UIColor_Hex_Swift

class AMSearchCellNode: ASCellNode {
    
    let subreddit: AMSubreddit
    
    fileprivate let titleNode = ASTextNode()
//    fileprivate let authorNode = ASTextNode()
//    fileprivate let imageNode = ASNetworkImageNode()
//    fileprivate let pointsNode = ASTextNode()
//    fileprivate let commentsNode = ASTextNode()
//    fileprivate let subredditNode = ASTextNode()
//    fileprivate let authorFlairNode = ASTextNode()
//    fileprivate let linkFlairNode = ASTextNode()
//    fileprivate let goldNode = ASTextNode()
//    fileprivate let nsfwNode = ASTextNode()
//    fileprivate let spoilerNode = ASTextNode()
    let middleStackSpec = ASStackLayoutSpec.vertical()
//    let horizontalStackSpec = ASStackLayoutSpec.horizontal()
//    let rightSideStackSpec = ASStackLayoutSpec.vertical()
//    let leftSideStackSpec = ASStackLayoutSpec.vertical()
//    let topRowStackSpec = ASStackLayoutSpec.horizontal()
//    let bottomRowStackSpec = ASStackLayoutSpec.horizontal()
//    
//    let linkFlairBackground = ASDisplayNode()
//    let authorFlairBackground = ASDisplayNode()
//    
//    var linkFlairOverlay: ASBackgroundLayoutSpec?
//    var authorFlairOverlay: ASBackgroundLayoutSpec?
//    
//    var topRowChildren: [ASLayoutElement]?
//    var bottomRowChildren: [ASLayoutElement]?
//    var leftSideChildren: [ASLayoutElement]?
//    var horizontalStackChildren: [ASLayoutElement]?
    
    init(sub: AMSubreddit) {
        self.subreddit = sub
        
        // init the super
        super.init()
        
//        topRowChildren = [subredditNode]
//        bottomRowChildren = [authorNode]
//        leftSideChildren = [imageNode]
//        horizontalStackChildren = [middleStackSpec, rightSideStackSpec]
        
        self.automaticallyManagesSubnodes = true
        backgroundColor = .flatBlack
        
        // Check for Image
//        imageNode.shouldRenderProgressImages = true
//        if(link.l.thumbnail.hasPrefix("http")) {
//            imageNode.url = URL(string: link.l.thumbnail)
//            
//            horizontalStackChildren?.insert(imageNode, at: 0)
//        }
        
        titleNode.attributedText = NSAttributedString.attributedString(string: subreddit.s.displayName, fontSize: 12, color: .flatWhiteDark)
//        subredditNode.attributedText = NSAttributedString.attributedString(string: link.l.subreddit, fontSize: 12, color: UIColor.flatSkyBlue)
//        authorNode.attributedText = NSAttributedString.attributedString(string: link.l.author, fontSize: 12, color: .flatSand)
//        
//        var scoreString = String(link.l.score)
//        if(link.l.score >= 1000) {
//            scoreString = link.l.score.getFancyNumber()!
//        }
//        pointsNode.attributedText = NSAttributedString.attributedString(string: scoreString, fontSize: 12, color: .orange)
//        
//        commentsNode.attributedText = NSAttributedString.attributedString(string: String(link.l.numComments), fontSize: 12, color: .flatGray)
//        
//        // Check for Link Flair
//        if(link.l.linkFlairText != "") {
//            let flairString = link.l.linkFlairText.checkForBrackets()
//            linkFlairNode.attributedText = NSAttributedString.attributedString(string: flairString, fontSize: 8, color: .flatWhite)
//            linkFlairNode.textContainerInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
//            //linkFlairNode.borderWidth = 1.0
//            //linkFlairNode.borderColor = UIColor.flatWhiteDark.cgColor
//            //linkFlairNode.cornerRadius = 10.0
//            linkFlairNode.truncationMode = .byTruncatingTail
//            linkFlairNode.maximumNumberOfLines = 1
//            
//            linkFlairBackground.clipsToBounds = true
//            linkFlairBackground.borderColor = UIColor.flatGrayDark.cgColor
//            linkFlairBackground.borderWidth = 5.0
//            linkFlairBackground.cornerRadius = 5
//            linkFlairBackground.backgroundColor = .flatGrayDark
//            
//            linkFlairOverlay = ASBackgroundLayoutSpec(child: linkFlairNode, background: linkFlairBackground)
//            
//            topRowChildren?.append(linkFlairOverlay!)
//        }
//        
//        // Check for Author Flair
//        if(link.l.authorFlairText != "") {
//            let flairString = link.l.authorFlairText.checkForBrackets()
//            authorFlairNode.attributedText = NSAttributedString.attributedString(string: flairString, fontSize: 8, color: .flatWhite)
//            authorFlairNode.textContainerInset = UIEdgeInsets(top: 0, left: 2, bottom: 1, right: 2)
//            //            authorFlairNode.borderWidth = 1.0
//            //            authorFlairNode.borderColor = UIColor.flatGrayDark.cgColor
//            //            authorFlairNode.cornerRadius = 3.0
//            authorFlairNode.truncationMode = .byTruncatingTail
//            authorFlairNode.maximumNumberOfLines = 1
//            
//            authorFlairBackground.clipsToBounds = true
//            authorFlairBackground.borderColor = UIColor.flatGrayDark.cgColor
//            authorFlairBackground.borderWidth = 5.0
//            authorFlairBackground.cornerRadius = 5
//            authorFlairBackground.backgroundColor = .flatGrayDark
//            
//            authorFlairOverlay = ASBackgroundLayoutSpec(child: authorFlairNode, background: authorFlairBackground)
//            
//            bottomRowChildren?.append(authorFlairOverlay!)
//        }
//        
//        // Check for NSFW
//        if(link.l.over18) {
//            nsfwNode.attributedText = NSAttributedString.attributedString(string: "NSFW", fontSize: 10, color: .flatRedDark)
//            nsfwNode.textContainerInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
//            nsfwNode.borderWidth = 1.0
//            nsfwNode.borderColor = UIColor.flatRedDark.cgColor
//            nsfwNode.cornerRadius = 3.0
//            
//            topRowChildren?.insert(nsfwNode, at: 0)
//        }
//        // Check for Spoiler
//        if(link.l.spoiler != 0) {
//            spoilerNode.attributedText = NSAttributedString.attributedString(string: "SPOILER", fontSize: 10, color: .flatRedDark)
//            spoilerNode.textContainerInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
//            spoilerNode.borderWidth = 1.0
//            spoilerNode.borderColor = UIColor.flatRedDark.cgColor
//            spoilerNode.cornerRadius = 3.0
//            
//            topRowChildren?.insert(spoilerNode, at: 0)
//        }
//        
//        // Check for Gold
//        if(link.l.gilded > 0) {
//            //goldNode.attributedText = NSAttributedString.attributedString(string: String(link.l.gilded), fontSize: 12, color: UIColor("#ffd700"))
//            let goldSymbol = NSMutableAttributedString(string: String.fontAwesomeIcon(name: .star), attributes: [NSFontAttributeName: UIFont.fontAwesome(ofSize: 12)])
//            
//            let text: NSMutableAttributedString = goldSymbol
//            
//            // Add count if more than one (disabled)
//            //if(link.l.gilded > 1) {
//            let count = NSMutableAttributedString(string: "x\(link.l.gilded)", attributes: [NSFontAttributeName: AppFont(size: 12, bold: false)])
//            text.append(count)
//            //}
//            
//            text.addAttribute(NSForegroundColorAttributeName, value: UIColor(hexString: "FFD700")!, range: NSRange(location: 0, length: text.length))
//            goldNode.attributedText = text as NSAttributedString
//            
//            topRowChildren?.append(goldNode)
//        }
    }
    
    
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        //debugPrint(constrainedSize)
        
        // Make the images pretty
//        if(link.l.thumbnail.hasPrefix("http")) {
//            let imageSize = CGSize(width: 60, height: 60)
//            imageNode.style.preferredSize = imageSize
//            imageNode.imageModificationBlock = { image in
//                let width: CGFloat
//                var color: UIColor? = nil
//                if(self.link.l.over18) {
//                    width = 5
//                    color = UIColor.flatRed
//                } else {
//                    width = 0
//                }
//                return image.makeRoundedImage(size: imageSize, borderWidth: width, color: color)
//            }
//        } else {
//            imageNode.style.preferredSize = CGSize(width: 0, height: 0)
//        }
        
        
        
//        linkFlairNode.style.flexGrow = 1.0
//        linkFlairNode.style.flexShrink = 1.0
//        authorFlairNode.style.flexGrow = 1.0
//        authorFlairNode.style.flexShrink = 1.0
//        
//        topRowStackSpec.alignItems = .center
//        topRowStackSpec.spacing = 5.0
//        topRowStackSpec.children = topRowChildren
//        topRowStackSpec.style.flexShrink = 1.0
//        topRowStackSpec.style.flexGrow = 1.0
//        
        middleStackSpec.alignItems = .start
        middleStackSpec.spacing = 5.0
        middleStackSpec.children = [titleNode]
        middleStackSpec.style.flexShrink = 1.0
        middleStackSpec.style.flexGrow = 1.0
//
//        bottomRowStackSpec.alignItems = .center
//        bottomRowStackSpec.spacing = 5.0
//        bottomRowStackSpec.children = bottomRowChildren
//        bottomRowStackSpec.style.flexShrink = 1.0
//        bottomRowStackSpec.style.flexGrow = 1.0
//        
//        leftSideStackSpec.alignItems = .center
//        leftSideStackSpec.spacing = 5.0
//        leftSideStackSpec.children = [imageNode]
//        
//        rightSideStackSpec.alignItems = .center
//        rightSideStackSpec.spacing = 5.0
//        rightSideStackSpec.children = [pointsNode, commentsNode]
//        
//        horizontalStackSpec.alignItems = .start
//        horizontalStackSpec.spacing = 5.0
//        horizontalStackSpec.children = horizontalStackChildren
        
        
        
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5), child: middleStackSpec)
    }
    
}
