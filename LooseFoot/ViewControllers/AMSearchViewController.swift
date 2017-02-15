//
//  AMSearchViewController.swift
//  LooseFoot
//
//  Created by Alexander McArdle on 2/10/17.
//  Copyright © 2017 Alexander McArdle. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import Toaster
import Popover

class AMSearchViewController: ASViewController<ASTableNode> {
    
    let tableNode = ASTableNode()
    var subreddits: [AMSubreddit]?
    var redditLoader: RedditLoader?
    var popover: Popover?
    var subredditViewController: AMSubredditViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(redditLoader)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(redditLoader)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableNode.view.frame = self.view.frame
        print(redditLoader)
        
    }
    
    init(rl: RedditLoader) {
        redditLoader = rl
        super.init(node: tableNode)
        
        
        
        //self.redditLoader = redditLoader
        
        //parent as! AMSubredditViewController
        
        tableNode.backgroundColor = UIColor.flatGrayDark
        tableNode.delegate = self
        tableNode.dataSource = self
        tableNode.view.separatorStyle = .none
        tableNode.frame = self.view.bounds
        
        self.redditLoader?.searchDelegate = self
        
        if(self.redditLoader?.subreddits.count == 0 ) {
            Toast(text: "Fetching subs").show()
            self.redditLoader?.getUserSubreddits(user: (self.redditLoader?.names[0])!)
        } else {
            print("found subs")
            subreddits = self.redditLoader?.subreddits
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //override func
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AMSearchViewController: RedditLoaderDelegate {
    func redditLoaderDidUpdateLinks(redditLoader: RedditLoader) {
        //adapter.performUpdates(animated: true)
        //print("donezo")
        //tableNode.reloadData()
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
    }
    func redditLoaderDidUpdateSubreddits(redditLoader: RedditLoader) {
        print("donezo subreddits")
        
        tableNode.reloadData()
    }
}

extension AMSearchViewController: ASTableDataSource {
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        //return layoutExamples.count
        let countOfSubs = redditLoader?.subreddits.count ?? 0
        print("s: \(section) count: \(countOfSubs)")
        return countOfSubs
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let tempSub = redditLoader?.subreddits[indexPath.row]
        return AMSearchCellNode(sub: tempSub!)
    }
}

extension AMSearchViewController: ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        //let layoutExampleType = (tableNode.nodeForRow(at: indexPath) as! AMLinkCellNode).layoutExampleType
//        let detail = AMCommentsViewController(link: redditLoader.links[indexPath.row], loader: redditLoader)
//        self.navigationController?.pushViewController(detail, animated: true)
        print("touched \(indexPath.row) \(redditLoader?.subreddits[indexPath.row].s.displayName)")
        subredditViewController?.goToSubreddit((redditLoader?.subreddits[indexPath.row])!)
        popover?.dismiss()
    }
}

