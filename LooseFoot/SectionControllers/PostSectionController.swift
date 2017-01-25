//
//  MessageSectionController.swift
//  Marslink
//
//  Created by Alexander McArdle on 1/22/17.
//  Copyright © 2017 Ray Wenderlich. All rights reserved.
//

import UIKit
import IGListKit
import reddift
import Toaster
import Kingfisher

class PostSectionController: IGListSectionController {

    var post: Post!
    var currentImage: UIImage?
    
    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
        workingRangeDelegate = self
    }
    
}

extension PostSectionController: IGListWorkingRangeDelegate {
    
    //MARK: IGListWorkingRangeDelegate
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerWillEnterWorkingRange sectionController: IGListSectionController) {
//            if(currentImage == nil) {
//                DispatchQueue.main.async {
//                    if let cell = self.collectionContext?.cellForItem(at: 0, sectionController: self) as? PostCell {
//                        cell.postImageView.kf.setImage(with: URL(string: self.post.thumbnail), completionHandler: {
//                            (image, error, cacheType, url) in
//                            self.currentImage = image
//                        })
//                    }
//                }
//            }
    }
    
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerDidExitWorkingRange sectionController: IGListSectionController) {}
    

}

extension PostSectionController: IGListSectionType {
    func numberOfItems() -> Int {
        return 1
    }
    
    func sizeForItem(at index: Int) -> CGSize {

        guard let context = collectionContext else { return .zero }
        return PostCell.cellSize(width: context.containerSize.width, text: post.title)
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        
        if(post.isExpanded) {
            let cell = collectionContext!.dequeueReusableCell(of: PostCellExpanded.self, for: self, at: index) as! PostCellExpanded
            cell.messageLabel.text = post.title
            cell.authorButton.setTitle(post.author, for: .normal)
            cell.subredditLabel.text = post.subreddit
            cell.pointsLabel.text = String(post.ups)
            cell.statusLabel.text = "EXPANDED"
            cell.postImageView.kf.setImage(with: URL(string: post.thumbnail))
            print("expanded")
            return cell
        } else {
            let cell = collectionContext!.dequeueReusableCell(of: PostCell.self, for: self, at: index) as! PostCell
            cell.messageLabel.text = post.title
            cell.authorButton.setTitle(post.author, for: .normal)
            cell.subredditLabel.text = post.subreddit
            cell.pointsLabel.text = String(post.ups)
            cell.postImageView.kf.setImage(with: URL(string: post.thumbnail))
            return cell
        }
    }
    
    func didUpdate(to object: Any) {
        
        post = object as? Post
    }
    
    func didSelectItem(at index: Int) {
        let parent = viewController as! SubredditViewController
        if(parent.currentMenu != "comments") {
            post.isExpanded = !(post.isExpanded)
            //let nav = parent.navigationController as! CustomNavigationController
            //nav.show(AMCommentsViewController(), sender: parent)
            //nav.pushViewController(AMCommentsViewController(), animated: true)
            parent.redditLoader.getComments(post: post)
            parent.currentMenu = "comments"
        } else {
            print("touched while in comments")
            post.isExpanded = !(post.isExpanded)
            parent.redditLoader.posts = [post]
            parent.redditLoaderDidSelectPost(redditLoader: parent.redditLoader)
        }
    }
}
