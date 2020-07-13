//
//  User.swift
//  SeniorProject
//
//  Created by Jake Loveland on 5/17/20.
//  Copyright © 2020 Jake Loveland. All rights reserved.
//

import Foundation

class User {
    
    var id = ""
    var firstname = ""
    var lastname = ""
    var services: [Service]?
    var shows: [String : [Show]] = ["watched" : [], "watching" : [], "want" : []]
}
