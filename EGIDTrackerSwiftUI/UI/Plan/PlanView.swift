//
//  PlanView.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/18/26.
//

import SwiftUI

struct PlanView: View {
    
    @StateObject private var viewModel = PlanViewModel()
    
    @State private var goToDiet1 = false
    @State private var goToDiet2 = false
    @State private var goToDiet4 = false
    @State private var goToDiet6 = false
    @State private var goToDietNone = false
    
    @State private var goToAccidentalExposure = false
    @State private var goToMedications = false
    @State private var goToDocuments = false
    @State private var goToEndoscopy = false
    
    var body: some View {
        VStack(spacing: 20) {
            
            Text("Your Plan")
                .font(.largeTitle)
                .bold()
            
            VStack(spacing: 8) {
                Text("Check Plan For:")
                    .font(.headline)
                
                Text(viewModel.childName)
                    .font(.title2)
                    .bold()
            }
            
            if viewModel.isLoading {
                ProgressView()
            }
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
            
            Button("Diet") {
                handleDietNavigation()
            }
            .buttonStyle(.bordered)
            
            Button("Accidental Exposure") {
                goToAccidentalExposure = true
            }
            .buttonStyle(.bordered)
            
            Button("Medications") {
                goToMedications = true
            }
            .buttonStyle(.bordered)
            
            Button("Documents") {
                goToDocuments = true
            }
            .buttonStyle(.bordered)
            
            Button("Endoscopy") {
                goToEndoscopy = true
            }
            .buttonStyle(.bordered)
            
            Spacer()
            
            NavigationLink(destination: Diet1View(), isActive: $goToDiet1) { EmptyView() }
            NavigationLink(destination: Diet2View(), isActive: $goToDiet2) { EmptyView() }
            NavigationLink(destination: Diet4View(), isActive: $goToDiet4) { EmptyView() }
            NavigationLink(destination: Diet6View(), isActive: $goToDiet6) { EmptyView() }
            NavigationLink(destination: DietNoneView(), isActive: $goToDietNone) { EmptyView() }
            
            NavigationLink(destination: AccidentalExposureView(), isActive: $goToAccidentalExposure) { EmptyView() }
            NavigationLink(destination: MedicationsView(), isActive: $goToMedications) { EmptyView() }
            NavigationLink(destination: DocumentsView(), isActive: $goToDocuments) { EmptyView() }
            NavigationLink(destination: EndoscopyView(), isActive: $goToEndoscopy) { EmptyView() }
        }
        .padding()
        .navigationTitle("Plan")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await viewModel.loadPlanData()
        }
        .alert("No diet is selected for child", isPresented: $viewModel.showDietError) {
            Button("OK", role: .cancel) { }
        }
    }
    
    private func handleDietNavigation() {
        guard let route = viewModel.normalizedDietRoute() else {
            viewModel.showDietError = true
            return
        }
        
        switch route {
        case "diet1":
            goToDiet1 = true
        case "diet2":
            goToDiet2 = true
        case "diet4":
            goToDiet4 = true
        case "diet6":
            goToDiet6 = true
        case "dietNone":
            goToDietNone = true
        default:
            viewModel.showDietError = true
        }
    }
}
