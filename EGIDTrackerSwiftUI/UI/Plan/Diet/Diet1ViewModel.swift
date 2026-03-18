//
//  Diet1ViewModel.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/18/26.
//

import Foundation

final class Diet1ViewModel {
    
    let diet: DietPageModel = DietPageModel(
        title: "Diet 1",
        subtitle: "Foods to Avoid",
        sections: [
            DietFoodSection(
                title: "Dairy",
                foods: [
                    "Baked goods",
                    "Butter",
                    "Buttermilk",
                    "Casein",
                    "Cheese",
                    "Chocolate",
                    "Condensed milk",
                    "Cottage cheese",
                    "Cream",
                    "Cream cheese",
                    "Curd",
                    "Custard",
                    "Evaporated milk",
                    "Ghee",
                    "Goat’s milk",
                    "Gravy",
                    "Half & half",
                    "Ice cream",
                    "Lactose",
                    "Margarine",
                    "Milk",
                    "Milk powder",
                    "Pastries",
                    "Pudding",
                    "Salad dressing",
                    "Sheep’s milk",
                    "Sour cream",
                    "Whey",
                    "Yogurt"
                ]
            )
        ]
    )
}
