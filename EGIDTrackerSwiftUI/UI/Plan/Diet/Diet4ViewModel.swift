//
//  Diet4ViewModel.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/18/26.
//

import Foundation

final class Diet4ViewModel {
    
    let diet = DietPageModel(
        title: "Diet 4",
        subtitle: "Foods to Avoid",
        sections: [
            DietFoodSection(title: "Dairy", foods: DietFoodLibrary.dairy),
            DietFoodSection(title: "Gluten", foods: DietFoodLibrary.gluten),
            DietFoodSection(title: "Egg", foods: DietFoodLibrary.egg),
            DietFoodSection(title: "Soy", foods: DietFoodLibrary.soy)
        ]
    )
}
