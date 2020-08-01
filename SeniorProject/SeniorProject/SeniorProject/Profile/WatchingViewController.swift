//
//  WatchingViewController.swift
//  SeniorProject
//
//  Created by Jake Loveland on 7/28/20.
//  Copyright © 2020 Jake Loveland. All rights reserved.
//

import UIKit

class WatchingViewController: UIViewController {

    
    @IBOutlet weak var nameLabel: UILabel!
    
    weak var collectionView: UICollectionView!
    
    let popup : Popup = Popup(section: "watching")
    

        override func viewDidLoad() {
            super.viewDidLoad()
            nameLabel.text = String(format: "%@ %@", UserModel.user.firstname, UserModel.user.lastname)
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(collectionView)
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20),
                collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
                collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ])
            self.collectionView = collectionView
            popup.collectionView = self.collectionView
            self.collectionView.dataSource = self
            self.collectionView.delegate = self
            self.collectionView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: ProfileCollectionViewCell.identifier)
            self.collectionView.alwaysBounceVertical = true
            self.collectionView.backgroundColor = .white
        }
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
        if popup.window != nil {
            popup.exit()
        }
    }
}

    extension WatchingViewController: UICollectionViewDataSource {

        func collectionView(_ collectionView: UICollectionView,
                            numberOfItemsInSection section: Int) -> Int {
            return UserModel.user.shows["watching"]!.count
        }

        func collectionView(_ collectionView: UICollectionView,
                            cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCollectionViewCell.identifier, for: indexPath) as! ProfileCollectionViewCell
            let show = UserModel.user.shows["watching"]![indexPath.item]
            cell.textLabel.text = show.title
            return cell
        }
    }

    extension WatchingViewController: UICollectionViewDelegate {

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if popup.window == nil {
                popup.display(show: UserModel.user.shows["watching"]![indexPath.row])
                popup.index = indexPath
                self.view.addSubview(popup.window!)
                NSLayoutConstraint.activate([
                    popup.window!.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
                    popup.window!.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
                ])
            }
                
        }
        
    }

    extension WatchingViewController: UICollectionViewDelegateFlowLayout {

        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.bounds.width/2, height: collectionView.bounds.height/4)
        }

        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) //.zero
        }

        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }

        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }
    }
