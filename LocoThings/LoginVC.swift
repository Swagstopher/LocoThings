//
//  LoginVC.swift
//  LocoThings
//
//  Created by Tung Ly on 10/6/16.
//  Copyright © 2016 Tung Ly. All rights reserved.
//

import UIKit
import Auth0

class LoginVC: UIViewController {
    @IBOutlet weak var fbButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var retrievedCredentials: Credentials?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
    @IBAction func facebookLogin(sender: UIButton) {
        self.performFacebookAuthentication()
    }
    
    @IBAction func twitterLogin(sender: UIButton) {
        self.performTwitterAuthentication()
    }
        
    private func performLogin() {
        self.view.endEditing(true)
        Auth0
            .authentication()
            .login(
                usernameOrEmail: self.email.text!,
                password: self.password.text!,
                connection: "Username-Password-Authentication"
            )
            .start { result in
                dispatch_async(dispatch_get_main_queue()) {
                    switch result {
                    case .Success(let credentials):
                        self.loginWithCredentials(credentials)
                    case .Failure(let error):
                        _ = error
                        print(error)
                    }
                }
        }
    }
    
    private func loginWithCredentials(credentials: Credentials) {
        self.retrievedCredentials = credentials
        retrieveProfile()
        let mainVC:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("mainNav")
        self.presentViewController(mainVC, animated: true, completion: nil)
    }
    
    private func retrieveProfile() {
        guard let idToken = retrievedCredentials!.idToken else {
            self.navigationController?.popViewControllerAnimated(true)
            return
        }
        Auth0
            .authentication()
            .tokenInfo(token: idToken)
            .start { result in
                dispatch_async(dispatch_get_main_queue()) {
                    switch result {
                    case .Success(let profile):
                        print("Welcome, \(profile.name) #\(profile.id)")
                        NSUserDefaults.standardUserDefaults().removeObjectForKey("UID")
                        NSUserDefaults.standardUserDefaults().setObject(profile.id, forKey: "UID")
                        NSUserDefaults.standardUserDefaults().synchronize()
                    case .Failure(let error):
                        print(error)
                    }
                }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let mapLandingVC = segue.destinationViewController as? MapLanding else {
            return
        }
        mapLandingVC.loginCredentials = self.retrievedCredentials!
    }
    
    private func performTwitterAuthentication() {
        self.view.endEditing(true)
        Auth0
            .webAuth()
            .connection("twitter")
            .scope("openid")
            .start { result in
                dispatch_async(dispatch_get_main_queue()) {
                    switch result {
                    case .Success(let credentials):
                        self.loginWithCredentials(credentials)
                    case .Failure(let error):
                        _ = error
                        print(error)
                    }
                }
        }
    }
    
    private func performFacebookAuthentication() {
        self.view.endEditing(true)
        Auth0
            .webAuth()
            .connection("facebook")
            .scope("openid")
            .start { result in
                dispatch_async(dispatch_get_main_queue()) {
                    switch result {
                    case .Success(let credentials):
                        self.loginWithCredentials(credentials)
                    case .Failure(let error):
                        _ = error
                        print(error)
                    }
                }
        }
    }
}
