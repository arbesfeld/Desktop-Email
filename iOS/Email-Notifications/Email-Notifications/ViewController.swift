//
//  ViewController.swift
//  Email-Notifications
//
//  Created by Matthew Arbesfeld on 7/20/14.
//  Copyright (c) 2014 Matthew Arbesfeld. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {
                            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"drawAShape:", name: "actionOnePressed", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"showAMessage:", name: "actionTwoPressed", object: nil)
        
        
        var notification:UILocalNotification = UILocalNotification()
        notification.category = "FIRST_CATEGORY"
        notification.alertBody = "Hi, I am a notification"
        notification.fireDate = date
        
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    
    func drawAShape(notification:NSNotification){
        var view:UIView = UIView(frame:CGRectMake(10, 10, 100, 100))
        view.backgroundColor = UIColor.redColor()
        
        self.view.addSubview(view)
        
    }
    
    func showAMessage(notification:NSNotification){
        var message:UIAlertController = UIAlertController(title: "A Notification Message", message: "Hello there", preferredStyle: UIAlertControllerStyle.Alert)
        message.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        
        self.presentViewController(message, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func handleBack (sender: AnyObject) {
        self.navigationController.popViewControllerAnimated(true)
    }
    
    @IBAction func authorizeWithGoogle(sender: AnyObject) {
        let backButton: UIBarButtonItem = UIBarButtonItem(
            title:"back",
            style:UIBarButtonItemStyle.Bordered,
            target:self,
            action:Selector("handleBack:"))
        let oauthController: GTMOAuth2ViewControllerTouch = self.createAuthController();
        
        
        oauthController.navigationItem.leftBarButtonItem = backButton;
        self.navigationController.pushViewController(oauthController, animated: true)
    }
    
    // Creates the auth controller for authorizing access to Google Drive.
    func createAuthController() -> GTMOAuth2ViewControllerTouch {
        return GTMOAuth2ViewControllerTouch(scope: "https://mail.google.com/, https://www.googleapis.com/auth/gmail.readonly",
            clientID: "282638394231.apps.googleusercontent.com",
            clientSecret: "Wl6jNzcegs_Pvfy21xoGR-mE",
            keychainItemName: "com.arbesfeld.Email-Notifications-oauth",
            delegate: self,
            finishedSelector: Selector("viewController:finishedWithAuth:error:"))
        
    }
    
    // Handle completion of the authorization process, and updates the Drive service
    // with the new credentials.
    func viewController(viewController: GTMOAuth2ViewControllerTouch , finishedWithAuth authResult: GTMOAuth2Authentication , error:NSError ) {
        
    }
}

