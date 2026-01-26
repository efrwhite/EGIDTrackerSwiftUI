//
//  AddDocumentsViewController.swift
//  Testing_Ground
//
//  Created by Vivek Vangala on 1/29/24.
//

import Foundation

import UIKit
import CoreData

class AddDocumentsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var AddDocsButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var photoNames: [String] = []
    var selectedImageData: Data?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AddDocsButton.target = self
        AddDocsButton.action = #selector(plusButtonTapped)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DocumentTableViewCell.self, forCellReuseIdentifier: "DocumentTableViewCell")
        
        if let savedPhotoNames = UserDefaults.standard.stringArray(forKey: "SavedPhotoNames") {
            photoNames = savedPhotoNames
        }
    }
    
    func savePhotoNamesToUserDefaults() {
        UserDefaults.standard.set(photoNames, forKey: "SavedPhotoNames")
    }
    
    func loadImage(with photoName: String) -> UIImage? {
        if let imageData = UserDefaults.standard.data(forKey: photoName),
           let image = UIImage(data: imageData) {
            return image
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentTableViewCell", for: indexPath) as? DocumentTableViewCell else {
            return UITableViewCell()
        }
        
        let photoName = photoNames[indexPath.row]
        cell.textLabel?.text = photoName
        cell.editButtonAction = { [weak self] in
            self?.editButtonTappedForRow(at: indexPath)
        }
        
        return cell
    }
    
    func editButtonTappedForRow(at indexPath: IndexPath) {
        let photoName = photoNames[indexPath.row]
        let actionSheet = UIAlertController(title: "Select an option", message: nil, preferredStyle: .actionSheet)
        
        let editAction = UIAlertAction(title: "Edit", style: .default) { [weak self] _ in
            self?.showEditAlert(for: indexPath)
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.deletePhotoName(at: indexPath)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(editAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func showEditAlert(for indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Edit Photo Name", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.text = self.photoNames[indexPath.row]
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self, weak alertController] _ in
            guard let newName = alertController?.textFields?.first?.text, !newName.isEmpty else { return }
            self?.photoNames[indexPath.row] = newName
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            self?.savePhotoNamesToUserDefaults()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func deletePhotoName(at indexPath: IndexPath) {
        photoNames.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        savePhotoNamesToUserDefaults()
    }
    
    
    func showPhotoPopup(with image: UIImage) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        alertController.view.addSubview(imageView)
        
        imageView.centerXAnchor.constraint(equalTo: alertController.view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: alertController.view.centerYAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 200.0).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 200.0).isActive = true
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func fetchDocument(with photoName: String) -> NSManagedObject? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Documents")
        fetchRequest.predicate = NSPredicate(format: "title == %@", photoName)
        do {
            let documents = try context.fetch(fetchRequest)
            return documents.first
        } catch {
            print("Failed to fetch document: \(error.localizedDescription)")
            return nil
        }
    }
    
    @objc func plusButtonTapped() {
        print("Plus button tapped")
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default) { _ in
            self.openCamera()
        }
        
        let chooseFromLibraryAction = UIAlertAction(title: "Choose from Library", style: .default) { _ in
            self.openPhotoLibrary()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(takePhotoAction)
        actionSheet.addAction(chooseFromLibraryAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("Camera not available.")
        }
    }
    
    func openPhotoLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print("Image picked from library")
            
            selectedImageData = pickedImage.jpegData(compressionQuality: 1.0)
            
            picker.dismiss(animated: true) {
                self.showConfirmationAlert(with: pickedImage)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("Image picking cancelled")
        picker.dismiss(animated: true, completion: nil)
    }
    
    func showConfirmationAlert(with image: UIImage) {
        let alertController = UIAlertController(title: "Confirmation", message: "Are you sure you'd like to input this photo?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            print("User confirmed to input the photo")
            self.showNameInputAlert(for: image)
        }
        
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showNameInputAlert(for image: UIImage) {
        let alertController = UIAlertController(title: "Enter Photo Name", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Enter name"
            textField.delegate = self
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            if let nameTextField = alertController.textFields?.first, let photoName = nameTextField.text, !photoName.isEmpty {
                print("Entered photo name: \(photoName)")
                self?.updateTableView(with: image, name: photoName)
                self?.savePhotoToCoreData(childName: "childNameValue", date: Date(), image: "imageValue", title: photoName, userName: "userNameValue")
                self?.savePhotoNamesToUserDefaults()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func updateTableView(with image: UIImage, name: String) {
        print("Updating table view with the selected image and name: \(name), binary data: \(String(describing: selectedImageData))")
        photoNames.append(name)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func generateUniqueName() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        return "Photo_\(formatter.string(from: Date()))"
    }
    
    func savePhotoToCoreData(childName: String, date: Date, image: String, title: String, userName: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        if let newDocument = NSEntityDescription.insertNewObject(forEntityName: "Documents", into: context) as? NSManagedObject {
            newDocument.setValue(childName, forKey: "childName")
            newDocument.setValue(date, forKey: "date")
            newDocument.setValue(image, forKey: "image")
            newDocument.setValue(title, forKey: "title")
            newDocument.setValue(userName, forKey: "userName")
            
            do {
                try context.save()
                print("Saved to CoreData: ChildName - \(childName), Date - \(date), Image - \(image), Title - \(title), UserName - \(userName)")
            } catch {
                print("Failed to save to CoreData: \(error.localizedDescription)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle selection if needed
    }
}

