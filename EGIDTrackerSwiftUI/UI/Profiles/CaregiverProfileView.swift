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
        VStack(spacing: 0) {
            ZStack(alignment: .center) {
                Image("profile_vector")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                
                VStack(alignment: .center) {
                    Text("Caregiver Profile")
                        .font(.title).bold()
                        .foregroundColor(.white)
                    
                    profileImageSection
                        .foregroundColor(.white)
                }
            }
            
            VStack(alignment: .leading) {
                
                VStack(alignment: .leading, spacing: 20) {
                    ProfileInputField(label: "Username", text: $viewModel.username)
                    ProfileInputField(label: "First Name", text: $viewModel.firstName)
                    ProfileInputField(label: "Last Name", text: $viewModel.lastName)
                }
            }
            .padding(.horizontal,20)
            
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
            .bold()
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.top, 35)
            .padding(.bottom, 10)
            .tint(Color("SecondaryColor"))
            
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
        .edgesIgnoringSafeArea(.top)
        .task {
            await viewModel.loadInitialData()
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
                        .foregroundStyle(.white,.gray)
                }
            }
            .scaledToFill()
            .frame(width: 100, height: 100)
            .clipShape(Circle())
            
            Button("Select Image") {
                showImageOptions = true
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
        }
    }
}
#Preview {
    CaregiverProfileView()
}
