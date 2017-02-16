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
import Toaster

class AMLinkCellNode: ASCellNode {
    
    let link: AMLink
    let redditLoader: RedditLoader
    
    fileprivate let titleNode = ASTextNode()
    fileprivate let authorNode = ASTextNode()
    fileprivate let imageNode = ASNetworkImageNode()
    fileprivate let pointsNode = ASTextNode()
    fileprivate let commentsNode = ASTextNode()
    fileprivate let subredditNode = ASTextNode()
    fileprivate let authorFlairNode = ASTextNode()
    fileprivate let linkFlairNode = ASTextNode()
    fileprivate let goldNode = ASTextNode()
    fileprivate let nsfwNode = ASTextNode()
    fileprivate let spoilerNode = ASTextNode()
    fileprivate let voteNode = ASTextNode()
    fileprivate let distinguishedNode = ASTextNode()
    fileprivate let stickyNode = ASTextNode()
    let middleStackSpec = ASStackLayoutSpec.vertical()
    let horizontalStackSpec = ASStackLayoutSpec.horizontal()
    let rightSideStackSpec = ASStackLayoutSpec.vertical()
    let leftSideStackSpec = ASStackLayoutSpec.vertical()
    let topRowStackSpec = ASStackLayoutSpec.horizontal()
    let bottomRowStackSpec = ASStackLayoutSpec.horizontal()
    
    let myView = UIView()
    let pointerView = UIView()
    
    let linkFlairBackground = ASDisplayNode()
    let authorFlairBackground = ASDisplayNode()
    
    var linkFlairOverlay: ASBackgroundLayoutSpec?
    var authorFlairOverlay: ASBackgroundLayoutSpec?
    
    var topRowChildren: [ASLayoutElement]?
    var bottomRowChildren: [ASLayoutElement]?
    var leftSideChildren: [ASLayoutElement]?
    var horizontalStackChildren: [ASLayoutElement]?
    
    func followSwipeGesture(_ gestureRecognizer: UISwipeGestureRecognizer) {
        if gestureRecognizer.direction == .left {
            Toast(text: "swipe left: \(link.l.author)").show()
            redditLoader.vote(link: self.link, direction: .up)
        } else if gestureRecognizer.direction == .right {
            Toast(text: "swipe right: \(link.l.author)").show()
            redditLoader.vote(link: self.link, direction: .down)
        }
    }
    
    func holdGesture(_ gestureRecognizer: UILongPressGestureRecognizer) {
        let location = gestureRecognizer.location(in: owningNode?.view)
        let state = gestureRecognizer.state
        if(gestureRecognizer.state == .began) {
            print("began")
            
            myView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
            
            let subView1 = UIView()
            subView1.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            subView1.backgroundColor = .flatRed
            let subView2 = UIView()
            subView2.frame = CGRect(x: 0, y: 100, width: 50, height: 50)
            subView2.backgroundColor = .flatYellow
            let subView3 = UIView()
            subView3.frame = CGRect(x: 100, y: 0, width: 50, height: 50)
            subView3.backgroundColor = .flatSkyBlue
            let subView4 = UIView()
            subView4.frame = CGRect(x: 100, y: 100, width: 50, height: 50)
            subView4.backgroundColor = .flatOrange
            
            pointerView.frame = CGRect(x: 90, y: 90, width: 20, height: 20)
            pointerView.backgroundColor = .flatGreen
            
            myView.center = CGPoint(x: location.x, y: location.y)
            myView.backgroundColor = .clear
            
            myView.addSubview(subView1)
            myView.addSubview(subView2)
            myView.addSubview(subView3)
            myView.addSubview(subView4)
            myView.addSubview(pointerView)
            owningNode?.view.addSubview(myView)
        } else if(gestureRecognizer.state == .changed) {
            //myView.center = CGPoint(x: location.x, y: location.y - 50)
            pointerView.center = gestureRecognizer.location(in: myView)
            for subview in myView.subviews {
                let pointerCenter = pointerView.center
                let subViewCenter = subview.center
                
                let xDist = pointerCenter.x - subViewCenter.x
                let yDist = pointerCenter.y - subViewCenter.y
                let distance = sqrt((xDist * xDist) + (yDist * yDist))
                if(distance <= 40.0) {
                    pointerView.center = subview.center
                }
            }
        } else {
            var distances: [CGFloat] = []
            for subview in myView.subviews {
                if(subview == pointerView) { continue }
                let pointerCenter = pointerView.center
                let subViewCenter = subview.center
                
                let xDist = pointerCenter.x - subViewCenter.x
                let yDist = pointerCenter.y - subViewCenter.y
                let distance = sqrt((xDist * xDist) + (yDist * yDist))
                print("distance: \(distance)")
                if(distance <= 15.0) {
                    print("selected: \(myView.subviews.index(of: subview)!)")
                }
            }
            
            pointerView.removeFromSuperview()
            for subview in myView.subviews {
                subview.removeFromSuperview()
            }
            myView.removeFromSuperview()
        }
    }
//    func panGesture(_ panRecognizer: UIPanGestureRecognizer) {
//        if panRecognizer.state == .began || panRecognizer.state == .changed {
//            let translation = panRecognizer.translation(in: owningNode?.view)
//            panRecognizer.view?.center = CGPoint(x: panRecognizer.view!.center.x + translation.x, y: panRecognizer.view!.center.y)
//            panRecognizer.setTranslation(.zero, in: owningNode?.view)
//        } else {
//            let currentPos = panRecognizer.view!.center
//            let parentPos = owningNode!.view.center
//            let ratio = currentPos.x / parentPos.x
//            if (ratio <= 0.75) {
//                print("left")
//                cellSwipedLeft()
//            } else if (ratio >= 1.25) {
//                print("right")
//                cellSwipedRight()
//            }
//            panRecognizer.view?.center = CGPoint(x: (owningNode?.view.center.x)!, y: panRecognizer.view!.center.y)
//            panRecognizer.setTranslation(.zero, in: owningNode?.view)
//        }
//        
//    }
    
    func addTouchRecognizers() {
        self.view.isUserInteractionEnabled = true

        // Left Swipe
        let leftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(followSwipeGesture(_:)))
        leftRecognizer.direction = .left
        self.view.addGestureRecognizer(leftRecognizer)
        
        // Right Swipe
        let rightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(followSwipeGesture(_:)))
        rightRecognizer.direction = .right
        self.view.addGestureRecognizer(rightRecognizer)
        
        // Hold Gesture
        let holdRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(holdGesture(_:)))
        //holdRecognizer.numberOfTapsRequired = 1
        //holdRecognizer.numberOfTouchesRequired = 1
        //holdRecognizer.allowableMovement = 10.0
        self.view.addGestureRecognizer(holdRecognizer)
        
        // Pan gesture
        //let pangGesture = UIGestureRecognizer(target: self, action: #selector(panGesture2(_:)))
//        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
//        panRecognizer.maximumNumberOfTouches = 1
//        panRecognizer.minimumNumberOfTouches = 1
//        
//        self.view.addGestureRecognizer(panRecognizer)
    }

    init(link: AMLink, loader: RedditLoader) {
        self.link = link
        self.redditLoader = loader

        // init the super
        super.init()
        
        addTouchRecognizers()
        
        topRowChildren = [subredditNode]
        bottomRowChildren = [authorNode]
        leftSideChildren = [imageNode]
        horizontalStackChildren = [middleStackSpec, rightSideStackSpec]
        
        self.automaticallyManagesSubnodes = true
        backgroundColor = .flatBlack
        
        
        // Check for vote
        switch link.l.likes {
        case .down:
            let text = NSMutableAttributedString(string: String.fontAwesomeIcon(name: .arrowDown), attributes:
                [NSFontAttributeName: UIFont.fontAwesome(ofSize: 15),
                 NSForegroundColorAttributeName: UIColor.flatSkyBlue])
            voteNode.attributedText = text
        case .up:
            let text = NSMutableAttributedString(string: String.fontAwesomeIcon(name: .arrowUp), attributes:
                [NSFontAttributeName: UIFont.fontAwesome(ofSize: 15),
                 NSForegroundColorAttributeName: UIColor.orange])
            voteNode.attributedText = text
        case .none:
            break
        }
        
        // Check for Image
        imageNode.shouldRenderProgressImages = true
        if(link.l.thumbnail.hasPrefix("http")) {
            imageNode.url = URL(string: link.l.thumbnail)
            
            horizontalStackChildren?.insert(imageNode, at: 0)
        }
        
        titleNode.attributedText = NSAttributedString.attributedString(string: link.l.title, fontSize: 16, color: .flatWhiteDark)
        subredditNode.attributedText = NSAttributedString.attributedString(string: link.l.subreddit, fontSize: 12, color: UIColor.flatSkyBlue)
        
        
        // Author node setup
        // Check for distinguishments (is that a word?)
        let authorColor: UIColor
        if let distinguish = link.l.distinguished {
            let string: NSAttributedString
            
            switch distinguish {
            case "moderator":
                string = NSAttributedString(string: "M", attributes:
                    [NSFontAttributeName: AppFont(size: 15, bold: true),
                     NSForegroundColorAttributeName: UIColor.flatGreen])
                authorColor = .flatGreen
            case "admin":
                string = NSAttributedString(string: "A", attributes:
                    [NSFontAttributeName: AppFont(size: 15, bold: true),
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
                bottomRowChildren?.append(distinguishedNode)
            }
        } else { authorColor = .flatSand }
        authorNode.attributedText = NSAttributedString.attributedString(string: link.l.author, fontSize: 12, color: authorColor)
        
        
        var scoreString = String(link.l.score)
        if(link.l.score >= 1000) {
            scoreString = link.l.score.getFancyNumber()!
        }
        pointsNode.attributedText = NSAttributedString.attributedString(string: scoreString, fontSize: 12, color: .orange)
        
        commentsNode.attributedText = NSAttributedString.attributedString(string: String(link.l.numComments), fontSize: 12, color: .flatGray)
        
        // Check for Link Flair
        if(link.l.linkFlairText != "") {
            let flairString = link.l.linkFlairText.checkForBrackets()
            linkFlairNode.attributedText = NSAttributedString.attributedString(string: flairString, fontSize: 8, color: .flatWhite)
            linkFlairNode.textContainerInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
            //linkFlairNode.borderWidth = 1.0
            //linkFlairNode.borderColor = UIColor.flatWhiteDark.cgColor
            //linkFlairNode.cornerRadius = 10.0
            linkFlairNode.truncationMode = .byTruncatingTail
            linkFlairNode.maximumNumberOfLines = 1
            
            linkFlairBackground.clipsToBounds = true
            linkFlairBackground.borderColor = UIColor.flatGrayDark.cgColor
            linkFlairBackground.borderWidth = 5.0
            linkFlairBackground.cornerRadius = 5
            linkFlairBackground.backgroundColor = .flatGrayDark
            
            linkFlairOverlay = ASBackgroundLayoutSpec(child: linkFlairNode, background: linkFlairBackground)
            
            topRowChildren?.append(linkFlairOverlay!)
        }
        
        // Check for Author Flair
        if(link.l.authorFlairText != "") {
            let flairString = link.l.authorFlairText.checkForBrackets()
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
            
            bottomRowChildren?.append(authorFlairOverlay!)
        }
        
        // Check for NSFW
        if(link.l.over18) {
            nsfwNode.attributedText = NSAttributedString.attributedString(string: "NSFW", fontSize: 10, color: .flatRedDark)
            nsfwNode.textContainerInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
            nsfwNode.borderWidth = 1.0
            nsfwNode.borderColor = UIColor.flatRedDark.cgColor
            nsfwNode.cornerRadius = 3.0
            
            topRowChildren?.insert(nsfwNode, at: 0)
        }
        // Check for Spoiler
        if(link.l.spoiler) {
            spoilerNode.attributedText = NSAttributedString.attributedString(string: "SPOILER", fontSize: 10, color: .flatWhite)
            spoilerNode.textContainerInset = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
            spoilerNode.borderWidth = 1.0
            spoilerNode.borderColor = UIColor.flatWhite.cgColor
            spoilerNode.cornerRadius = 3.0
            
            topRowChildren?.insert(spoilerNode, at: 0)
        }
        
        // Check for Gold
        if(link.l.gilded > 0) {
            //goldNode.attributedText = NSAttributedString.attributedString(string: String(link.l.gilded), fontSize: 12, color: UIColor("#ffd700"))
            let goldSymbol = NSMutableAttributedString(string: String.fontAwesomeIcon(name: .star), attributes: [NSFontAttributeName: UIFont.fontAwesome(ofSize: 12)])
            
            let text: NSMutableAttributedString = goldSymbol
            
            // Add count if more than one (disabled)
            //if(link.l.gilded > 1) {
                let count = NSMutableAttributedString(string: "x\(link.l.gilded)", attributes: [NSFontAttributeName: AppFont(size: 12, bold: false)])
                text.append(count)
            //}
            
            text.addAttribute(NSForegroundColorAttributeName, value: UIColor(hexString: "FFD700")!, range: NSRange(location: 0, length: text.length))
            goldNode.attributedText = text as NSAttributedString
            
            topRowChildren?.append(goldNode)
        }
        
        // Check for Sticky
        if(link.l.stickied) {
            stickyNode.attributedText = NSAttributedString(string: String.fontAwesomeIcon(name: .thumbTack), attributes:
                [NSFontAttributeName: UIFont.fontAwesome(ofSize: 12),
                 NSForegroundColorAttributeName: UIColor.flatSkyBlue])
            topRowChildren?.insert(stickyNode, at: 0)
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        //debugPrint(constrainedSize)
        
        // Make the images pretty
        if(link.l.thumbnail.hasPrefix("http")) {
            let imageSize = CGSize(width: 60, height: 60)
            imageNode.style.preferredSize = imageSize
            imageNode.imageModificationBlock = { image in
                let width: CGFloat
                var color: UIColor? = nil
                if(self.link.l.over18) {
                    width = 5
                    color = UIColor.flatRed
                } else {
                    width = 0
                }
                return image.makeRoundedImage(size: imageSize, borderWidth: width, color: color)
            }
        } else {
            imageNode.style.preferredSize = CGSize(width: 0, height: 0)
        }
        
        let voteNodeSpec = ASRelativeLayoutSpec()
        let pointsNodeSpec = ASRelativeLayoutSpec()
        let commentsNodeSpec = ASRelativeLayoutSpec()
        
        linkFlairNode.style.flexGrow = 1.0
        linkFlairNode.style.flexShrink = 1.0
        authorFlairNode.style.flexGrow = 1.0
        authorFlairNode.style.flexShrink = 1.0
        
        topRowStackSpec.alignItems = .center
        topRowStackSpec.spacing = 5.0
        topRowStackSpec.children = topRowChildren
        topRowStackSpec.style.flexShrink = 1.0
        topRowStackSpec.style.flexGrow = 1.0
        
        middleStackSpec.alignItems = .start
        middleStackSpec.spacing = 5.0
        middleStackSpec.children = [topRowStackSpec, titleNode, bottomRowStackSpec]
        middleStackSpec.style.flexShrink = 1.0
        middleStackSpec.style.flexGrow = 1.0
        
        bottomRowStackSpec.alignItems = .center
        bottomRowStackSpec.spacing = 5.0
        bottomRowStackSpec.children = bottomRowChildren
        bottomRowStackSpec.style.flexShrink = 1.0
        bottomRowStackSpec.style.flexGrow = 1.0
        
        leftSideStackSpec.alignItems = .center
        leftSideStackSpec.spacing = 5.0
        leftSideStackSpec.children = [imageNode]
        
        pointsNodeSpec.verticalPosition = .start
        pointsNodeSpec.children = [pointsNode]
        pointsNodeSpec.horizontalPosition = .start
        
        commentsNodeSpec.verticalPosition = .start
        commentsNodeSpec.children = [commentsNode]
        commentsNodeSpec.horizontalPosition = .start
        
        voteNodeSpec.verticalPosition = .end
        voteNodeSpec.children = [voteNode]
        voteNodeSpec.horizontalPosition = .end

        rightSideStackSpec.alignItems = .center
        rightSideStackSpec.spacing = 5.0
        rightSideStackSpec.children = [pointsNodeSpec, commentsNodeSpec, voteNodeSpec]
        
        horizontalStackSpec.alignItems = .start
        horizontalStackSpec.spacing = 5.0
        horizontalStackSpec.children = horizontalStackChildren
        
        
        
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5), child: horizontalStackSpec)
    }
    
}
