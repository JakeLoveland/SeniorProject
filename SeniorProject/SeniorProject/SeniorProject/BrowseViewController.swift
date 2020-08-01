//
//  BrowseViewController.swift
//  SeniorProject
//
//  Created by Jake Loveland on 7/30/20.
//  Copyright © 2020 Jake Loveland. All rights reserved.
//

import UIKit
import Firebase

class BrowseViewController: UIViewController {
        
    let popup : Popup = Popup(section: "browse")
    static let sectionHeaderElementKind = "section-header-element-kind"
    enum Section: String, CaseIterable {
        case services = "Services"
        case genres = "Genres"
        case recommended = "Recommended Shows"
    }

    var serviceCollectionView: UICollectionView! = nil
    var genreCollectionView: UICollectionView! = nil
    var recommendedCollectionView: UICollectionView! = nil

    var serviceDataSource: UICollectionViewDiffableDataSource<Section, Service>! = nil
    var genreDataSource: UICollectionViewDiffableDataSource<Section, String>! = nil
    var recommendedDataSource: UICollectionViewDiffableDataSource<Section, Show>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
    }
    
override func viewWillAppear(_ animated: Bool) {
    serviceCollectionView.reloadData()
    genreCollectionView.reloadData()
    recommendedCollectionView.reloadData()
    if popup.window != nil {
        popup.exit()
    }
}
        
        
    }

    extension BrowseViewController {
        
        func configureCollectionView() {
            let sCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 400, height: 200), collectionViewLayout: generateLayout())
            let gCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 400, height: 200), collectionViewLayout: generateLayout())
            let rCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 400, height: 200), collectionViewLayout: generateLayout())
            let stack = UIStackView(frame: .zero)
            stack.axis = .vertical
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.addArrangedSubview(sCollectionView)
            stack.addArrangedSubview(gCollectionView)
            stack.addArrangedSubview(rCollectionView)

            view.addSubview(stack)
            NSLayoutConstraint.activate([
                stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
                stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
                stack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                stack.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
            sCollectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            gCollectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            rCollectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            
            sCollectionView.backgroundColor = .systemBackground
            gCollectionView.backgroundColor = .systemBackground
            rCollectionView.backgroundColor = .systemBackground
            
            sCollectionView.delegate = self
            gCollectionView.delegate = self
            rCollectionView.delegate = self
            
            sCollectionView.register(BrowseCollectionViewCell.self, forCellWithReuseIdentifier: BrowseCollectionViewCell.serviceReuseIdentifer)
            gCollectionView.register(BrowseCollectionViewCell.self, forCellWithReuseIdentifier: BrowseCollectionViewCell.genreReuseIdentifer)
            rCollectionView.register(BrowseCollectionViewCell.self, forCellWithReuseIdentifier: BrowseCollectionViewCell.recommendedReuseIdentifer)
            
            sCollectionView.register(BrowseHeaderView.self, forSupplementaryViewOfKind: BrowseViewController.sectionHeaderElementKind, withReuseIdentifier: BrowseHeaderView.reuseIdentifier)
            gCollectionView.register(BrowseHeaderView.self, forSupplementaryViewOfKind: BrowseViewController.sectionHeaderElementKind, withReuseIdentifier: BrowseHeaderView.reuseIdentifier)
            rCollectionView.register(BrowseHeaderView.self, forSupplementaryViewOfKind: BrowseViewController.sectionHeaderElementKind, withReuseIdentifier: BrowseHeaderView.reuseIdentifier)

            serviceCollectionView = sCollectionView
            genreCollectionView = gCollectionView
            recommendedCollectionView = rCollectionView
        }

          func configureDataSource() {
            
            
            
            serviceDataSource = UICollectionViewDiffableDataSource
              <Section, Service>(collectionView: serviceCollectionView) {
                (collectionView: UICollectionView, indexPath: IndexPath, service: Service) -> UICollectionViewCell? in
                let sectionType = Section.allCases[indexPath.section]
                switch sectionType {
                default:
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: BrowseCollectionViewCell.serviceReuseIdentifer,
                        for: indexPath) as? BrowseCollectionViewCell
                        else { fatalError("Could not create new cell") }
                    
                    cell.featuredPhotoURL = service.imageName
                    cell.title = service.name
                    cell.type = "service"
                    return cell
                }
                
            }
            genreDataSource = UICollectionViewDiffableDataSource
              <Section, String>(collectionView: genreCollectionView) {
                (collectionView: UICollectionView, indexPath: IndexPath, string: String) -> UICollectionViewCell? in
                let sectionType = Section.allCases[indexPath.section]
                switch sectionType {
                default:
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: BrowseCollectionViewCell.serviceReuseIdentifer,
                        for: indexPath) as? BrowseCollectionViewCell
                        else { fatalError("Could not create new cell") }
                    
                    cell.featuredPhotoURL = "youtubelogo"
                    cell.title = string
                    cell.type = "genre"
                    return cell
                }
                
            }
            recommendedDataSource = UICollectionViewDiffableDataSource
              <Section, Show>(collectionView: serviceCollectionView) {
                (collectionView: UICollectionView, indexPath: IndexPath, show: Show) -> UICollectionViewCell? in
                let sectionType = Section.allCases[indexPath.section]
                switch sectionType {
                default:
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: BrowseCollectionViewCell.recommendedReuseIdentifer,
                        for: indexPath) as? BrowseCollectionViewCell
                        else { fatalError("Could not create new cell") }
                    
                    cell.featuredPhotoURL = show.service?.imageName
                    cell.title = show.title
                    cell.type = "recommended"
                    return cell
                }
                
            }
            print(recommendedDataSource)

            serviceDataSource.supplementaryViewProvider = { (
              collectionView: UICollectionView,
              kind: String,
              indexPath: IndexPath)
                -> UICollectionReusableView? in

              guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: BrowseHeaderView.reuseIdentifier,
                for: indexPath) as? BrowseHeaderView else {
                  fatalError("Cannot create header view")
              }

              supplementaryView.label.text = "Services"
              return supplementaryView
            }
            genreDataSource.supplementaryViewProvider = { (
              collectionView: UICollectionView,
              kind: String,
              indexPath: IndexPath)
                -> UICollectionReusableView? in

              guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: BrowseHeaderView.reuseIdentifier,
                for: indexPath) as? BrowseHeaderView else {
                  fatalError("Cannot create header view")
              }

              supplementaryView.label.text = "Genres"
              return supplementaryView
            }
            recommendedDataSource.supplementaryViewProvider = { (
              collectionView: UICollectionView,
              kind: String,
              indexPath: IndexPath)
                -> UICollectionReusableView? in

              guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: BrowseHeaderView.reuseIdentifier,
                for: indexPath) as? BrowseHeaderView else {
                  fatalError("Cannot create header view")
              }

              supplementaryView.label.text = "Recommended Shows"
              return supplementaryView
            }
            print(recommendedDataSource)

            let sSnapshot = sSnapshotForCurrentState()
            serviceDataSource.apply(sSnapshot, animatingDifferences: false)
            let gSnapshot = gSnapshotForCurrentState()
            genreDataSource.apply(gSnapshot, animatingDifferences: false)
            let rSnapshot = rSnapshotForCurrentState()
            recommendedDataSource.apply(rSnapshot, animatingDifferences: false)
            print(recommendedDataSource)
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
              elementKind: BrowseViewController.sectionHeaderElementKind,
              alignment: .top)

            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [sectionHeader]
            section.orthogonalScrollingBehavior = .continuous

            return section
          }

          func sSnapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, Service> {
            var snapshot = NSDiffableDataSourceSnapshot<Section, Service>()
            let allServices = ServiceModel.serviceArray
            snapshot.appendSections([Section(rawValue: "Services")!])
            snapshot.appendItems(allServices, toSection: Section(rawValue: "Services")!)
            return snapshot
          }
        func gSnapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, String> {
          var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
          let allGenres = ["Drama", "Comedy", "Reality"]
          snapshot.appendSections([Section(rawValue: "Genres")!])
          snapshot.appendItems(allGenres, toSection: Section(rawValue: "Genres")!)
          return snapshot
        }
        func rSnapshotForCurrentState() -> NSDiffableDataSourceSnapshot<Section, Show> {
          var snapshot = NSDiffableDataSourceSnapshot<Section, Show>()
            let allShows = UserModel.user.shows["watched"]!
          snapshot.appendSections([Section(rawValue: "Recommended Shows")!])
          snapshot.appendItems(allShows, toSection: Section(rawValue: "Recommended Shows")!)
          return snapshot
        }

    }

    extension BrowseViewController: UICollectionViewDelegate {
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let cell = collectionView.cellForItem(at: indexPath) as! BrowseCollectionViewCell
            if cell.type == "service" {
                
                print("service tapped")
                
                
            }else if cell.type == "genre" {
                
                
                print("genre tapped")

                
            }else if cell.type == "recommended" {
                
                if popup.window == nil {
                    popup.display(show: UserModel.user.shows["watched"]![indexPath.row])
                    popup.index = indexPath
                    self.view.addSubview(popup.window!)
                    NSLayoutConstraint.activate([
                        popup.window!.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
                        popup.window!.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor)
                    ])
                }
            }
        }
    }


