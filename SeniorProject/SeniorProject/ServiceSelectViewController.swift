//
//  ServiceSelectViewController.swift
//  SeniorProject
//
//  Created by Jake Loveland on 5/7/20.
//  Copyright © 2020 Jake Loveland. All rights reserved.
//

import UIKit
import Firebase

class ServiceSelectViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    

    @IBOutlet weak var serviceCollectionView: UICollectionView!
        
    var userServices = [Service]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        serviceCollectionView.delegate = self
        serviceCollectionView.dataSource = self
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ServiceModel.serviceArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceCell", for: indexPath) as! ServiceCollectionViewCell
        
        let service = ServiceModel.serviceArray[indexPath.row]

        cell.setService(service)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! ServiceCollectionViewCell
             
        if cell.chosen == false {
            cell.chosen = true
            cell.choose()
            userServices.append(ServiceModel.serviceArray[indexPath.row])
        }
        else {
            cell.chosen = false
            cell.unchoose()
            let service = ServiceModel.serviceArray[indexPath.row]
            for i in 0...userServices.count-1 {
                if userServices[i].name == service.name {
                    userServices.remove(at: i)
                    break
                }
            }
        }

        
    }
    
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        
            
        for service in userServices {
            addService(service)
        }
        UserModel.user.services = userServices
        
    }
    
    func addService(_ service: Service) {
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        if let user = user {
            let serviceObj = [
                "name":service.name,
                "logo":service.imageName,
                "Id":service.id]
            db.collection("users/\(user.uid)/services").document(service.id).setData(serviceObj) { err in
                if let err = err {
                    print("Error writing User Service: \(err)")
                } else {
                    print("User Service successfully written!")
                }
            }
        }
        else {
            print("error")
        }

    }
}
