//
//  ShowSelectViewController.swift
//  SeniorProject
//
//  Created by Jake Loveland on 5/7/20.
//  Copyright © 2020 Jake Loveland. All rights reserved.
//

import UIKit
import Firebase

class ShowSelectViewController: UIViewController {
    
    
    static let sectionHeaderElementKind = "section-header-element-kind"
    enum Section: String, CaseIterable {
        case hulu = "Hulu"
        case youtube = "YouTube Originals"
        case hbo = "HBO"
        case disney = "Disney Plus"
        case netflix = "Netflix"
        case prime = "Amazon Prime Video"
    }

    @IBOutlet weak var showCollectionView: UICollectionView!
        
    var userShows = [Show]()
    var dataSource: UICollectionViewDiffableDataSource<Section, Show>! = nil
    var showsCollectionView: UICollectionView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
    }
    
    @IBAction func finishButtonTapped(_ sender: Any) {
                
        for show in userShows {
            addShow(show)
        }
        UserModel.user.shows["watched"] = userShows
        
    }
    
    func addShow(_ show: Show) {
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser
        if let user = user {
            let showObj = [
                "Title": show.title,
                "Genre": show.genre,
                "Premiere": show.premiere,
                "Seasons": show.seasons,
                "Status": show.status,
                "Service": show.service?.name]
            db.collection("users/\(user.uid)/watched").document(show.title).setData(showObj as [String : Any]) { err in
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

extension ShowSelectViewController {
    
    func configureCollectionView() {
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 250, width: view.frame.size.width, height: view.frame.size.height - 400), collectionViewLayout: generateLayout())
        view.addSubview(collectionView)
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.register(ShowCollectionViewCell.self, forCellWithReuseIdentifier: ShowCollectionViewCell.reuseIdentifer)
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: ShowSelectViewController.sectionHeaderElementKind, withReuseIdentifier: HeaderView.reuseIdentifier)

        showCollectionView = collectionView
    }

      func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource
          <Section, Show>(collectionView: showCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, show: Show) -> UICollectionViewCell? in
            let sectionType = Section.allCases[indexPath.section]
            switch sectionType {
            default:
              guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ShowCollectionViewCell.reuseIdentifer,
                for: indexPath) as? ShowCollectionViewCell
              else { fatalError("Could not create new cell") }
              
              cell.featuredPhotoURL = show.service?.imageName
              cell.title = show.title
              return cell
            }

        }
        
        dataSource.supplementaryViewProvider = { (
          collectionView: UICollectionView,
          kind: String,
          indexPath: IndexPath)
            -> UICollectionReusableView? in

          guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: HeaderView.reuseIdentifier,
            for: indexPath) as? HeaderView else {
              fatalError("Cannot create header view")
          }

            supplementaryView.label.text = UserModel.user.services![indexPath.section].name
          return supplementaryView
        }

        let snapshot = snapshotForCurrentState()
        print(snapshot.numberOfSections)
        dataSource.apply(snapshot, animatingDifferences: false)
      }

      func generateLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
          layoutEnvironment: NSCollectionLayoutEnvironment)
            -> NSCollectionLayoutSection? in
          let isWideView = layoutEnvironment.container.effectiveContentSize.width > 500

          let sectionLayoutKind = Section.allCases[sectionIndex]
          switch (sectionLayoutKind) {
          default: return self.generateServiceLayout(
            isWide: isWideView)
    
          }
        }
        return layout
      }
    
      func generateServiceLayout(isWide: Bool) -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .fractionalWidth(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
          widthDimension: .absolute(140),
          heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.vertical(
          layoutSize: groupSize,
          subitem: item,
          count: 1)
        group.contentInsets = NSDirectionalEdgeInsets(
          top: 5,
          leading: 5,
          bottom: 5,
          trailing: 5)

        let headerSize = NSCollectionLayoutSize(
          widthDimension: .fractionalWidth(1.0),
          heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
          layoutSize: headerSize,
          elementKind: ShowSelectViewController.sectionHeaderElementKind,
          alignment: .top)

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [sectionHeader]
        section.orthogonalScrollingBehavior = .groupPaging

        return section
      }

      func snapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, Show> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Show>()
        for service in UserModel.user.services! {
            let allShows = ShowModel.showArray[service.name]
            snapshot.appendSections([Section(rawValue: service.name)!])
            snapshot.appendItems(allShows!, toSection: Section(rawValue: service.name)!)
        }


        return snapshot
      }

}

extension ShowSelectViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ShowCollectionViewCell
        if cell.featuredPhotoView.alpha == 0.5 {
            cell.featuredPhotoView.alpha = 1
            userShows.append(ShowModel.showArray[UserModel.user.services![indexPath.section].name]![indexPath.row])
        }else {
            cell.featuredPhotoView.alpha = 0.5
            let show = ShowModel.showArray[UserModel.user.services![indexPath.section].name]![indexPath.row]
            for i in 0...userShows.count-1 {
                if userShows[i].title == show.title {
                    userShows.remove(at: i)
                    break
                }
            }
        }
        
    }
}


