//
//  ServiceModel.swift
//  SeniorProject
//
//  Created by Jake Loveland on 5/7/20.
//  Copyright © 2020 Jake Loveland. All rights reserved.
//

import Foundation
import FirebaseFirestore

class ServiceModel {
    static var serviceArray = [Service]()
    static func getServices(){
        
        let db = Firestore.firestore()
        db.collection("services").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let service1 = Service()
                    service1.name = document.data()["name"]! as! String
                    service1.imageName = document.data()["logo"]! as! String
                    service1.id = document.data()["id"]! as! String
                    ServiceModel.serviceArray.append(service1)
                    

                }
            }
        }
    }
    
    
    
    
}
