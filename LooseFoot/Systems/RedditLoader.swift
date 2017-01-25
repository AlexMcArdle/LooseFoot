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

protocol RedditLoaderDelegate: class {
    func redditLoaderDidUpdatePosts(redditLoader: RedditLoader)
    func redditLoaderDidUpdateComments(redditLoader: RedditLoader)
    func redditLoaderDidSelectPost(redditLoader: RedditLoader)
    func redditLoaderDidReturnToPosts(redditLoader: RedditLoader)
}

private func delay(time: Double = 1, execute work: @escaping @convention(block) () -> Swift.Void) {
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
    
    var redditSession: Session = Session()
    var names: [String] = []
    var r_links: [Link] = []
    var postsLast: [Post] = []
    var posts: [Post] = {
        var arr = [Post]()
        return arr
        }() {
        didSet {
            delegate?.redditLoaderDidUpdatePosts(redditLoader: self)
        }
    }
    
    var r_comments: [Comment] = []
    var commentsLast: [AMComment] = []
    var comments: [AMComment] = {
        var arr = [AMComment]()
        return arr
        }() {
        didSet {
            delegate?.redditLoaderDidUpdateComments(redditLoader: self)
        }
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
    
    func linkToPost() {
        
        var newPosts: [Post] = []
        for link in self.r_links {
            newPosts.append(Post(link: link))
        }
        
        let postsBak = self.posts
        self.postsLast = postsBak
        
        self.posts = newPosts
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
    
    func returnFromComments() {
        
        // save current state and restore previous Posts
        delay {
            let lastPosts = self.postsLast
            let currentComments = self.comments
            self.commentsLast = currentComments
            self.posts = lastPosts
            self.comments = []
            self.delegate?.redditLoaderDidReturnToPosts(redditLoader: self)
        }
    }
    
    func expandPost(at: Int) {
//        delay {
//            let post = self.posts[at+1]
//            debugPrint(post)
//            post.isExpanded = !post.isExpanded
//            debugPrint(post)
//        }
    }
    
    func getComments(post: Post) {
//        let paginator = Paginator()
//        let commentId = link.id
//        let sortType = LinkSortType.top
        
        // Clean view: Remove other posts and put clicked post at top
        delay {
            self.comments = []
            self.postsLast = self.posts
            self.posts = [post]
            //self.r_links.append(link)
            //self.linkToPost()
            self.delegate?.redditLoaderDidSelectPost(redditLoader: self)

        }
        
        do {
            try redditSession.getArticles(post.link, sort: .top, completion: { (result) in
                switch result {
                case .failure(let error):
                    print(error)
                case .success(let listing):
                    delay {
                        self.r_comments.append(contentsOf: listing.1.children.flatMap{$0 as? Comment})
                        self.commentToAMComment()
                    }
                    
                }
            })
        } catch { print("getComments error") }
    }
    
    func getSubreddit(sub: String) {
        if(sub == "Frontpage") {
            let paginator = Paginator()
            let subreddit: Subreddit? = nil
            let sortType = LinkSortType.hot
            do {
                try redditSession.getList(paginator, subreddit:subreddit, sort:sortType, timeFilterWithin:.day, completion: { (result) in
                    switch result {
                    case .failure(let error):
                        print(error)
                    case .success(let listing):
                        
                        delay {
                            self.r_links.append(contentsOf: listing.children.flatMap{$0 as? Link})
                            self.linkToPost()
                        }
                    }
                })
            } catch { print("getSubreddit error") }
        }
    }
}
