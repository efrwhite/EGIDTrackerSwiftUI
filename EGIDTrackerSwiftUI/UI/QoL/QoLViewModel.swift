//
//  QoLViewModel.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/31/26.
//

import Foundation
import Combine

@MainActor
final class QoLViewModel: ObservableObject {
    
    @Published var visitDate: Date = Date()
    @Published var answers: [String] = Array(repeating: "", count: 31)
    
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var saveSucceeded = false
    
    private let dbService = FirebaseDBService()
    
    let sectionedQuestions: [(title: String, questions: [String])] = [
        (
            "Symptoms I",
            [
                "I have chest pain, ache, or hurt",
                "I have burning in my chest, mouth, or throat (heartburn)",
                "I have stomach aches or belly aches",
                "I throw up (vomit)",
                "I feel like I am going to throw up, but I don't (nausea)",
                "When I am eating, food comes back up my throat"
            ]
        ),
        (
            "Symptoms II",
            [
                "I have trouble swallowing",
                "I feel like food gets stuck in my throat or chest",
                "I need to drink to help me swallow my food",
                "I need more time to eat than other kids my age"
            ]
        ),
        (
            "Treatment",
            [
                "It is hard for me to take my medicine",
                "I do not want to take my medicines",
                "I do not like going to the doctor",
                "I do not like getting an endoscopy (scope, EGD)",
                "I do not like getting allergy testing"
            ]
        ),
        (
            "Worry",
            [
                "I worry about having EoE",
                "I worry about getting sick in front of other people",
                "I worry about what other people think about me because of EoE",
                "I worry about getting allergy testing"
            ]
        ),
        (
            "Communication",
            [
                "I have trouble telling other people about EoE",
                "I have trouble talking to my parents about how I feel",
                "I have trouble talking to other adults about how I feel",
                "I have trouble talking to my friends about how I feel",
                "I have trouble talking to doctors or nurses about how I feel"
            ]
        ),
        (
            "Food and Eating",
            [
                "It is hard not being allowed to eat some foods",
                "It is hard for me not to sneak foods I'm allergic to",
                "It is hard for me not to eat the same things as my family",
                "It is hard not to eat the same things as my friends"
            ]
        ),
        (
            "Food Feelings",
            [
                "I worry about eating foods I'm allergic to or not supposed to eat",
                "I feel mad (get upset) about not eating foods I am allergic to or not supposed to eat",
                "I feel sad about not eating foods I am allergic to or not supposed to eat"
            ]
        )
    ]
    
    var flatQuestions: [String] {
        sectionedQuestions.flatMap { $0.questions }
    }
    
    var totalScore: Int {
        answers.compactMap { Int($0) }.reduce(0, +)
    }
    
    func save() async {
        errorMessage = nil
        
        guard !answers.contains(where: { $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }) else {
            errorMessage = "Please fill out all fields before saving."
            return
        }
        
        for (index, answer) in answers.enumerated() {
            guard let number = Int(answer), (0...4).contains(number) else {
                errorMessage = "Question \(index + 1): Enter a number between 0 and 4."
                return
            }
        }
        
        guard let childId = dbService.getCurrentChildId() else {
            errorMessage = "No child selected."
            return
        }
        
        let numericResponses = answers.compactMap { Int($0) }
        
        isLoading = true
        
        do {
            try await dbService.saveQoLScore(
                childId: childId,
                totalScore: totalScore,
                responses: numericResponses,
                date: visitDate
            )
            saveSucceeded = true
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
}
