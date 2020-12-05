//
//  SceneDelegate.swift
//  Livsy
//
//  Created by Artem on 20.06.2020.
//  Copyright © 2020 Artem Mirzabekian. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        UINavigationBar.appearance().tintColor = UIColor.init(named: "NavBarTint")
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = MainTabBarController()
        window?.makeKeyAndVisible()
        
        guard let userActivity = connectionOptions.userActivities.first,
              userActivity.activityType == NSUserActivityTypeBrowsingWeb
        else { return }
        
        self.scene(scene, continue: userActivity)
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let urlToOpen = userActivity.webpageURL else {
            return
        }
        
        let urlStr = urlToOpen.absoluteString
        guard let urlComp = URLComponents(string: urlStr) else { return }
        guard let id = urlComp.path.components(separatedBy: "/").last else { return }
        
        if isPostLink(urlStr: urlStr) { navigateToPost(id: Int(id) ?? 00) }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func navigateToPost(id: Int) {
        guard let tabBarController = window?.rootViewController as? UITabBarController else {
            return
        }
        guard let viewControllers = tabBarController.viewControllers,
              let index = viewControllers.firstIndex(where: { $0 is NavigationController }),
              let nc = viewControllers[index] as? NavigationController else { return }
        
        nc.popToRootViewController(animated: false)
        tabBarController.selectedIndex = index
        
        let postViewController = PostViewController()
        postViewController.isFromLink = true
        postViewController.postID = id
        nc.pushViewController(postViewController, animated: true)
    }
    
    func isPostLink(urlStr: String) -> Bool {
        urlStr.contains("topics") ? true : false
    }
    
}

