//
//  NSObject+IGListDiffable.swift
//  LooseFoot
//
//  Created by Alexander McArdle on 1/22/17.
//  Copyright © 2017 Alexander McArdle. All rights reserved.
//

import Foundation
import IGListKit

// MARK: - IGListDiffable
extension NSObject: IGListDiffable {
    
    public func diffIdentifier() -> NSObjectProtocol {
        return self
    }
    
    public func isEqual(toDiffableObject object: IGListDiffable?) -> Bool {
        return isEqual(object)
    }
}
