//
//  ProfileCollectionViewCell.swift
//  SeniorProject
//
//  Created by Jake Loveland on 7/12/20.
//  Copyright © 2020 Jake Loveland. All rights reserved.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    static var identifier: String = "ProfileCell"

        weak var textLabel: UILabel!

        override init(frame: CGRect) {
            super.init(frame: frame)

            let textLabel = UILabel(frame: .zero)
            textLabel.translatesAutoresizingMaskIntoConstraints = false
            textLabel.backgroundColor = UIColor.gray
            self.contentView.addSubview(textLabel)
            NSLayoutConstraint.activate([
                self.contentView.centerXAnchor.constraint(equalTo: textLabel.centerXAnchor),
                self.contentView.centerYAnchor.constraint(equalTo: textLabel.centerYAnchor),
                textLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
                textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
                textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
                textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            ])
            self.textLabel = textLabel
            self.reset()
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func prepareForReuse() {
            super.prepareForReuse()
            self.reset()
        }

        func reset() {
            self.textLabel.textAlignment = .center
        }
    }
