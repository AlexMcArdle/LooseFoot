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

protocol RedditLoaderDelegate: class {
  func redditLoaderDidUpdatePosts(redditLoader: RedditLoader)
}

private func delay(time: Double = 1, execute work: @escaping @convention(block) () -> Swift.Void) {
  DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
    work()
  }
}

private func lewisMessage(text: String, interval: TimeInterval = 0) -> Post {
  let user = User(id: 2, name: "cpt.lewis")
  return Post(date: Date(timeIntervalSinceNow: interval), text: text, user: user)
}

class RedditLoader {
  
  weak var delegate: RedditLoaderDelegate?
  
  var posts: [Post] = {
    var arr = [Post]()
    return arr
    }() {
    didSet {
      delegate?.redditLoaderDidUpdatePosts(redditLoader: self)
    }
  }
  
  func connect() {
    self.posts.append(lewisMessage(text: "1..."))
  }
}
