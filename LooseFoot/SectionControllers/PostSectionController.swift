//
//  MessageSectionController.swift
//  Marslink
//
//  Created by Alexander McArdle on 1/22/17.
//  Copyright © 2017 Ray Wenderlich. All rights reserved.
//

import UIKit
import IGListKit

class PostSectionController: IGListSectionController {

    var post: Post!
    
    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
    
}

extension PostSectionController: IGListSectionType {
    func numberOfItems() -> Int {
        return 1
    }
    
    func sizeForItem(at index: Int) -> CGSize {

        guard let context = collectionContext else { return .zero }
        return PostCell.cellSize(width: context.containerSize.width, text: post.text)
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {

        let cell = collectionContext!.dequeueReusableCell(of: PostCell.self, for: self, at: index) as! PostCell
        cell.messageLabel.text = post.text
        cell.titleLabel.text = post.user.name.uppercased()
        return cell
    }
    
    func didUpdate(to object: Any) {
        
        post = object as? Post
    }
    
    func didSelectItem(at index: Int) {}
}
