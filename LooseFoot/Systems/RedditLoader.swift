/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation
import reddift
import Toaster
import RealmSwift
import SwiftyJSON

protocol RedditLoaderDelegate: class {
    func redditLoaderDidUpdateLinks(redditLoader: RedditLoader)
    func redditLoaderDidUpdateComments(redditLoader: RedditLoader, comments: [AMComment])
    func redditLoaderDidSelectLink(redditLoader: RedditLoader)
    func redditLoaderDidReturnToPosts(redditLoader: RedditLoader)
    func redditLoaderDidVote(redditLoader: RedditLoader)
    func redditLoaderDidUpdateSubreddits(redditLoader: RedditLoader)
}

private func doOnMainThread(execute work: @escaping @convention(block) () -> Swift.Void) {
  DispatchQueue.main.async {
    work()
  }
}

//private func lewisMessage(text: String, interval: TimeInterval = 0) -> Post {
//  let user = User(id: 2, name: "cpt.lewis")
//  return Post(date: Date(timeIntervalSinceNow: interval), text: text, user: user)
//}

class RedditLoader {
    
    
    static let sharedReddit = RedditLoader()
  
    weak var delegate: RedditLoaderDelegate?
    var searchDelegate: RedditLoaderDelegate?
    var realm: Realm?
    
    var redditSession: Session = Session()
    var names: [String] = []
    var r_links: [Link] = []
    var linksLast: [AMLink] = []
    var links: [AMLink] = {
        var arr = [AMLink]()
        return arr
        }() {
        didSet {
            doOnMainThread {
                self.delegate?.redditLoaderDidUpdateLinks(redditLoader: self)
            }
        }
    }
    
    var r_comments: [Comment] = []
    var commentsLast: [AMComment] = []
    var comments: [AMComment] = {
        var arr = [AMComment]()
        return arr
        }() {
        didSet {
            doOnMainThread {
                self.delegate?.redditLoaderDidUpdateComments(redditLoader: self, comments: self.comments)
            }
        }
    }
    
    var r_subreddits: [Subreddit] = []
    var subreddits: [AMSubreddit] = {
        var arr = [AMSubreddit]()
        return arr
        }() {
        didSet {
            doOnMainThread {
                self.searchDelegate?.redditLoaderDidUpdateSubreddits(redditLoader: self)
            }
        }
    }
    
    init() {
        self.realm = try! Realm()
    }
  
    func connect() {
        names.removeAll(keepingCapacity: false)
        names += OAuth2TokenRepository.savedNames
        
        if let name = names.first {
            do {
                let token = try OAuth2TokenRepository.token(of: name)
                self.redditSession = Session(token: token)
                Toast(text: "Logged in: \(name)").show()
            } catch { print("token error") }
        }
    }
    
    func subredditToAMSubreddit() {
        var newSubreddits: [AMSubreddit] = []
        for subreddit in self.r_subreddits {
            newSubreddits.append(AMSubreddit(sub: subreddit))
        }
        self.subreddits = newSubreddits
        self.r_subreddits = []
    }
    
    func linkToPost() {
        
        var newLinks: [AMLink] = []
        let indexCountOfLinks = (self.r_links.count - 1)
        for i in 0...indexCountOfLinks {
            newLinks.append(AMLink(link: self.r_links[i]))
        }
        
        let linksBak = self.links
        self.linksLast = linksBak
        
        self.links = newLinks
        self.r_links = []
    }
    
    func commentToAMComment() {
        var newComments: [AMComment] = []
        for comment in self.r_comments {
            newComments.append(AMComment(comment: comment))
        }
        let commentsBak = self.comments
        self.commentsLast = commentsBak
        
        self.comments = newComments
        self.r_comments = []
    }
    
//    func returnFromComments() {
//        
//        // save current state and restore previous Posts
//        doOnMainThread {
//            let lastPosts = self.postsLast
//            let currentComments = self.comments
//            self.commentsLast = currentComments
//            self.posts = lastPosts
//            self.comments = []
//            self.delegate?.redditLoaderDidReturnToPosts(redditLoader: self)
//        }
//    }
    
//    func expandPost(at: Int) {
////        doOnMainThread {
////            let post = self.posts[at+1]
////            debugPrint(post)
////            post.isExpanded = !post.isExpanded
////            debugPrint(post)
////        }
//    }
    
    func login() {
        try! OAuth2Authorizer.sharedInstance.challengeWithAllScopes()
    }

    func vote(link: AMLink, direction: VoteDirection) {
        //print("vote: \(direction.rawValue) + \(post.postPosition)")
        let newDir = (link.l.likes == direction) ? .none : direction
        do {
            try redditSession.setVote(newDir, name: link.l.name, completion: { (result) in
                switch result {
                case .failure(let error):
                    debugPrint("error: \(error)")
                    Toast(text: "Vote: error").show()
                case .success(let listing):
                    doOnMainThread {
                        debugPrint(listing)
                        let linkIndex: Int = self.links.index(of: link)!
                        print("voted: \(linkIndex)")
                        //self.links[linkIndex].l.likes = newDir
                        self.delegate?.redditLoaderDidVote(redditLoader: self)
                    }
                }
                
            })
        } catch { print("upvote error") }
    }
    
    func getUser(user: String) {
        
    }
    
    func getUserSubreddits(user: String, paginator: Paginator? = nil) {
        let _paginator = paginator ?? Paginator()
        debugPrint(paginator)
        do {
            try redditSession.getUserRelatedSubreddit(.subscriber, paginator: _paginator, completion: { (result) in
                switch result {
                case .failure(let error):
                    debugPrint(error)
                case .success(let listing):
                    //debugPrint(listing)
                    
                    self.r_subreddits.append(contentsOf: listing.children.flatMap{$0 as? Subreddit})
                    if(listing.paginator.isVacant) {
                        print("isVacant")
                        self.subredditToAMSubreddit()
                    } else {
                        print("!isVacant")
                        self.getUserSubreddits(user: "", paginator: listing.paginator)
                    }
                }
            })
        } catch { print("getUserSubreddits error") }
    }
    
    func getComments(link: AMLink) {
//        let paginator = Paginator()
//        let commentId = link.id
//        let sortType = LinkSortType.top
        
        do {
            try redditSession.getArticles(link.l, sort: .top, completion: { (result) in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let listing):
                    var newArray: [Comment] = []
                    newArray.append(contentsOf: listing.0.children.flatMap{$0 as? Comment})
                    self.r_comments.append(contentsOf: listing.1.children.flatMap{$0 as? Comment})
                    self.commentToAMComment()
                }
            })
        } catch { print("getComments error") }
    }
    
    func getSubreddit(sub: String) {
        
        let paginator = Paginator()
        let subreddit: Subreddit? = (sub=="Frontpage") ? nil : Subreddit(subreddit: sub)
        let sortType = LinkSortType.hot
        do {
            try redditSession.getList(paginator, subreddit:subreddit, sort:sortType, timeFilterWithin:.day, completion: { (result) in
                switch result {
                case .failure(let error):
                    Toast(text: "GetSub: \(error)").show()
                case .success(let listing):
                    self.r_links.append(contentsOf: listing.children.flatMap{$0 as? Link})
                    self.linkToPost()
                }
            })
        } catch { print("getSubreddit error") }
    }
}
