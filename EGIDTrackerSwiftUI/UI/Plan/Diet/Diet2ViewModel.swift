//
//  Diet2ViewModel.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/18/26.
//

import Foundation

final class Diet2ViewModel {
    
    let diet = DietPageModel(
        title: "Diet 2",
        subtitle: "Foods to Avoid",
        sections: [
            DietFoodSection(title: "Dairy", foods: DietFoodLibrary.dairy),
            DietFoodSection(title: "Gluten", foods: DietFoodLibrary.gluten)
        ]
    )
}
