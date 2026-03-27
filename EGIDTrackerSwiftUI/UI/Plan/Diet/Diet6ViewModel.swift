//
//  Diet6ViewModel.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/18/26.
//

import Foundation

final class Diet6ViewModel {
    
    let diet = DietPageModel(
        title: "Diet 6",
        subtitle: "Foods to Avoid",
        sections: [
            DietFoodSection(title: "Dairy", foods: DietFoodLibrary.dairy),
            DietFoodSection(title: "Gluten", foods: DietFoodLibrary.gluten),
            DietFoodSection(title: "Egg", foods: DietFoodLibrary.egg),
            DietFoodSection(title: "Soy", foods: DietFoodLibrary.soy),
            DietFoodSection(title: "Peanut and Treenut", foods: DietFoodLibrary.peanutAndTreenut),
            DietFoodSection(title: "Fish and Shellfish", foods: DietFoodLibrary.fishAndShellfish)
        ]
    )
}
