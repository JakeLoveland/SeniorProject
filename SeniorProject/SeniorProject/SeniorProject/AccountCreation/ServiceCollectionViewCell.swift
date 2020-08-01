//
//  ServiceCollectionViewCell.swift
//  SeniorProject
//
//  Created by Jake Loveland on 5/7/20.
//  Copyright © 2020 Jake Loveland. All rights reserved.
//

import UIKit

class ServiceCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var serviceImageView: UIImageView!
    @IBOutlet weak var serviceLabel: UILabel!
    
    var chosen:Bool = false
    
    func setService(_ service: Service) {
        
        serviceImageView.image = UIImage(named: service.imageName)
        serviceImageView.alpha = 0.5
        serviceLabel.text = service.name
        
        if chosen == true{
            serviceImageView.alpha = 1
        }
        
    }
    
    func choose() {
        serviceImageView.alpha = 1
    }
    
    func unchoose() {
        serviceImageView.alpha = 0.5
    }
    
}
