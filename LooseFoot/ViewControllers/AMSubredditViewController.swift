//
//  AMSubredditViewController.swift
//  LooseFoot
//
//  Created by Alexander McArdle on 2/6/17.
//  Copyright © 2017 Alexander McArdle. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import FontAwesome_swift
import Popover
import reddift

class AMSubredditViewController: ASViewController<ASTableNode>, UIPopoverPresentationControllerDelegate {
    let tableNode = ASTableNode()
    //let layoutExamples: [LayoutExampleNode.Type]
    public let redditLoader = RedditLoader()
    
    var currentSubreddit: AMSubreddit?
    var hasBanner = false
    
    init(subreddit: String? = nil, firstRun: Bool = false) {
        /*layoutExamples = [
            HeaderWithRightAndLeftItems.self,
            PhotoWithInsetTextOverlay.self,
            PhotoWithOutsetIconOverlay.self,
            FlexibleSeparatorSurroundingContent.self
        ]*/
        if(firstRun) {
            print("firstRun")
            redditLoader.connect()
        }
        
        super.init(node: tableNode)
        tableNode.backgroundColor = .flatBlackDark
        
        //self.title = "Reddit"
        // Set Title
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: String.fontAwesomeIcon(name: .cog), style: .plain, target: self, action: #selector(rightNavBarButtonTouched))
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSFontAttributeName: UIFont.fontAwesome(ofSize: 20)], for: .normal)
        tableNode.delegate = self
        tableNode.dataSource = self
        
        redditLoader.delegate = self
        var sub: AMSubreddit? = nil
        if let subText = subreddit {
            sub = AMSubreddit(sub: Subreddit(subreddit: subText))
        }
        goToSubreddit(sub)
        //redditLoader.getSubreddit(subreddit)
    }
    func pressHome() {
        print("presshome")
        
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        //super.didMove(toParentViewController: parent)
        addTitle()
        addToolbar()
    }
    
    func goToSubreddit(_ subreddit: AMSubreddit? = nil) {
        print("gotosubreddit \(subreddit?.s.displayName)")
        currentSubreddit = subreddit
        addTitle()
        if let sub = subreddit {
            if(sub.s.bannerImg.hasPrefix("http")) {
                hasBanner = true
            }
        }
        redditLoader.getSubreddit(subreddit?.s.displayName)
    }
    
//    func updateTitle() {
//        let titleView = self.navigationItem.titleView as? UILabel
//        titleView?.text = currentSubreddit
//        
//    }
    
    func addTitle() {
        let icon = currentSubreddit?.s.iconImg
        let titleView = UILabel()
        titleView.text = currentSubreddit?.s.displayName ?? "Frontpage"
        titleView.font = AppFont()
        titleView.textColor = .flatWhite
        let width = titleView.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).width
        titleView.frame = CGRect(origin: .zero, size: CGSize(width: width, height: 500))
        self.navigationItem.titleView = titleView
        
//        if let urlString = currentSubreddit?.s.bannerImg {
//            if let url = URL(string: urlString) {
//                if let data = try? Data(contentsOf: url) {
//                self.navigationController?.navigationBar.setBackgroundImage(UIImage(data: data), for: UIBarMetrics.default)
//                }
//            }
//        }
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(titleWasTapped))
        titleView.isUserInteractionEnabled = true
        titleView.addGestureRecognizer(recognizer)
    }
    func addToolbar() {
        let homeBtn = UIBarButtonItem(title: String.fontAwesomeIcon(name: .newspaperO), style: .plain, target: self, action: #selector(pressHome))
        homeBtn.setTitleTextAttributes([NSFontAttributeName: UIFont.fontAwesome(ofSize: 20)], for: .normal)
        
        let firstButton = ASDisplayNode()
        self.setToolbarItems([homeBtn], animated: true)
    }
    
    func showHandler(_ handler: Any) {
        print("show \(handler)")
    }
    func dismissHandler(_ handler: Any) {
        print("dismiss")
    }
    
    @objc private func titleWasTapped() {
        print("Hello, titleWasTapped!")
        
        let startPoint = CGPoint(x: self.view.frame.width / 2, y: 55)
        //let searchView = AMSearchViewController().view!
        
        let searchView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 550))
        //let searchView = AMSearchViewController()
        
        let searchController = AMSearchViewController(rl: redditLoader)
        redditLoader.searchDelegate = searchController
        
        
        searchView.addSubnode(searchController.node)
        //let option: [PopoverOption] = [PopoverOption.type(.down)]
        let popover = Popover(showHandler: { handler in
            self.showHandler(handler)},
                              dismissHandler: { handler in
                                self.dismissHandler(handler)})
        searchController.popover = popover
        searchController.subredditViewController = self
        popover.show(searchView, point: startPoint)
        
//        let vc = UIViewController()
//        vc.modalPresentationStyle = UIModalPresentationStyle.popover
//        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
//        //popover.sourceView = navigationController?.navigationBar.right
//        popover.delegate = self
        
//        //let nav = navigationController as! CustomNavigationController
//        //nav.modalPresentationStyle = .popover
//        //vc.popoverPresentationController?.popover
//        let popover = vc.popoverPresentationController
//        
//        vc.preferredContentSize = CGSize(width: 500, height: 600)
//        popover?.delegate = self
//        popover?.sourceView = self.view
//        popover?.sourceRect = CGRect(x: 100, y: 100, width: 0, height: 0)
//        vc.popoverPresentationController
        
//        present(vc, animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableNode.indexPathForSelectedRow {
            tableNode.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func rightNavBarButtonTouched() {
        redditLoader.login()
    }
    
}

extension AMSubredditViewController: RedditLoaderDelegate {
    func redditLoaderDidUpdateLinks(redditLoader: RedditLoader) {
        //adapter.performUpdates(animated: true)
        print("redditLoaderDidUpdateLinks")
        tableNode.reloadData()
    }
    func redditLoaderDidSelectLink(redditLoader: RedditLoader) {
        //adapter.reloadObjects(redditLoader.posts)
    }
    func redditLoaderDidVote(redditLoader: RedditLoader, link: AMLink) {
        //adapter.reloadObjects(redditLoader.posts)
        print("redditLoaderDidVote")
        //tableNode.reloadData()
        let linkIndex = redditLoader.links.index(of: link)
        tableNode.reloadRows(at: [IndexPath(row: linkIndex!, section:0),
                                  IndexPath(row: linkIndex!, section:1)], with: UITableViewRowAnimation.fade)
    }
    func redditLoaderDidReturnToPosts(redditLoader: RedditLoader) {
        //adapter.reloadObjects(redditLoader.posts)
    }
    func redditLoaderDidUpdateComments(redditLoader: RedditLoader, comments: [AMComment]) {
        //adapter.performUpdates(animated: true)
    }
    func redditLoaderDidUpdateSubreddits(redditLoader: RedditLoader) {
        // dont do anything yet
    }
}

extension AMSubredditViewController: ASTableDataSource {
    func numberOfSections(in tableNode: ASTableNode) -> Int {
        return 2
    }
    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        //return layoutExamples.count
        switch section {
        case 0:
            if let sub = currentSubreddit {
                return 1
            } else {
                return redditLoader.links.count
            }
        case 1:
            return redditLoader.links.count
        default:
            return 0
        }
    }
    
    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        //return OverviewCellNode(layoutExampleType: layoutExamples[indexPath.row])
        let linkCell = AMLinkCellNode(link: redditLoader.links[indexPath.row], loader: redditLoader)
        switch indexPath.section {
        case 0:
            if let sub = currentSubreddit {
                let cell = AMHeaderCellNode(sub)
                return cell
            } else {
                return linkCell
            }
        case 1:
            return linkCell
        default:
            return ASCellNode()
        }
    }
}

extension AMSubredditViewController: ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        //let layoutExampleType = (tableNode.nodeForRow(at: indexPath) as! AMLinkCellNode).layoutExampleType
        
        let detail = AMCommentsViewController(link: redditLoader.links[indexPath.row], loader: redditLoader)
        switch indexPath.section {
        case 0:
            if let sub = currentSubreddit {
                print("selectedBanner: \(sub)")
            } else {
                self.navigationController?.pushViewController(detail, animated: true)
            }
        case 1:
            self.navigationController?.pushViewController(detail, animated: true)
        default:
            print("touch error")
        }
    }
}
