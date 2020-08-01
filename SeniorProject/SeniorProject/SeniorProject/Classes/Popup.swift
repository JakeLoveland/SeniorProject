//
//  Popup.swift
//  SeniorProject
//
//  Created by Jake Loveland on 7/28/20.
//  Copyright © 2020 Jake Loveland. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Popup {
    
    var window: UIView?
    var show: Show?
    let section: String?
    var collectionView: UICollectionView?
    var index: IndexPath?
    
    init(section: String) {
        self.section = section
    }
    
    func display(show: Show) {
        self.show = show
        let horiz = UIStackView(frame: .zero)
        self.window = horiz
        horiz.tag = 100
        let image = UIImage(named: show.service!.imageName)
        let imageView = UIImageView(image: image)
        imageView.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let vert = UIStackView(frame: .zero)
        vert.axis = .vertical
        vert.translatesAutoresizingMaskIntoConstraints = false
        let exitStack = UIStackView(frame: .zero)
        exitStack.axis = .horizontal
        let exitButton = UIButton(type: .system)
        exitButton.setTitle("x", for: .normal)
        exitButton.backgroundColor = UIColor.red
        exitButton.addTarget(self, action: #selector(exitAction), for: .touchUpInside)
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        let title = UILabel(frame: .zero)
        title.backgroundColor = UIColor.yellow
        title.text = show.title
        title.font = UIFont.boldSystemFont(ofSize: 16.0)
        title.translatesAutoresizingMaskIntoConstraints = false
        exitStack.addArrangedSubview(title)
        exitStack.addArrangedSubview(exitButton)
        vert.addArrangedSubview(exitStack)
        let service = UILabel(frame: .zero)
        service.text = show.service?.name
        service.backgroundColor = UIColor.yellow
        service.translatesAutoresizingMaskIntoConstraints = false
        vert.addArrangedSubview(service)
        let genre = UILabel(frame: .zero)
        genre.text = show.genre
        genre.backgroundColor = UIColor.yellow
        genre.translatesAutoresizingMaskIntoConstraints = false
        vert.addArrangedSubview(genre)
        let seasons = UILabel(frame: .zero)
        seasons.text = show.seasons
        seasons.backgroundColor = UIColor.yellow
        seasons.translatesAutoresizingMaskIntoConstraints = false
        vert.addArrangedSubview(seasons)
        let premiere = UILabel(frame: .zero)
        premiere.text = String(format: "Premiere: %@", show.premiere)
        premiere.backgroundColor = UIColor.yellow
        premiere.translatesAutoresizingMaskIntoConstraints = false
        vert.addArrangedSubview(premiere)
        
        let buttons = UIStackView(frame: .zero)
        buttons.axis = .horizontal
        buttons.translatesAutoresizingMaskIntoConstraints = false
        let button1 = UIButton(type: .custom)
        button1.setTitle("Watched", for: .normal)
        button1.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        button1.titleLabel?.textColor = UIColor.black
        button1.translatesAutoresizingMaskIntoConstraints = false
        if self.section == "watched" {
            button1.backgroundColor = UIColor.gray
            button1.alpha = 0.5
            button1.isEnabled = false
        } else {
            button1.backgroundColor = UIColor.blue
        }
        button1.addTarget(self, action: #selector(button1Action), for: .touchUpInside)
        buttons.addArrangedSubview(button1)
        let button2 = UIButton(type: .custom)
        button2.setTitle("Watching", for: .normal)
        button2.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        button2.titleLabel?.textColor = UIColor.black
        button2.translatesAutoresizingMaskIntoConstraints = false
        if self.section == "watching" {
            button2.alpha = 0.5
            button2.backgroundColor = UIColor.gray
            button2.isEnabled = false
        } else {
            button2.backgroundColor = UIColor.blue
        }
        button2.addTarget(self, action: #selector(button2Action), for: .touchUpInside)
        buttons.addArrangedSubview(button2)
        let button3 = UIButton(type: .custom)
        button3.setTitle("Want to Watch", for: .normal)
        button3.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        button3.titleLabel?.textColor = UIColor.black
        button3.translatesAutoresizingMaskIntoConstraints = false
        if self.section == "want" {
            button3.alpha = 0.5
            button3.backgroundColor = UIColor.gray
            button3.isEnabled = false
        } else {
            button3.backgroundColor = UIColor.blue
        }
        button3.addTarget(self, action: #selector(button3Action), for: .touchUpInside)
        buttons.addArrangedSubview(button3)
        
        buttons.spacing = 3
        vert.addArrangedSubview(buttons)
        
        horiz.translatesAutoresizingMaskIntoConstraints = false
        horiz.axis = .horizontal
        horiz.addArrangedSubview(imageView)
        horiz.addArrangedSubview(vert)
        horiz.backgroundColor = UIColor.blue
    }
        
    @objc func button1Action() {
        moveTo(location: "watched")
        collectionView!.deleteItems(at: [index!])
        exit()
    }
    @objc func button2Action() {
        moveTo(location: "watching")
        collectionView!.deleteItems(at: [index!])
        print(self.show!)
        exit()
    }
    @objc func button3Action() {
        moveTo(location: "want")
        collectionView!.deleteItems(at: [index!])
        exit()
    }
    
    @objc func exitAction(){
        exit()
    }
    
    func exit() {
        self.window!.removeFromSuperview()
        self.window = nil
    }
    
    func moveTo(location: String){
        var i = 0
        if self.section != "browse" {
            for myShow in UserModel.user.shows[self.section!]! {
                if self.show!.title == myShow.title {
                    UserModel.user.shows[self.section!]!.remove(at: i)
                }
                i = i + 1
            }
        }
        UserModel.user.shows[location]!.append(self.show!)
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        if let user = user {
            db.collection("users/\(user.uid)/\(self.section!)").document(self.show!.title).delete()
            let showObj = [
                "Title": self.show?.title,
                "Genre": self.show?.genre,
                "Premiere": self.show?.premiere,
                "Seasons": self.show?.seasons,
                "Status": self.show?.status,
                "Service": self.show?.service?.name]
            db.collection("users/\(user.uid)/\(location)").document(show!.title).setData(showObj as [String : Any]) { err in
                if let err = err {
                    print("Error writing User Show: \(err)")
                } else {
                    print("User Show successfully written!")
                }
            }
        }
        else {
            print("error")
        }
        
    }

}
