//
//  AppDelegate.swift
//  LooseFoot
//
//  Created by Alexander McArdle on 1/22/17.
//  Copyright © 2017 Alexander McArdle. All rights reserved.
//

import UIKit
import reddift
import ChameleonFramework
import FPSCounter

/// Posted when the OAuth2TokenRepository object succeed in saving a token successfully into Keychain.
public let OAuth2TokenRepositoryDidSaveToken            = "OAuth2TokenRepositoryDidSaveToken"
/// Posted when the OAuth2TokenRepository object failed to save a token successfully into Keychain.
public let OAuth2TokenRepositoryDidFailToSaveToken      = "OAuth2TokenRepositoryDidFailToSaveToken"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        FPSCounter.showInStatusBar(UIApplication.shared)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.black
        
        Chameleon.setGlobalThemeUsingPrimaryColor(UIColor.flatBlackDark, with: .contrast)
        
        let nav = CustomNavigationController(navigationBarClass: AMNavigationBar.self, toolbarClass: AMToolbar.self)
        //let nav = CustomNavigationController(navigationBarClass: CustomNavigationBar.self, toolbarClass: nil)

        nav.pushViewController(AMSubredditViewController(firstRun: true), animated: true)
        //nav.pushViewController(AMPagerViewController(), animated: true)

        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        print("url: \(url)")
        return OAuth2Authorizer.sharedInstance.receiveRedirect(url, completion: {(result) -> Void in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let token):
                DispatchQueue.main.async(execute: { () -> Void in
                    do {
                        try OAuth2TokenRepository.save(token: token, of: token.name)
                        NotificationCenter.default.post(name: Notification.Name(rawValue: OAuth2TokenRepositoryDidSaveToken), object: nil, userInfo: nil)
                        debugPrint(token)
                    } catch {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: OAuth2TokenRepositoryDidFailToSaveToken), object: nil, userInfo: nil)
                        print(error)
                    }
                })
            }
        })
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

