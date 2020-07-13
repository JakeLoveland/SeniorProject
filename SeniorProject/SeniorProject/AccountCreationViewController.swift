//
//  AccountCreationViewController.swift
//  SeniorProject
//
//  Created by Jake Loveland on 5/4/20.
//  Copyright © 2020 Jake Loveland. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class AccountCreationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var repasswordField: UITextField!
    
    @IBOutlet weak var ContinueButton: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        ShowModel.getShows()
        firstNameField.delegate = self
        lastNameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        repasswordField.delegate = self
        // Do any additional setup after loading the view.
    }
    

    
    func validateFields() -> String? {
        
        if firstNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || repasswordField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        
        if passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines) != repasswordField.text!.trimmingCharacters(in: .whitespacesAndNewlines) {
            return "Please ensue Password field and Re-Enter Password field are the same."
        }
        
        return nil
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        
        let error = validateFields()
        if error != nil {
            //TODO: - Show error
        }
        else {
            
            let firstname = firstNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastname = lastNameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

            
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                if err != nil {
                    print(err!)
                    //TODO: - Show error
                }
                else {
                    let db = Firestore.firestore()
                    db.collection("users").document(result!.user.uid).setData(["first_name":firstname, "last_name":lastname, "uid":result!.user.uid]) { (error) in
                        if error != nil {
                            //TODO: - Show error
                        }
                    }
                    UserModel.user.firstname = firstname
                    UserModel.user.lastname = lastname
                    UserModel.user.id = result!.user.uid
                }
            }
        }
    }
    
    
    
}
