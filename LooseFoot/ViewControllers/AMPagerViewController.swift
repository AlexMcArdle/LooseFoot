//
//  AMPagerViewController.swift
//  LooseFoot
//
//  Created by Alexander McArdle on 2/11/17.
//  Copyright © 2017 Alexander McArdle. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import FontAwesome_swift

class AMPagerViewController: ASViewController<ASPagerNode> {

    let pagerNode = ASPagerNode()
    let pages = [String.fontAwesomeIcon(name: .newspaperO)]
    
    init() {
        super.init(node: pagerNode)
        
        pagerNode.delegate = self
        pagerNode.setDataSource(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
        addTitle()
    }
    
    func addTitle() {
        let titleView = UILabel()
        titleView.text = "Reddit"
        titleView.font = AppFont()
        titleView.textColor = .flatWhite
        let width = titleView.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)).width
        titleView.frame = CGRect(origin: .zero, size: CGSize(width: width, height: 500))
        self.navigationItem.titleView = titleView
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(titleWasTapped))
        titleView.isUserInteractionEnabled = true
        titleView.addGestureRecognizer(recognizer)
    }
    
    func titleWasTapped() {
        print("titleWasTapped")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension AMPagerViewController: ASPagerDataSource {
    func numberOfPages(in pagerNode: ASPagerNode) -> Int {
        return pages.count
    }
    
    func pagerNode(_ pagerNode: ASPagerNode!, nodeAt index: Int) -> ASCellNode! {
        guard pages.count > index else { return nil }
        
        let page = pages[index]
        switch page {
        default:
            let node = ASCellNode(viewControllerBlock: { () -> UIViewController in
                return AMSubredditViewController(firstRun: true)
            }, didLoad: nil)
            
            node.style.preferredSize = pagerNode.bounds.size
            
            return node
        }
        
    }
}
extension AMPagerViewController: ASPagerDelegate {
}
