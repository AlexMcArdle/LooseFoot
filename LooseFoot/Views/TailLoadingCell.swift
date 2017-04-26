//
//  TailLoadingCell.swift
//  LooseFoot
//
//  Created by Alexander McArdle on 2/6/17.
//  Copyright © 2017 Alexander McArdle. All rights reserved.
//

import AsyncDisplayKit
import UIKit

final class TailLoadingCellNode: ASCellNode {
    let spinner = SpinnerNode()
    let text = ASTextNode()
    
    override init() {
        super.init()
        
        addSubnode(text)
        text.attributedText = NSAttributedString(
            string: "Loading…",
            attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 12),
                NSForegroundColorAttributeName: UIColor.lightGray,
                NSKernAttributeName: -0.3
            ])
        addSubnode(spinner)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        return ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 16,
            justifyContent: .center,
            alignItems: .center,
            children: [ text, spinner ])
    }
}

final class SpinnerNode: ASDisplayNode {
    var activityIndicatorView: UIActivityIndicatorView {
        return view as! UIActivityIndicatorView
    }
    
    convenience override init() {
        
        //super.init(viewBlock: {})
        self.init(viewBlock: { UIActivityIndicatorView(activityIndicatorStyle: .gray) }, didLoad: nil)
        
        // Set spinner node to default size of the activitiy indicator view
        self.style.preferredSize = CGSize(width: 20.0, height: 20.0)
    }
    
    override func didLoad() {
        super.didLoad()
        
        activityIndicatorView.startAnimating()
    }
}
