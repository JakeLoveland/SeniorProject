//
//  ViewController.swift
//  SeniorProject
//
//  Created by Jake Loveland on 5/4/20.
//  Copyright © 2020 Jake Loveland. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class SignInViewController: UIViewController, LoginButtonDelegate {
    
    @IBOutlet weak var fbLoginButton: FBLoginButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        ServiceModel.getServices()

        let loginButton = fbLoginButton
        loginButton?.delegate = self
        loginButton?.permissions = ["user_friends"]
        
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {

        if let error = error {
            
            print(error.localizedDescription)
            return
        }
        if AccessToken.current != nil {
            let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if error != nil {
                    //TODO: -show error
                }
                else {
                    
                    let user = Auth.auth().currentUser
                    if let user = user {
                        let name = user.displayName!
                        let array = name.components(separatedBy: " ")
                        let uid = user.uid
                        let db = Firestore.firestore()
                        db.collection("users").document(uid).setData(["first_name": array[0], "last_name":array[1], "uid":uid]) { (error) in
                            if error != nil {
                                //TODO: - Show error
                            }
                        }
                        UserModel.user.firstname = array[0]
                        UserModel.user.lastname = array[1]
                        UserModel.user.id = uid
                        ShowModel.getShows()

                        
                    }
                    if (authResult?.additionalUserInfo!.isNewUser)! {
                        let serviceSelectViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.serviceSelectViewController) as? ServiceSelectViewController
                        self.view.window?.rootViewController = serviceSelectViewController
                        self.view.window?.makeKeyAndVisible()
                        
                    }else {
                        let tabViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabViewController) as? UITabBarController
                        
                        self.view.window?.rootViewController = tabViewController
                        self.view.window?.makeKeyAndVisible()
                    }
                }
            }
        }
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    
    




}



