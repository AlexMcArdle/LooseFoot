//
//  AMCommentCellNode.swift
//  LooseFoot
//
//  Created by Alexander McArdle on 2/8/17.
//  Copyright © 2017 Alexander McArdle. All rights reserved.
//

import AsyncDisplayKit
import ChameleonFramework
import FontAwesome_swift
import UIColor_Hex_Swift
import reddift
import SwiftyMarkdown
import BonMot

class AMCommentCellNode: ASCellNode {
    
    let comment: AMComment
    let link: AMLink
    
    fileprivate let commentTextNode = ASTextNode()
    fileprivate let authorNode = ASTextNode()
    //fileprivate let imageNode = ASNetworkImageNode()
    fileprivate let pointsNode = ASTextNode()
    //fileprivate let commentsNode = ASTextNode()
    //fileprivate let subredditNode = ASTextNode()
    fileprivate let authorFlairNode = ASTextNode()
    fileprivate let commentFlairNode = ASTextNode()
    fileprivate let goldNode = ASTextNode()
    fileprivate let distinguishedNode = ASTextNode()
    fileprivate let stickyNode = ASTextNode()
    fileprivate let controversyNode = ASTextNode()
    fileprivate let borderNode = ASDisplayNode()
    
    let authorFlairBackground = ASDisplayNode()
    var authorFlairOverlay: ASBackgroundLayoutSpec?
    let topRowStackSpec = ASStackLayoutSpec.horizontal()
    let horizontalStackSpec = ASStackLayoutSpec.horizontal()
    let borderOverlaySpec = ASOverlayLayoutSpec()
    let verticalStackSpec = ASStackLayoutSpec.vertical()
    let borderStackSpec = ASStackLayoutSpec.horizontal()
    let ratioSpec = ASRatioLayoutSpec()

    var topRowChildren: [ASLayoutElement]?

    var isMinimized: Bool
    
    let border = CALayer()
    
    let linkStyle = StringStyle(
        .color(.flatSkyBlue))
    let emStyle = StringStyle(
        .color(.gray))
    let baseStyle = StringStyle(
        .font(UIFont.systemFont(ofSize: 12)),
        .adapt(.control),
        .lineHeightMultiple(1.0),
        .color(.flatWhite))
    let boldStyle = StringStyle(
        .font(UIFont.boldSystemFont(ofSize: 12)),
        .adapt(.control))
    var rules: [XMLStyleRule] = []
    
    var commentChildren: [ASLayoutElement]? = []
    
    override func didLoad() {
        super.didLoad()
        // Add Border
//        border.backgroundColor = UIColor.flatGrayDark.cgColor
//        border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 1.0)
//        print(self.calculatedSize.width)
//        self.layer.addSublayer(border)
    }
    
    init(comment: AMComment, link: AMLink) {
        self.comment = comment
        self.isMinimized = false
        self.link = link
        
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
        
        commentChildren = [verticalStackSpec]
        
        checkForReplies()
        
        // Markdown Parser
        rules.append(.style("em", emStyle))
        rules.append(.style("a", linkStyle))
        rules.append(.style("strong", boldStyle))
        commentTextNode.attributedText = markdownParser(comment.c.bodyHtml)

        
        //commentTextNode.attributedText = NSAttributedString.attributedString(string: comment.c.bodyHtml, fontSize: 16, color: .flatWhiteDark)
        
        //subredditNode.attributedText = NSAttributedString.attributedString(string: comment.subreddit, fontSize: 12, color: .flatSkyBlue)
        
//        var color: UIColor
//        if let mark = comment.c.distinguished {
//            switch mark {
//            case "admin":
//                color = .flatRed
//            case "moderator":
//                color = .flatGreen
//            case "special":
//                color = .flatYellowDark
//            default:
//                color = .flatSand
//            }
//        } else { color = .flatSand }
//        if(comment.c.author.lowercased() == link.l.author.lowercased()) {
//            color = .flatSkyBlue
//        }
//        authorNode.attributedText = NSAttributedString.attributedString(string: comment.c.author, fontSize: 12, color: color)
        
        // Author node setup
        // Check for distinguishments (is that a word?)
        topRowChildren = [authorNode]
        let authorColor: UIColor
        if let distinguish = comment.c.distinguished {
            let string: NSAttributedString
            
            switch distinguish {
            case "moderator":
                string = NSAttributedString(string: String.fontAwesomeIcon(name: .shield), attributes:
                    [NSFontAttributeName: UIFont.fontAwesome(ofSize: 12),
                     NSForegroundColorAttributeName: UIColor.flatGreen])
                authorColor = .flatGreen
            case "admin":
                string = NSAttributedString(string: String.fontAwesomeIcon(name: .idBadge), attributes:
                    [NSFontAttributeName: UIFont.fontAwesome(ofSize: 12),
                     NSForegroundColorAttributeName: UIColor.flatRed])
                authorColor = .flatRed
            case "special":
                string = NSAttributedString(string: "S", attributes:
                    [NSFontAttributeName: AppFont(size: 15, bold: true),
                     NSForegroundColorAttributeName: UIColor.flatYellowDark])
                authorColor = .flatYellowDark
            default:
                string = NSAttributedString(string: "")
                authorColor = .flatSand
            }
            
            if(string.string != "") {
                distinguishedNode.attributedText = string
                topRowChildren?.append(distinguishedNode)
            }
        } else { authorColor = .flatSand }
        authorNode.attributedText = NSAttributedString.attributedString(string: comment.c.author, fontSize: 12, color: authorColor)

        
        var scoreString = String(comment.c.score)
        if(comment.c.score >= 1000) {
            scoreString = comment.c.score.getFancyNumber()!
        }
        pointsNode.attributedText = NSAttributedString.attributedString(string: scoreString, fontSize: 12, color: .orange)
        topRowChildren?.append(pointsNode)
        
        // Check for Controversial
        if(comment.c.controversiality > 0) {
            let mutableString = NSMutableAttributedString(attributedString: pointsNode.attributedText!)
            
            mutableString.append(NSAttributedString(string: "†", attributes:
                [NSFontAttributeName: AppFont(size: 12),
                 NSForegroundColorAttributeName: UIColor.flatRedDark]))
            pointsNode.attributedText = mutableString.attributedString()
            //topRowChildren?.append(controversyNode)
        }
        
        //commentsNode.attributedText = NSAttributedString.attributedString(string: String(post.numComments), fontSize: 12, color: .flatGray)
        
        // Check for Author Flair
        if(comment.c.authorFlairText != "") {
            let flairString = comment.c.authorFlairText.checkForBrackets()
            authorFlairNode.attributedText = NSAttributedString.attributedString(string: flairString, fontSize: 8, color: .flatWhite)
            authorFlairNode.textContainerInset = UIEdgeInsets(top: 0, left: 2, bottom: 1, right: 2)
            //            authorFlairNode.borderWidth = 1.0
            //            authorFlairNode.borderColor = UIColor.flatGrayDark.cgColor
            //            authorFlairNode.cornerRadius = 3.0
            authorFlairNode.truncationMode = .byTruncatingTail
            authorFlairNode.maximumNumberOfLines = 1
            
            authorFlairBackground.clipsToBounds = true
            authorFlairBackground.borderColor = UIColor.flatGrayDark.cgColor
            authorFlairBackground.borderWidth = 5.0
            authorFlairBackground.cornerRadius = 5
            authorFlairBackground.backgroundColor = .flatGrayDark
            
            authorFlairOverlay = ASBackgroundLayoutSpec(child: authorFlairNode, background: authorFlairBackground)
            
            topRowChildren?.append(authorFlairOverlay!)
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
        
        // Check for Sticky
        if(comment.c.stickied) {
            stickyNode.attributedText = NSAttributedString(string: String.fontAwesomeIcon(name: .thumbTack), attributes:
                [NSFontAttributeName: UIFont.fontAwesome(ofSize: 12),
                 NSForegroundColorAttributeName: UIColor.flatSkyBlue])
            topRowChildren?.insert(stickyNode, at: 0)
        }
        
        // Add border
        //addBorder()
        borderNode.backgroundColor = .flatWhite
    }
    
    func addBorder() {
//        borderNode.layer.shadowColor = UIColor.white.cgColor
//        borderNode.layer.shadowOpacity = 0.75
//        debugPrint(self.frame)
//        borderNode.layer.shadowOffset = CGSize(width: 0, height: -self.frame.height)
//        borderNode.layer.shadowRadius = 10
//        borderNode.layer.shadowPath = UIBezierPath(rect: self.frame).cgPath
        borderNode.setNeedsLayout()
    }
    
    func checkForReplies() {
        if(self.comment.c.replies.children.count > 0) {
            var tempComments: [Comment] = []
            tempComments.append(contentsOf: self.comment.c.replies.children.flatMap{$0 as? Comment})
            var newComments: [AMComment] = []
            for newComment in tempComments {
                newComments.append(AMComment(comment: newComment))
                commentChildren?.append(AMCommentCellNode(comment: AMComment(comment: newComment), link: link))
            }
            //print("comments: \(self.comment.c.replies.children.count)")
            
        }
    }
    func cellSelected() {
        print("cellSelected author: \(comment.c.author)")
        debugPrint(self.calculatedSize)
        if(isMinimized) {
            checkForReplies()
            isMinimized = false
            commentTextNode.attributedText = markdownParser(comment.c.bodyHtml)
            self.setNeedsLayout()
        } else {
            commentChildren = [verticalStackSpec]
            isMinimized = true
            commentTextNode.attributedText = NSAttributedString(string: "")
            self.setNeedsLayout()
        }
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
        
        topRowStackSpec.alignItems = .center
        topRowStackSpec.spacing = 5.0
        topRowStackSpec.children = topRowChildren
        topRowStackSpec.style.flexShrink = 1.0
        topRowStackSpec.style.flexGrow = 1.0
        
        verticalStackSpec.alignItems = .start
        verticalStackSpec.spacing = 5.0
        verticalStackSpec.children = [topRowStackSpec, commentTextNode]
        verticalStackSpec.style.flexShrink = 1.0
        verticalStackSpec.style.flexGrow = 1.0
        
        //let myframe = self.bounds
        //borderNode.style.preferredSize = CGSize(width: 1, height: self.frame.height)
        debugPrint("calculatedSize: \(self.calculatedSize)")
        borderNode.style.flexGrow = 1.0
        borderNode.style.flexShrink = 1.0
        //borderNode.borderWidth = 1.0
        //borderNode.borderColor = UIColor.flatWhite.cgColor
        
        middleStackSpec.alignItems = .start
        middleStackSpec.spacing = 0.0
        middleStackSpec.children = commentChildren
        middleStackSpec.style.flexShrink = 1.0
        middleStackSpec.style.flexGrow = 0.0
        
        let centerSpec = ASAbsoluteLayoutSpec(sizing: .sizeToFit, children: [borderStackSpec])

        ratioSpec.ratio = 0.1
        ratioSpec.setChild(borderNode, at: 0)
        
        borderStackSpec.alignItems = .start
        borderStackSpec.spacing = 5.0
        borderStackSpec.children = [ratioSpec]
        borderStackSpec.style.flexShrink = 1.0
        borderStackSpec.style.flexGrow = 1.0
        
        
        horizontalStackSpec.alignItems = .start
        horizontalStackSpec.spacing = 5.0
        horizontalStackSpec.children = [centerSpec, middleStackSpec]
        horizontalStackSpec.style.flexGrow = 1.0
        horizontalStackSpec.style.flexShrink = 1.0
                
        //borderOverlaySpec.overlay = borderStackSpec
        //borderOverlaySpec.setChild(horizontalStackSpec, at: 0)
        
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
        
        
        
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5), child: horizontalStackSpec)
    }
    
    private func markdownParser(_ string: String) -> NSAttributedString {
        do {
            let options: XMLParsingOptions = XMLParsingOptions()
            let attributedString = try NSAttributedString.composed(ofXML: comment.c.bodyHtml, baseStyle: baseStyle, rules: rules, options: options)
            return attributedString
        } catch {
            print("error: \(comment.c.bodyHtml)")
            return comment.c.body.styled(with: baseStyle)
        }
    }
}

extension ASLayoutElement {
    static func ==(lhs: ASLayoutElement, rhs: ASLayoutElement) -> Bool {
        return lhs === rhs
    }
}
