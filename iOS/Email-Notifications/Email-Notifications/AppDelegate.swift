//
//  AppDelegate.swift
//  Notifications
//
//  Created by Training on 09.06.14.
//  Copyright (c) 2014 Training. All rights reserved.
//

import UIKit
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        Parse.setApplicationId("nfAn2Baudv76AJ883ctGCZ5QUvUZ5UxIsGXVKeBm", clientKey: "4gjDjW9iaehGqzYOuV1r39escwNBbX0Op7zFZk1H")
        return true
    }
    
    func createAuthController() -> GTMOAuth2ViewControllerTouch {
        return GTMOAuth2ViewControllerTouch(scope: "https://mail.google.com/, https://www.googleapis.com/auth/gmail.readonly",
            clientID: "282638394231.apps.googleusercontent.com",
            clientSecret: "Wl6jNzcegs_Pvfy21xoGR-mE",
            keychainItemName: "com.arbesfeld.Email-Notifications-oauth",
            delegate: self,
            finishedSelector: Selector("viewController:finishedWithAuth:error:"))
        
    }
    
    func application(application: UIApplication!, didReceiveRemoteNotification userInfo:NSDictionary, fetchCompletionHandler completionHandler: ((UIBackgroundFetchResult) -> Void)!) {
        println(userInfo)
        
        let buttons: NSArray = userInfo.objectForKey("buttons") as NSArray
        let actions: NSMutableArray = NSMutableArray()
        let minimalActions: NSMutableArray = NSMutableArray()
        let newInfo: NSMutableDictionary = NSMutableDictionary()
        for b in buttons {
            var action = self.createAction(b as NSDictionary)
            actions.addObject(action)
            if (minimalActions.count < 2) {
                minimalActions.addObject(action)
                
                newInfo.setObject(b, forKey:action.identifier)
            }
        }
        newInfo.setObject(userInfo.objectForKey("from"), forKey:"from")
        
        let firstCategory:UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
        firstCategory.identifier = "FIRST_CATEGORY"
        firstCategory.setActions(actions, forContext: UIUserNotificationActionContext.Default)
        firstCategory.setActions(minimalActions, forContext: UIUserNotificationActionContext.Minimal)
        
        let categories:NSSet = NSSet(objects: firstCategory)
        let types:UIUserNotificationType = UIUserNotificationType.Alert | UIUserNotificationType.Badge
        let mySettings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: types, categories: categories)
        UIApplication.sharedApplication().registerUserNotificationSettings(mySettings)
        
        let notification: UILocalNotification = UILocalNotification()
        notification.alertBody = "This is an alert" // userInfo.objectForKey("title") as NSString
        notification.category = "FIRST_CATEGORY"
        notification.userInfo = newInfo
        UIApplication.sharedApplication().presentLocalNotificationNow(notification)
        
        completionHandler(UIBackgroundFetchResult.NewData)
    }
    
    func createAction(button: NSDictionary) -> UIMutableUserNotificationAction {
        var action:UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        
        action.destructive = false
        switch button.objectForKey("buttonText") as NSString {
            case "Star":
                action.identifier = "star"
                action.activationMode = UIUserNotificationActivationMode.Background
    
            case "Picture":
                action.identifier = "picture"
                action.activationMode = UIUserNotificationActivationMode.Foreground
            
            case "View":
                action.identifier = "goto"
                action.activationMode = UIUserNotificationActivationMode.Foreground
            
            case "Spam":
                action.identifier = "link"
                action.activationMode = UIUserNotificationActivationMode.Background
                action.destructive = true
            
            default:
                action.identifier = "link"
                action.activationMode = UIUserNotificationActivationMode.Foreground
        }
        action.identifier = action.identifier + "." + String(arc4random_uniform(100000))
        action.title = button.objectForKey("buttonText") as NSString
        action.authenticationRequired = false
        
        return action
    }
    
    func application(application: UIApplication!,
        handleActionWithIdentifier identifier:String!,
        forLocalNotification notification:UILocalNotification!,
        completionHandler: (() -> Void)!) {
        let link:NSString = (notification.userInfo as NSDictionary).objectForKey(identifier).objectForKey("link") as NSString
        switch (identifier as NSString).substringToIndex((identifier as NSString).rangeOfString(".").location) as NSString {
            case "star":
                println("star")
            case "picture":
                println("picture")
            case "goto":
                println("goto")
            case "link":
                println("link")
                println(link)
                NSNotificationCenter.defaultCenter().postNotificationName("showWebView", object:["link":link])
            default:
                assert(false, "not implemented")
        }
        completionHandler()
    }
    
    func application(application: UIApplication!, didReceiveLocalNotification notification: UILocalNotification!) {
        
        NSNotificationCenter.defaultCenter().postNotificationName("sendMail", object:["from":[(notification.userInfo as NSDictionary).objectForKey("from")]])
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

