//
//  Comment.swift
//  LooseFoot
//
//  Created by Alexander McArdle on 1/23/17.
//  Copyright © 2017 Alexander McArdle. All rights reserved.
//

import UIKit
import reddift

class AMComment: NSObject, DateSortable {
    
    let date: Date
//    let text: String
//    let user: User
    
    // RedditComment
    let comment: Comment
//    let id: String
//    let name: String
//    let domain: String
//    let bannedBy: String
//    let mediaEmbed: MediaEmbed?
    let subreddit: String
//    let selftextHtml: String
//    let selftext: String
//    let likes: VoteDirection
//    let userReports: [Any]
//    let secureMedia: Any?
//    let linkFlairText: String
//    let gilded: Int
//    let archived: Bool
//    let clicked: Bool
//    let reportReasons: [Any]
    let author: String
//    let numComments: Int
//    let score: Int
//    let approvedBy: String
//    let over18: Bool
//    let hidden: Bool
//    let thumbnail: String
//    let subredditId: String
//    let edited: Bool
//    let linkFlairCssClass: String
//    let authorFlairCssClass: String
//    let downs: Int
//    let modReports: [Any]
//    let secureMediaEmbed: Any?
//    let saved: Bool
//    let isSelf: Bool
//    let permalink: String
//    let stickied: Bool
//    let created: Int
//    let url: String
//    let authorFlairText: String
    let body: String
//    let createdUtc: Int
//    let ups: Int
//    let upvoteRatio: Double
//    let media: Media?
//    let visited: Bool
//    let numReports: Int
//    let distinguished: Bool
    
    
    //    init(date: Date, text: String, user: User) {
    //        self.date = date
    //        self.text = text
    //        self.user = user
    //    }
    
    init(comment: Comment) {
        self.comment = comment
        self.date = Date()
//        self.text = link.title
//        self.user = User(id: 0, name: link.author)
//        self.id = link.id
//        self.name = link.name
//        self.domain = link.domain
//        self.bannedBy = link.bannedBy
//        self.mediaEmbed = link.mediaEmbed
        self.subreddit = comment.subreddit
//        self.selftextHtml = link.selftextHtml
//        self.selftext = link.selftext
//        self.likes = link.likes
//        self.userReports = link.userReports
//        self.secureMedia = link.secureMedia
//        self.linkFlairText = link.linkFlairText
//        self.gilded = link.gilded
//        self.archived = link.archived
//        self.clicked = link.clicked
//        self.reportReasons = link.reportReasons
        self.author = comment.author
//        self.numComments = link.numComments
//        self.score = link.score
//        self.approvedBy = link.approvedBy
//        self.over18 = link.over18
//        self.hidden = link.hidden
//        self.thumbnail = link.thumbnail
//        self.subredditId = link.subredditId
//        self.edited = link.edited
//        self.linkFlairCssClass = link.linkFlairCssClass
//        self.authorFlairCssClass = link.authorFlairCssClass
//        self.downs = link.downs
//        self.modReports = link.modReports
//        self.secureMediaEmbed = link.secureMediaEmbed
//        self.saved = link.saved
//        self.isSelf = link.isSelf
//        self.permalink = link.permalink
//        self.stickied = link.stickied
//        self.created = link.created
//        self.url = link.url
//        self.authorFlairText = link.authorFlairText
        self.body = comment.body
//        self.createdUtc = link.createdUtc
//        self.ups = link.ups
//        self.upvoteRatio = link.upvoteRatio
//        self.media = link.media
//        self.visited = link.visited
//        self.numReports = link.numReports
//        self.distinguished = link.distinguished
    }
}
