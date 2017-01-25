//
//  ViewController.swift
//  LooseFoot
//
//  Created by Alexander McArdle on 1/22/17.
//  Copyright © 2017 Alexander McArdle. All rights reserved.
//

import UIKit
import IGListKit

class SubredditViewController: UIViewController {
    
    lazy var adapter: IGListAdapter = {
        return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    public let redditLoader = RedditLoader()
    
    public var currentMenu = "subreddit"
    public var currentSubreddit = "Frontpage"
    public var currentPost: Post? = nil
    
    var navBar: CustomNavigationBar? = nil
    
    let collectionView: IGListCollectionView = {
        let view = IGListCollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = UIColor.black
        return view
    }()
    
    var titleLabel: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.addSubview(collectionView)
        
        adapter.collectionView = collectionView
        adapter.dataSource = self
        
        redditLoader.delegate = self
        redditLoader.connect()
        
        redditLoader.getSubreddit(sub: currentSubreddit)
        titleLabel = currentSubreddit
        
        setupNavBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    func postTouched() {
        
    }
    
    func setupNavBar() {
        navBar = navigationController?.navigationBar as? CustomNavigationBar
        navBar?.titleButton.addTarget(self, action: #selector(titleTouched), for: .touchUpInside)
        //navBar?.setTitle(title: currentSubreddit)
    }
    
    func titleTouched() {
        //let navBar = navigationController?.navigationBar as! CustomNavigationBar
        switch currentMenu {
        case "comments":
            print("comments")
            redditLoader.posts[0].isExpanded = false
            redditLoader.returnFromComments()
            //navBar.titleButton.setTitle("Frontpage", for: .normal)
            currentMenu = "subreddit"
        default:
            print("some subreddit")
        }
    }
    
}

extension SubredditViewController: IGListAdapterDataSource {

    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        
        var items: [IGListDiffable]
        
        if (currentMenu == "subreddit") {
            
            //Update navBar
            navBar?.setTitle(title: currentSubreddit, backEnabled: false)
           items = redditLoader.posts as [IGListDiffable]
        } else if (currentMenu == "comments") {
            
            // Update NavBar for comments
            navBar?.setTitle(title: "Comments")
            items = redditLoader.posts as [IGListDiffable]
            // ToDo: Insert Post/Comment separater
            items.append(contentsOf: redditLoader.comments as [IGListDiffable])
        } else {
            items = redditLoader.posts as [IGListDiffable]
            print("no else!")
        }
        return items
//        return items.sorted(by: { (left: Any, right: Any) -> Bool in
//            if let left = left as? DateSortable, let right = right as? DateSortable {
//                print("sort")
//                return left.date > right.date
//            }
//            return false
//        })
    }
    
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        let sectionController: IGListSectionController
        
        if object is Post {
            sectionController = PostSectionController()
        } else if object is AMComment {
            sectionController = AMCommentSectionController()
        } else {
            sectionController = IGListSectionController()
            print("other sectionController")
        }
        return sectionController
        
//        switch post.thumbnail {
//        case "default":
//            print("default thumb")
//        case "self":
//            print("self post")
//        default:
//            print("none of the above")
//        }
        
        
        //return PostSectionController()
    }
    
    func emptyView(for listAdapter: IGListAdapter) -> UIView? { return nil }
}

extension SubredditViewController: RedditLoaderDelegate {
    func redditLoaderDidUpdatePosts(redditLoader: RedditLoader) {
        adapter.performUpdates(animated: true)
    }
    func redditLoaderDidSelectPost(redditLoader: RedditLoader) {
        adapter.reloadObjects(redditLoader.posts)
    }
    func redditLoaderDidReturnToPosts(redditLoader: RedditLoader) {
        adapter.reloadObjects(redditLoader.posts)
    }
    func redditLoaderDidUpdateComments(redditLoader: RedditLoader) {
        adapter.performUpdates(animated: true)
    }
}

