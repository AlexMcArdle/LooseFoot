//
//  CommentSectionController.swift
//  LooseFoot
//
//  Created by Alexander McArdle on 1/23/17.
//  Copyright © 2017 Alexander McArdle. All rights reserved.
//

import UIKit
import IGListKit
import reddift

class AMCommentSectionController: IGListSectionController {
    
    var comment: AMComment!
    
    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
    
}

extension AMCommentSectionController: IGListSectionType {
    func numberOfItems() -> Int {
        return 1
    }
    
    func sizeForItem(at index: Int) -> CGSize {
        
        guard let context = collectionContext else { return .zero }
        return AMCommentCell.cellSize(width: context.containerSize.width, text: comment.body)
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        
        let cell = collectionContext!.dequeueReusableCell(of: AMCommentCell.self, for: self, at: index) as! AMCommentCell
        cell.messageLabel.text = comment.body
        cell.titleLabel.text = comment.author
        cell.statusLabel.text = comment.subreddit
        return cell
    }
    
    func didUpdate(to object: Any) {
        
        comment = object as? AMComment
    }
    
    func didSelectItem(at index: Int) {
        
    }
}
