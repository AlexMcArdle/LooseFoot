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
import PopupDialog
import reddift

class AMSubredditViewController: ASViewController<ASTableNode>, UIPopoverPresentationControllerDelegate, UIGestureRecognizerDelegate {
    let tableNode = ASTableNode()
    //let layoutExamples: [LayoutExampleNode.Type]
    public let redditLoader = RedditLoader()
    
    var currentSubreddit: AMSubreddit?
    var hasBanner = false
    var overlayInactive = true
    
    func longPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        guard overlayInactive else { return }
        overlayInactive = false
        print("longPress")
        
//        // Create the dialog
//        let popup = PopupDialog(title: "title", message: "message")
//        
//        // Present dialog
//        self.present(popup, animated: true, completion: {self.overlayInactive = true})

    }
    
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
        tableNode.isUserInteractionEnabled = true
        
        addTouchRecognizers()
        
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
    }
    
    func addTouchRecognizers() {
        // Long Press
        let touchRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress(_:)))
        touchRecognizer.numberOfTouchesRequired = 1
        touchRecognizer.allowableMovement = 10.0
        tableNode.view.addGestureRecognizer(touchRecognizer)
    }
    
    func pressHome() {
        print("presshome")
        
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
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
        
        // Tap Gesture
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func rightNavBarButtonTouched() {
        redditLoader.login()
    }
    
}

extension AMSubredditViewController: RedditLoaderDelegate {
    func redditLoaderDidUpdateLinks(redditLoader: RedditLoader) {
        print("redditLoaderDidUpdateLinks")
        tableNode.reloadData()
    }
    func redditLoaderDidSelectLink(redditLoader: RedditLoader) {
        //adapter.reloadObjects(redditLoader.posts)
    }
    func redditLoaderDidVote(redditLoader: RedditLoader, link: AMLink) {
        print("redditLoaderDidVote")
        //tableNode.reloadData()
        let linkIndex = redditLoader.links.index(of: link)
        let sectionNum: Int
        if let sub = currentSubreddit {
            sectionNum = 1
        } else {
            sectionNum = 0
        }
        tableNode.reloadRows(at: [IndexPath(row: linkIndex!, section: sectionNum)], with: UITableViewRowAnimation.fade)
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
        if let sub = currentSubreddit {
            return 2
        } else { return 1 }
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
        
        switch indexPath.section {
        case 0:
            if let sub = currentSubreddit {
                let cell = AMHeaderCellNode(sub)
                return cell
            } else {
                let linkCell = AMLinkCellNode(link: redditLoader.links[indexPath.row], loader: redditLoader)
                return linkCell
            }
        case 1:
            let linkCell = AMLinkCellNode(link: redditLoader.links[indexPath.row], loader: redditLoader)
            return linkCell
        default:
            return ASCellNode()
        }
    }
}

extension AMSubredditViewController: ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
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
