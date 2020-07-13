//
//  HomeViewController.swift
//  SeniorProject
//
//  Created by Jake Loveland on 5/4/20.
//  Copyright © 2020 Jake Loveland. All rights reserved.
//

import UIKit
import FBSDKShareKit

class HomeViewController: UIViewController, GraphRequestConnectionDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("test")
        let graphRequestConnection = GraphRequestConnection()

        
        let graphRequest = GraphRequest(graphPath: "me/friends", parameters: ["fields": "name"])
        
        graphRequestConnection.add(graphRequest) { (httpResponse, result, error) in
            if error != nil {
                print(error!)
            }
            else {
                print(result!)
            }

        }

        graphRequestConnection.start()

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
