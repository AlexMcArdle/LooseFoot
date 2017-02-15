//
//  AMHomeViewController.swift
//  LooseFoot
//
//  Created by Alexander McArdle on 2/15/17.
//  Copyright © 2017 Alexander McArdle. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class AMHomeViewController: ASViewController<ASDisplayNode> {
    let displayNode = ASDisplayNode()
    
    init() {
        super.init(node: displayNode)
        //let tableNode = AMSubredditViewController( firstRun: true)
        //let newNode = ASDisplayNode(viewBlock: { tableNode.view } )
        //displayNode.layout
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("codererror")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
