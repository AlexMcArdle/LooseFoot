//
//  Post.swift
//  LooseFoot
//
//  Created by Alexander McArdle on 1/22/17.
//  Copyright © 2017 Alexander McArdle. All rights reserved.
//


import UIKit

class Post: NSObject, DateSortable {
    
    let date: Date
    let text: String
    let user: User
    
    init(date: Date, text: String, user: User) {
        self.date = date
        self.text = text
        self.user = user
    }
    
}
