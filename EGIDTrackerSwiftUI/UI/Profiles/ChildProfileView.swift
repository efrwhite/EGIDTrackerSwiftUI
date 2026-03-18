//
//  ChildProfileView.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/18/26.
//

import SwiftUI

struct ChildProfileView: View {
    
    @StateObject private var viewModel: ChildProfileViewModel
    @State private var showImageOptions = false
    @State private var showCamera = false
    @State private var showPhotoLibrary = false
    @State private var goToHome = false
    
    init(childId: String? = nil, isFirstTimeUser: Bool = false) {
        _viewModel = StateObject(
            wrappedValue: ChildProfileViewModel(
                childId: childId,
                isFirstTimeUser: isFirstTimeUser
            )
        )
    }
    
    var body: some View {
        VStack(spacing: 16) {
            
            Text("Child Profile")
                .font(.title)
                .bold()
            
            profileImageSection
            
            TextField("First Name", text: $viewModel.firstName)
                .textFieldStyle(.roundedBorder)
            
            TextField("Last Name", text: $viewModel.lastName)
                .textFieldStyle(.roundedBorder)
            
            DatePicker("Birthdate", selection: $viewModel.birthDate, in: ...Date(), displayedComponents: .date)
                .datePickerStyle(.compact)
            
            Picker("Gender", selection: $viewModel.gender) {
                ForEach(AppConstants.genderOptions, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(.menu)
            
            Picker("Diet", selection: $viewModel.diet) {
                ForEach(AppConstants.dietOptions, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(.menu)
            
            Button {
                viewModel.saveChild()
            } label: {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Text(viewModel.isEditMode ? "Save" : "Save and Continue")
                        .bold()
                }
            }
            .buttonStyle(.borderedProminent)
            
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }
            
            NavigationLink(destination: HomeView(), isActive: $goToHome) {
                EmptyView()
            }
            
            Spacer()
        }
        .padding()
        .task {
            await viewModel.loadInitialData()
        }
        .confirmationDialog("Select Image", isPresented: $showImageOptions, titleVisibility: .visible) {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                Button("Take Photo") { showCamera = true }
            }
            Button("Choose from Gallery") { showPhotoLibrary = true }
            Button("Delete Picture", role: .destructive) { viewModel.deleteProfilePicture() }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $showCamera) {
            ImagePicker(sourceType: .camera) { image, path in
                viewModel.setPickedImage(image, imagePath: path)
            }
        }
        .sheet(isPresented: $showPhotoLibrary) {
            ImagePicker(sourceType: .photoLibrary) { image, path in
                viewModel.setPickedImage(image, imagePath: path)
            }
        }
        .onAppear {
            if viewModel.diet.isEmpty {
                viewModel.diet = AppConstants.defaultDiet
            }
        }
        .onChange(of: viewModel.saveSucceeded) { succeeded in
            if succeeded {
                goToHome = true
            }
        }
    }
    
    private var profileImageSection: some View {
        VStack {
            Group {
                if let image = viewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .foregroundStyle(.gray)
                }
            }
            .scaledToFill()
            .frame(width: 120, height: 120)
            .clipShape(Circle())
            
            Button("Select Image") {
                showImageOptions = true
            }
        }
    }
}
