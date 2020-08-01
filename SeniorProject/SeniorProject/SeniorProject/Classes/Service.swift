//
//  File.swift
//  SeniorProject
//
//  Created by Jake Loveland on 5/7/20.
//  Copyright © 2020 Jake Loveland. All rights reserved.
//

import Foundation

class Service: Hashable {
    static func == (lhs: Service, rhs: Service) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var id = ""
    var name = ""
    var imageName = ""
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(identifier)
    }
    
    private let identifier = UUID()
}
