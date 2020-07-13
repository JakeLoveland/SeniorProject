//
//  ProfileViewController.swift
//  SeniorProject
//
//  Created by Jake Loveland on 6/7/20.
//  Copyright © 2020 Jake Loveland. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITabBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    

    @IBOutlet weak var watchedTab: UITabBarItem!
    @IBOutlet weak var wantTab: UITabBarItem!
    @IBOutlet weak var watchingTab: UITabBarItem!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var profileCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        watchedTab.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Arial", size: 20) as Any], for: .normal)
        watchingTab.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Arial", size: 20) as Any], for: .normal)
        wantTab.setTitleTextAttributes([NSAttributedString.Key.font: UIFont(name: "Arial", size: 20) as Any], for: .normal)
        
        tabBar.delegate = self

        profileCollectionView.delegate = self
        profileCollectionView.dataSource = self
            
    }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return UserModel.user.shows["watched"]!.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as! ServiceCollectionViewCell
            
            let show = UserModel.user.shows["watched"][indexPath.row]

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
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 0:
            
        case 1:
            profileCollectionView.numberOfItems(inSection: 0) = UserModel.user.shows["watching"]!.count
        case 2:
            profileCollectionView.numberOfItems(inSection: 0) = UserModel.user.shows["want"]!.count
        default:
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
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
