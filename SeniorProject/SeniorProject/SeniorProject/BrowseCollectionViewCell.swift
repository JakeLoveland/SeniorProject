//
//  BrowseCollectionViewCell.swift
//  SeniorProject
//
//  Created by Jake Loveland on 7/30/20.
//  Copyright © 2020 Jake Loveland. All rights reserved.
//

import UIKit

class BrowseCollectionViewCell: UICollectionViewCell {
    static let serviceReuseIdentifer = "service-cell-reuse-identifier"
    static let genreReuseIdentifer = "service-cell-reuse-identifier"
    static let recommendedReuseIdentifer = "recommended-cell-reuse-identifier"
        let titleLabel = UILabel()
          let featuredPhotoView = UIImageView()
          let contentContainer = UIStackView()
          var type: String = ""
          var title: String? {
            didSet {
              configure()
            }
          }

          var featuredPhotoURL: String? {
            didSet {
              configure()
            }
          }

          override init(frame: CGRect) {
            super.init(frame: frame)
            configure()
          }

          required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
          }
        }

        extension BrowseCollectionViewCell {
          func configure() {
            contentContainer.translatesAutoresizingMaskIntoConstraints = false
            contentContainer.axis = .vertical
            contentContainer.alignment = .fill
            contentContainer.distribution = .fill
            contentContainer.spacing = 5
            contentView.addSubview(contentContainer)

            featuredPhotoView.translatesAutoresizingMaskIntoConstraints = false
            if let featuredPhotoURL = featuredPhotoURL {
              featuredPhotoView.image = UIImage(named: featuredPhotoURL)
            }
            featuredPhotoView.clipsToBounds = true
            featuredPhotoView.alpha = 0.5
            contentContainer.addArrangedSubview(featuredPhotoView)

            titleLabel.translatesAutoresizingMaskIntoConstraints = false
            titleLabel.text = title
            titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
            titleLabel.adjustsFontForContentSizeCategory = true
            titleLabel.textColor = .black
            titleLabel.textAlignment = .center
            titleLabel.layer.masksToBounds = false
            contentContainer.addArrangedSubview(titleLabel)

            NSLayoutConstraint.activate([
              contentContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
              contentContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
              contentContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
              contentContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            ])
          }
        }


    class BrowseHeaderView: UICollectionReusableView {
      static let reuseIdentifier = "browse-header-reuse-identifier"

      let label = UILabel()

      override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
      }

      required init?(coder: NSCoder) {
        fatalError()
      }
    }

    extension BrowseHeaderView {
      func configure() {
        backgroundColor = .systemBackground

        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true

        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
          label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
          label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
          label.topAnchor.constraint(equalTo: topAnchor, constant: inset),
          label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset)
        ])
        label.font = UIFont.preferredFont(forTextStyle: .title3)
      }
    }

