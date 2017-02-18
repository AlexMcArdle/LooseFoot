//
//  CommentsViewController.swift
//  LooseFoot
//
//  Created by Alexander McArdle on 2/8/17.
//  Copyright © 2017 Alexander McArdle. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import reddift

class AMCommentsViewController: ASViewController<ASTableNode> {
    let tableNode = ASTableNode()
    
    var redditLoader: RedditLoader? = nil
    var link: AMLink? = nil
    
    var comments: [AMComment]?
    
    init(link: AMLink, loader: RedditLoader) {
        
        self.link = link
        self.redditLoader = loader
        super.init(node: tableNode)
        
        tableNode.backgroundColor = .flatBlackDark
        
        self.title = "Comments"

        tableNode.delegate = self
        tableNode.dataSource = self
        tableNode.view.separatorStyle = .none
        
        redditLoader?.delegate = self
        redditLoader?.getComments(link: link)
    }
    
    init(sectionOfComments: [AMComment]) {
        self.comments = sectionOfComments
        super.init(node: tableNode)
        
        tableNode.backgroundColor = .flatBlackDark
        tableNode.delegate = self
        tableNode.dataSource = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        if let indexPath = tableNode.indexPathForSelectedRow {
//            tableNode.deselectRow(at: indexPath, animated: true)
//        }
    }
}

extension AMCommentsViewController: RedditLoaderDelegate {
    func redditLoaderDidUpdateLinks(redditLoader: RedditLoader) {
        //adapter.performUpdates(animated: true)
//        print("donezo")
//        tableNode.reloadData()
    }
    func redditLoaderDidSelectLink(redditLoader: RedditLoader) {
        //adapter.reloadObjects(redditLoader.posts)
    }
    func redditLoaderDidVote(redditLoader: RedditLoader, link: AMLink) {
        //adapter.reloadObjects(redditLoader.posts)
    }
    func redditLoaderDidReturnToPosts(redditLoader: RedditLoader) {
        //adapter.reloadObjects(redditLoader.posts)
    }
    func redditLoaderDidUpdateComments(redditLoader: RedditLoader, comments: [AMComment]) {
        //adapter.performUpdates(animated: true)
        self.comments = comments
        print("didUpdateComments")
        tableNode.reloadData()
    }
    func redditLoaderDidUpdateSubreddits(redditLoader: RedditLoader) {
        // dont do anything yet
    }
}

extension AMCommentsViewController: ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        //return comments?.count ?? 0
        return 2
    }
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        if(section == 0)
        {
            return 1
        } else {
            return comments?.count ?? 0
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        switch indexPath.section {
        case 0:
            return AMCommentHeaderCellNode(link: link!, loader: self.redditLoader!)
        case 1:
            return AMCommentCellNode(comment: comments![indexPath.row], link: link!)
        default:
            return ASCellNode()
        }
    }
}

extension AMCommentsViewController: ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
//        let layoutExampleType = (tableNode.nodeForRow(at: indexPath) as! OverviewCellNode).layoutExampleType
//        let detail = LayoutExampleViewController(layoutExampleType: layoutExampleType)
//        self.navigationController?.pushViewController(detail, animated: true)
        print("section: \(indexPath.section) row: \(indexPath.row)")
    }
}
