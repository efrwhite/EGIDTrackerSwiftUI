//
//  DietModels.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/18/26.
//

import Foundation

struct DietFoodSection: Identifiable {
    let id = UUID()
    let title: String
    let foods: [String]
}

struct DietPageModel {
    let title: String
    let subtitle: String
    let sections: [DietFoodSection]
}
