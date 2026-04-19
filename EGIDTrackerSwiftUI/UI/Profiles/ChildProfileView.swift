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
    @FocusState private var activeField: Int?
    init(childId: String? = nil, isFirstTimeUser: Bool = false) {
        _viewModel = StateObject(
            wrappedValue: ChildProfileViewModel(
                childId: childId,
                isFirstTimeUser: isFirstTimeUser
            )
        )
    }
    var body: some View {
        ScrollView{
            VStack(spacing: 0) {
                ZStack(alignment: .center) {
                    Image("profile_vector")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                    
                    
                    VStack(alignment: .center) {
                        Text("Child Profile")
                            .font(.title).bold()
                            .foregroundColor(.white)
                        
                        profileImageSection
                            .foregroundColor(.white)
                    }
                }
                
                VStack(alignment: .leading) {
                    
                    VStack(alignment: .leading, spacing: 20) {
                        ProfileInputField(label: "First Name", text: $viewModel.firstName)
                        ProfileInputField(label: "Last Name", text: $viewModel.lastName)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            
                            FieldTitle(title: "Birthdate")
                            
                            HStack(spacing: 16) {
                                
                                BirthDatePartField(placeholder: "MM", text: $viewModel.month, limit: 2, focusKey: 0, activeField: $activeField, nextFocusKey: 1)
                                
                                BirthDatePartField(placeholder: "DD", text: $viewModel.day, limit: 2, focusKey: 1, activeField: $activeField, nextFocusKey: 2)
                                
                                BirthDatePartField(placeholder: "YYYY", text: $viewModel.year, limit: 4, focusKey: 2, activeField: $activeField, nextFocusKey: nil, width: 80)
                            }
                        }
                        VStack(alignment: .leading, spacing: 7) {
                            FieldTitle(title: "Gender:")
                            HStack(spacing: 6) {
                                ForEach(AppConstants.genderOptions, id: \.self) { option in
                                    Button {
                                        viewModel.gender = option
                                    } label: {
                                        Text(option)
                                            .font(.subheadline)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 8)
                                            .background(viewModel.gender == option ? Color("SecondaryColor") : Color(.systemGray6))
                                            .foregroundColor(viewModel.gender == option ? .white : .primary)
                                    }
                                }
                            }
                        }
                        VStack(alignment: .leading, spacing: 7) {
                            FieldTitle(title: "Diet:")
                            HStack(spacing: 14) {
                                ForEach(AppConstants.dietOptions, id: \.self) { option in
                                    Button {
                                        viewModel.diet = option
                                    } label: {
                                        Text(option)
                                            .font(.subheadline)
                                            .frame(width: 60, height: 60)
                                            .background(viewModel.diet == option ? Color("SecondaryColor") : Color(.systemGray6))
                                            .foregroundColor(viewModel.diet == option ? .white : .primary)
                                            .clipShape(Circle())
                                        
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal,20)
                
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
                .bold()
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.top, 30)
                .padding(.bottom, 20)
                .disabled(viewModel.isLoading)
                .tint(Color("SecondaryColor"))
                
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                }
                
                NavigationLink(destination: ProfilesView(), isActive: $goToHome) {
                    EmptyView()
                }
            }
        }
        .edgesIgnoringSafeArea(.top)
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
    }
}
