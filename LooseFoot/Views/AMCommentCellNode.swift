//
//  AMCommentCellNode.swift
//  LooseFoot
//
//  Created by Alexander McArdle on 2/8/17.
//  Copyright © 2017 Alexander McArdle. All rights reserved.
//

//
//  AMLinkCellNode.swift
//  LooseFoot
//
//  Created by Alexander McArdle on 2/6/17.
//  Copyright © 2017 Alexander McArdle. All rights reserved.
//

import AsyncDisplayKit
import ChameleonFramework
import FontAwesome_swift
import UIColor_Hex_Swift
import reddift
import SwiftyMarkdown

class AMCommentCellNode: ASCellNode {
    
    let comment: AMComment
    
    fileprivate let commentTextNode = ASTextNode()
    fileprivate let authorNode = ASTextNode()
    //fileprivate let imageNode = ASNetworkImageNode()
    fileprivate let pointsNode = ASTextNode()
    //fileprivate let commentsNode = ASTextNode()
    //fileprivate let subredditNode = ASTextNode()
    //fileprivate let authorFlairNode = ASTextNode()
    fileprivate let commentFlairNode = ASTextNode()
    fileprivate let goldNode = ASTextNode()
    
    let verticleStackSpec = ASStackLayoutSpec.vertical()
    
    var commentChildren: [ASLayoutElement]? = []
    
    init(comment: AMComment) {
        self.comment = comment
        
        // init the super
        super.init()
        
        self.automaticallyManagesSubnodes = true
        backgroundColor = .flatBlack
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(cellSelected))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(recognizer)
        
//        imageNode.shouldRenderProgressImages = true
//        if(post.thumbnail.hasPrefix("http")) {
//            imageNode.url = URL(string: post.thumbnail)
//        }
        
        commentChildren = [verticleStackSpec]
        
        // Check for replies
        if(self.comment.c.replies.children.count > 0) {
            var tempComments: [Comment] = []
            tempComments.append(contentsOf: self.comment.c.replies.children.flatMap{$0 as? Comment})
            var newComments: [AMComment] = []
            for newComment in tempComments {
                newComments.append(AMComment(comment: newComment))
                commentChildren?.append(AMCommentCellNode(comment: AMComment(comment: newComment)))
            }
            print("comments: \(self.comment.c.replies.children.count)")
            
        }
        
        // Markdown Parser
        let md = SwiftyMarkdown(string: comment.c.body)
        md.h1.color = .flatWhite
        md.h2.color = .flatWhite
        md.h3.color = .flatWhite
        md.h4.color = .flatWhite
        md.h5.color = .flatWhite
        md.h6.color = .flatWhite
        md.body.color = .flatWhiteDark
        md.link.color = .flatSkyBlue
        let mystring: NSMutableAttributedString = NSMutableAttributedString(attributedString: md.attributedString())
        mystring.addAttribute(NSFontAttributeName, value: AppFont(size: 12, bold: false), range: NSRange(location: 0, length: mystring.length - 1))
        commentTextNode.attributedText = mystring
        
        //commentTextNode.attributedText = NSAttributedString.attributedString(string: comment.c.bodyHtml, fontSize: 16, color: .flatWhiteDark)
        
        //subredditNode.attributedText = NSAttributedString.attributedString(string: comment.subreddit, fontSize: 12, color: .flatSkyBlue)
        authorNode.attributedText = NSAttributedString.attributedString(string: comment.c.author, fontSize: 12, color: .flatPinkDark)
        
        var scoreString = String(comment.c.score)
        if(comment.c.score >= 1000) {
            scoreString = comment.c.score.getFancyNumber()!
        }
        pointsNode.attributedText = NSAttributedString.attributedString(string: scoreString, fontSize: 12, color: .orange)
        
        //commentsNode.attributedText = NSAttributedString.attributedString(string: String(post.numComments), fontSize: 12, color: .flatGray)
        
        // Check for Comment Flair
        if(comment.c.authorFlairText != "") {
            let flairString = comment.c.authorFlairText.checkForBrackets()
            commentFlairNode.attributedText = NSAttributedString.attributedString(string: flairString, fontSize: 12, color: .flatMintDark)
            commentFlairNode.textContainerInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
            commentFlairNode.borderWidth = 1.0
            commentFlairNode.borderColor = UIColor.flatMintDark.cgColor
            commentFlairNode.cornerRadius = 3.0
        }
        
        if(comment.c.gilded > 0) {
            let goldSymbol = NSMutableAttributedString(string: String.fontAwesomeIcon(name: .star), attributes: [NSFontAttributeName: UIFont.fontAwesome(ofSize: 12)])
            let text: NSMutableAttributedString = goldSymbol
            
            // Add count if more than one (disabled)
            //if(post.gilded > 1) {
            let count = NSMutableAttributedString(string: "x\(comment.c.gilded)", attributes: [NSFontAttributeName: AppFont(size: 12, bold: false)])
            text.append(count)
            //}
            
            text.addAttribute(NSForegroundColorAttributeName, value: UIColor(hexString: "FFD700")!, range: NSRange(location: 0, length: text.length))
            goldNode.attributedText = text as NSAttributedString
        }
    }
    
    func cellSelected() {
        print("cellSelected author: \(comment.c.author)")
        let textCell = ASTextCellNode()
        textCell.text = "minimized"
        commentChildren = [verticleStackSpec]
        self.setNeedsLayout()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        //debugPrint(constrainedSize)
        let middleStackSpec = ASStackLayoutSpec.vertical()
//        let horizontalStackSpec = ASStackLayoutSpec.horizontal()
//        let rightSideStackSpec = ASStackLayoutSpec.vertical()
//        let topRowStackSpec = ASStackLayoutSpec.horizontal()
//        let bottomRowStackSpec = ASStackLayoutSpec.horizontal()
        
//        if(post.thumbnail.hasPrefix("http")) {
//            let imageSize = CGSize(width: 60, height: 60)
//            imageNode.style.preferredSize = imageSize
//            imageNode.imageModificationBlock = { image in
//                return image.makeRoundedImage(size: imageSize, borderWidth: 1, color: .flatOrange)
//            }
//        } else {
//            imageNode.style.preferredSize = CGSize(width: 0, height: 0)
//        }
        
//        topRowStackSpec.alignItems = .start
//        topRowStackSpec.spacing = 5.0
//        topRowStackSpec.children = [subredditNode, linkFlairNode, goldNode]
//        topRowStackSpec.style.flexShrink = 1.0
//        topRowStackSpec.style.flexGrow = 1.0
        
        verticleStackSpec.alignItems = .start
        verticleStackSpec.spacing = 5.0
        verticleStackSpec.children = [authorNode, commentTextNode]
        verticleStackSpec.style.flexShrink = 1.0
        verticleStackSpec.style.flexGrow = 1.0
                
        middleStackSpec.alignItems = .start
        middleStackSpec.spacing = 5.0
        middleStackSpec.children = commentChildren
        middleStackSpec.style.flexShrink = 1.0
        middleStackSpec.style.flexGrow = 1.0
        
//        bottomRowStackSpec.alignItems = .start
//        bottomRowStackSpec.spacing = 5.0
//        bottomRowStackSpec.children = [authorNode, commentFlairNode]
//        bottomRowStackSpec.style.flexShrink = 1.0
//        bottomRowStackSpec.style.flexGrow = 1.0
//        
//        rightSideStackSpec.alignItems = .center
//        rightSideStackSpec.spacing = 5.0
//        rightSideStackSpec.children = [pointsNode, commentsNode]
//        
//        horizontalStackSpec.alignItems = .start
//        horizontalStackSpec.spacing = 5.0
//        horizontalStackSpec.children = [imageNode, middleStackSpec, rightSideStackSpec]
        
        
        
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5), child: middleStackSpec)
    }
    
}
