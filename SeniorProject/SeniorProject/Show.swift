//
//  Show.swift
//  SeniorProject
//
//  Created by Jake Loveland on 5/7/20.
//  Copyright © 2020 Jake Loveland. All rights reserved.
//

import Foundation

class Show: Hashable {
    static func == (lhs: Show, rhs: Show) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    
    var title = ""
    var service: Service?
    var genre = ""
    var premiere = ""
    var seasons = ""
    var status = ""
    var category = ""
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(identifier)
    }
    
    private let identifier = UUID()
}
