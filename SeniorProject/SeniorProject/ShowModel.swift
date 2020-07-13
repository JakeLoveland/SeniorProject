//
//  ShowModel.swift
//  SeniorProject
//
//  Created by Jake Loveland on 5/7/20.
//  Copyright © 2020 Jake Loveland. All rights reserved.
//

import Foundation
import FirebaseFirestore

class ShowModel {
    
    static var showArray = [String: [Show]]()
    static func getShows(){
    
        let db = Firestore.firestore()
        for service in ServiceModel.serviceArray {
        db.collection("services").document(service.id).collection("shows").getDocuments { (querySnapshot, err) in
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
                        show.service = service
                        if var items = showArray[service.name] {
                            items.append(show)
                            showArray[service.name] = items
                        }
                        else {
                            showArray[service.name] = [show]
                        }
                    }
                }
            }
        }
    }
        

}
