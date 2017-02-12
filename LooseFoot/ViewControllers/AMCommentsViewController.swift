//
//  CommentsViewController.swift
//  LooseFoot
//
//  Created by Alexander McArdle on 2/8/17.
//  Copyright © 2017 Alexander McArdle. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class AMCommentsViewController: ASViewController<ASTableNode> {
    let tableNode = ASTableNode()
    
    let redditLoader: RedditLoader
    let link: AMLink
    
    var commments: [AMComment]?
    
    init(link: AMLink, loader: RedditLoader) {
        
        self.link = link
        self.redditLoader = loader
        super.init(node: tableNode)
        
        tableNode.backgroundColor = .flatBlackDark
        
        self.title = "Comments"

        tableNode.delegate = self
        tableNode.dataSource = self
        
        redditLoader.delegate = self
        redditLoader.getComments(link: link)
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
    func redditLoaderDidVote(redditLoader: RedditLoader) {
        //adapter.reloadObjects(redditLoader.posts)
    }
    func redditLoaderDidReturnToPosts(redditLoader: RedditLoader) {
        //adapter.reloadObjects(redditLoader.posts)
    }
    func redditLoaderDidUpdateComments(redditLoader: RedditLoader, comments: [AMComment]) {
        //adapter.performUpdates(animated: true)
        self.commments = comments
        print("didUpdateComments")
        tableNode.reloadData()
    }
    func redditLoaderDidUpdateSubreddits(redditLoader: RedditLoader) {
        // dont do anything yet
    }
}

extension AMCommentsViewController: ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return commments?.count ?? 0
    }
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        return AMCommentCellNode(comment: commments![indexPath.section])
    }
}

extension AMCommentsViewController: ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
//        let layoutExampleType = (tableNode.nodeForRow(at: indexPath) as! OverviewCellNode).layoutExampleType
//        let detail = LayoutExampleViewController(layoutExampleType: layoutExampleType)
//        self.navigationController?.pushViewController(detail, animated: true)
    }
}
