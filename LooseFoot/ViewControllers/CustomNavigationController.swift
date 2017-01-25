//
//  CustomNavigationController.swift
//  LooseFoot
//
//  Created by Alexander McArdle on 1/22/17.
//  Copyright © 2017 Alexander McArdle. All rights reserved.
//

import UIKit
import SafariServices
import reddift


class CustomNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let customNavigationBar = self.navigationBar as! CustomNavigationBar
        customNavigationBar.settingsButton.addTarget(self, action: #selector(settingsButtonPress(button:)), for: .touchUpInside)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setTitle() {
        
    }
    
    func login() {
        try! OAuth2Authorizer.sharedInstance.challengeWithAllScopes()
    }
    
    func titleButtonPress(button: UIButton) {
        
    }
    
    func changeSettingsTitle(title: String) {

    }
    
    func settingsButtonPress(button: UIButton) {
        login()
    }

}
