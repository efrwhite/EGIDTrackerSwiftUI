//
//  ProfileModels.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/18/26.
//

import Foundation

struct CaregiverProfile {
    let id: String?
    var username: String
    var firstName: String
    var lastName: String
    var imageUrl: String
}

struct ChildProfile {
    let id: String?
    var firstName: String
    var lastName: String
    var birthDate: String
    var gender: String
    var diet: String
    var imageUrl: String
}
