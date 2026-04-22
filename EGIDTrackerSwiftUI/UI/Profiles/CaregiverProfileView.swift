//
//  CaregiverProfile.swift
//  EGID Tracker
//
//  Created by lauren viado on 3/18/26.
//

import SwiftUI

struct CaregiverProfileView: View {
    
    @StateObject private var viewModel: CaregiverProfileViewModel
    @State private var showImageOptions = false
    @State private var showCamera = false
    @State private var showPhotoLibrary = false
    @State private var goToChildProfile = false
    
    init(caregiverId: String? = nil, isFirstTimeUser: Bool = false) {
        _viewModel = StateObject(
            wrappedValue: CaregiverProfileViewModel(
                caregiverId: caregiverId,
                isFirstTimeUser: isFirstTimeUser
            )
        )
    }
    
    var body: some View {
        VStack(spacing: 16) {
            
            Text("Caregiver Profile")
                .font(.title)
                .bold()
            
            profileImageSection
            
            TextField("Username", text: $viewModel.username)
                .textFieldStyle(.roundedBorder)
                .disabled(true)
            
            TextField("First Name", text: $viewModel.firstName)
                .textFieldStyle(.roundedBorder)
            
            TextField("Last Name", text: $viewModel.lastName)
                .textFieldStyle(.roundedBorder)
            
            Button {
                viewModel.saveCaregiver()
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
            
            NavigationLink(
                destination: ChildProfileView(isFirstTimeUser: true),
                isActive: $goToChildProfile
            ) {
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
        .onChange(of: viewModel.saveSucceeded) { succeeded in
            if succeeded && viewModel.isFirstTimeUser && !viewModel.isEditMode {
                goToChildProfile = true
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
