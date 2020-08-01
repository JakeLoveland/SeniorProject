//
//  LoginViewController.swift
//  SeniorProject
//
//  Created by Jake Loveland on 5/4/20.
//  Copyright © 2020 Jake Loveland. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ShowModel.getShows()
        // Do any additional setup after loading the view.
    }
    
    func validateFields() -> String? {
        
        if emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in all fields."
        }
        
        
        return nil
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        
        let error = validateFields()
        if error != nil {
            //TODO: - Show error
        }
        else {
        
            let email = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if error != nil {
                    //TODO: -show error
                }
                else {
                    let user = Auth.auth().currentUser
                    if let user = user {
                        let db = Firestore.firestore()
                        db.collection("users").document(user.uid).getDocument { (DocumentSnapshot, Error) in
                            UserModel.user.firstname = DocumentSnapshot?.data()!["first_name"] as! String
                            UserModel.user.lastname = DocumentSnapshot?.data()!["last_name"] as! String
                            UserModel.user.id = DocumentSnapshot?.data()!["uid"] as! String
                        }
                        db.collection("users").document(user.uid).collection("services").getDocuments { (querySnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                for document in querySnapshot!.documents {
                                    let service1 = Service()
                                    service1.name = document.data()["name"]! as! String
                                    service1.imageName = document.data()["logo"]! as! String
                                    service1.id = document.data()["Id"]! as! String
                                    UserModel.user.services?.append(service1)
                                    

                                }
                            }
                        }
                        db.collection("users").document(user.uid).collection("watched").getDocuments { (querySnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                for document in querySnapshot!.documents {
                                    let show = Show()
                                    show.genre = document.data()["Genre"]! as! String
                                    show.premiere = document.data()["Premiere"]! as! String
                                    show.seasons = document.data()["Seasons"]! as! String
                                    show.status = document.data()["Status"]! as! String
                                    show.title = document.data()["Title"]! as! String
                                    let serviceName = document.data()["Service"]! as! String
                                    for service in ServiceModel.serviceArray {
                                        if service.name == serviceName {
                                            show.service = service
                                        }
                                    }
                                    UserModel.user.shows["watched"]!.append(show)

                                }
                            }
                        }
                        db.collection("users").document(user.uid).collection("watching").getDocuments { (querySnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                for document in querySnapshot!.documents {
                                    let show = Show()
                                    show.genre = document.data()["Genre"]! as! String
                                    show.premiere = document.data()["Premiere"]! as! String
                                    show.seasons = document.data()["Seasons"]! as! String
                                    show.status = document.data()["Status"]! as! String
                                    show.title = document.data()["Title"]! as! String
                                    let serviceName = document.data()["Service"]! as! String
                                    for service in ServiceModel.serviceArray {
                                        if service.name == serviceName {
                                            show.service = service
                                        }
                                    }
                                    UserModel.user.shows["watching"]!.append(show)

                                }
                            }
                        }
                        db.collection("users").document(user.uid).collection("want").getDocuments { (querySnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                for document in querySnapshot!.documents {
                                    let show = Show()
                                    show.genre = document.data()["Genre"]! as! String
                                    show.premiere = document.data()["Premiere"]! as! String
                                    show.seasons = document.data()["Seasons"]! as! String
                                    show.status = document.data()["Status"]! as! String
                                    show.title = document.data()["Title"]! as! String
                                    let serviceName = document.data()["Service"]! as! String
                                    for service in ServiceModel.serviceArray {
                                        if service.name == serviceName {
                                            show.service = service
                                        }
                                    }
                                    UserModel.user.shows["want"]!.append(show)

                                }
                            }
                        }
                    }
                    let tabViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabViewController) as? UITabBarController
                    self.view.window?.rootViewController = tabViewController
                    self.view.window?.makeKeyAndVisible()
                }
            }
        }
    }
    

}
