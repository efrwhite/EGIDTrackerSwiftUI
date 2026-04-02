//
//  SymptomCheckerViewModel.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/31/26.
//

import Foundation
import Combine

@MainActor
final class SymptomCheckerViewModel: ObservableObject {
    
    @Published var visitDate: Date = Date()
    
    // Questions 1-20: numeric 0...4
    @Published var numericAnswers: [String] = Array(repeating: "", count: 20)
    
    // Questions 21-32: yes/no
    @Published var yesNoAnswers: [Bool] = Array(repeating: false, count: 12)
    
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var saveSucceeded = false
    @Published var goToResults = false
    
    private let dbService = FirebaseDBService()
    
    let numericQuestions: [String] = [
        "How often does your child have trouble swallowing?",
        "How bad is your child's trouble swallowing?",
        "How often does your child feel like food gets stuck in their throat or chest?",
        "How bad is it when your child gets food stuck in their throat or chest?",
        "How often does your child need to drink a lot to help them swallow food?",
        "How bad is it when your child needs to drink a lot to help them swallow food?",
        "How often does your child eat less than others?",
        "How often does your child need more time to eat than other kids?",
        "How often does your child have heartburn (burning in the chest, mouth or throat)?",
        "How bad is your child's heartburn (burning in the chest, mouth or throat)?",
        "How often does your child have food come back up in their throat when eating?",
        "How bad is it when food comes back up in your child's throat?",
        "How often does your child vomit (throw up)?",
        "How bad is your child's vomiting?",
        "How often does your child feel nauseous (feel like throwing up, but doesn't)?",
        "How bad is your child's nausea (feel like throwing up, but doesn't)?",
        "How often does your child have chest pain, ache, or hurt?",
        "How bad is your child's chest pain, ache, or hurt?",
        "How often does your child have stomach aches or belly aches?",
        "How bad are your child's stomach aches or belly aches?"
    ]
    
    let yesNoQuestions: [String] = [
        "Feeding is difficult / refuses food",
        "Slow eating",
        "Prolonged chewing",
        "Swallowing liquids with solid food",
        "Avoidance of solid food",
        "Retching",
        "Choking",
        "Food Impaction",
        "Hoarseness",
        "Constipation",
        "Poor weight gain",
        "Diarrhea"
    ]
    
    var totalScore: Int {
        let numericScore = numericAnswers.compactMap { Int($0) }.reduce(0, +)
        let yesNoScore = yesNoAnswers.filter { $0 }.count
        return numericScore + yesNoScore
    }
    
    func save() async {
        errorMessage = nil
        
        guard allFieldsFilled else {
            errorMessage = "Please fill out all fields before saving."
            return
        }
        
        guard validateInputs() else { return }
        guard let childId = dbService.getCurrentChildId() else {
            errorMessage = "No child selected."
            return
        }
        
        let responses = collectResponses()
        let descriptions = collectSymptomDescriptions()
        
        isLoading = true
        
        do {
            try await dbService.saveSymptomScore(
                childId: childId,
                totalScore: totalScore,
                responses: responses,
                symptomDescriptions: descriptions,
                date: visitDate
            )
            saveSucceeded = true
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    private var allFieldsFilled: Bool {
        !numericAnswers.contains { $0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }
    
    private func validateInputs() -> Bool {
        for (index, answer) in numericAnswers.enumerated() {
            guard let number = Int(answer), (0...4).contains(number) else {
                errorMessage = "Question \(index + 1): Enter a number between 0 and 4."
                return false
            }
        }
        return true
    }
    
    private func collectResponses() -> [String] {
        var responses = numericAnswers.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        responses.append(contentsOf: yesNoAnswers.map { $0 ? "y" : "n" })
        return responses
    }
    
    private func collectSymptomDescriptions() -> [String] {
        yesNoQuestions.enumerated().compactMap { index, question in
            yesNoAnswers[index] ? question : nil
        }
    }
}
