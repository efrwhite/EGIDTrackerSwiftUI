import UIKit
import CoreData

class AddDocumentsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var AddDocsButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var user: String = "" // Current user
    var childName: String = "" // Child's name
    var photoNames: [String] = []
    var selectedImageData: Data?
    var selectedIndexPath: IndexPath? // Index of the document being edited
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("User: \(user), Child: \(childName)")
        
        AddDocsButton.target = self
        AddDocsButton.action = #selector(plusButtonTapped)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(DocumentTableViewCell.self, forCellReuseIdentifier: "DocumentTableViewCell")
        
        loadDocumentsFromCoreData()
    }
    
    // MARK: - Core Data Fetch
    
    func loadDocumentsFromCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Documents")
        fetchRequest.predicate = NSPredicate(format: "userName == %@ AND childName == %@", user, childName)
        
        do {
            let fetchedDocuments = try context.fetch(fetchRequest)
            photoNames = fetchedDocuments.map { $0.value(forKey: "title") as! String }
            tableView.reloadData()
        } catch {
            print("Failed to fetch documents: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Save to Core Data
    
    func savePhotoToCoreData(childName: String, date: Date, image: UIImage, title: String, userName: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        // Save image as binary data
        let imageData = image.jpegData(compressionQuality: 1.0)
        
        let document = NSEntityDescription.insertNewObject(forEntityName: "Documents", into: context)
        document.setValue(userName, forKey: "userName")
        document.setValue(childName, forKey: "childName")
        document.setValue(title, forKey: "title")
        document.setValue(imageData, forKey: "storedImage") // Store the image binary data
        document.setValue(date, forKey: "date")
        
        do {
            try context.save()
            print("Document saved: \(title)")
            photoNames.append(title)
            savePhotoNamesToUserDefaults()
            tableView.reloadData()
        } catch {
            print("Failed to save document: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Update Document (Edit Name)
    
    func updateDocument(at indexPath: IndexPath, newTitle: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Documents")
        fetchRequest.predicate = NSPredicate(format: "userName == %@ AND childName == %@ AND title == %@", user, childName, photoNames[indexPath.row])
        
        do {
            let documents = try context.fetch(fetchRequest)
            if let document = documents.first {
                document.setValue(newTitle, forKey: "title")
                try context.save()
                
                photoNames[indexPath.row] = newTitle
                savePhotoNamesToUserDefaults()
                tableView.reloadData()
                print("Document updated to: \(newTitle)")
            }
        } catch {
            print("Failed to update document: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Image Picker
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: {
                print("Camera opened.")
            })
        } else {
            print("Camera not available.")
        }
    }
    
    func openPhotoLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: {
            print("Photo library opened.")
        })
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let pickedImage = info[.originalImage] as? UIImage {
            picker.dismiss(animated: true) {
                if let indexPath = self.selectedIndexPath { // If editing, update the document
                    self.updateDocumentImage(at: indexPath, newImage: pickedImage)
                    self.updateDocument(at: indexPath, newTitle: "New image file updated")
                    print("File replaced.")
                } else {
                    self.showNameInputAlert(for: pickedImage)
                }
                print("Photo taken.")
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Confirm and Save
    
    func showNameInputAlert(for image: UIImage) {
        let alertController = UIAlertController(title: "Enter Photo Name", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Photo Name"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self, weak alertController] _ in
            guard let photoName = alertController?.textFields?.first?.text, !photoName.isEmpty else { return }
            self?.savePhotoToCoreData(childName: self?.childName ?? "", date: Date(), image: image, title: photoName, userName: self?.user ?? "")
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Edit Document Menu
    
    func editButtonTappedForRow(at indexPath: IndexPath) {
        let editMenu = UIAlertController(title: "Edit Document", message: nil, preferredStyle: .actionSheet)
        
        let editNameAction = UIAlertAction(title: "Edit Name", style: .default) { [weak self] _ in
            self?.promptForEditName(at: indexPath)
        }
        
        let editFileAction = UIAlertAction(title: "Change File", style: .default) { [weak self] _ in
            self?.selectedIndexPath = indexPath
            self?.openPhotoLibrary()
        }
        
        let viewImageAction = UIAlertAction(title: "View Image", style: .default) { [weak self] _ in
            self?.viewImage(at: indexPath)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        editMenu.addAction(editNameAction)
        editMenu.addAction(editFileAction)
        editMenu.addAction(viewImageAction)
        editMenu.addAction(cancelAction)
        
        present(editMenu, animated: true, completion: nil)
    }

    func viewImage(at indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Documents")
        fetchRequest.predicate = NSPredicate(format: "userName == %@ AND childName == %@ AND title == %@", user, childName, photoNames[indexPath.row])
        
        do {
            let documents = try context.fetch(fetchRequest)
            if let document = documents.first, let imageData = document.value(forKey: "storedImage") as? Data, let image = UIImage(data: imageData) {
                
                // Push to a new view controller with the image
                let imageViewController = UIViewController()
                let imageView = UIImageView(image: image)
                imageView.frame = imageViewController.view.bounds
                imageView.contentMode = .scaleAspectFit
                imageViewController.view.addSubview(imageView)
                self.navigationController?.pushViewController(imageViewController, animated: true)
            }
        } catch {
            print("Failed to fetch and display image: \(error.localizedDescription)")
        }
    }

    // MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentTableViewCell", for: indexPath) as? DocumentTableViewCell else {
            return UITableViewCell()
        }
        
        let photoName = photoNames[indexPath.row]
        cell.textLabel?.text = photoName
        cell.editButtonTapped = { [weak self] in
            self?.editButtonTappedForRow(at: indexPath)
        }
        
        return cell
    }
    
    // MARK: - UserDefaults
    
    func savePhotoNamesToUserDefaults() {
        UserDefaults.standard.set(photoNames, forKey: "document_titles_\(user)_\(childName)")
    }
    
    @objc func plusButtonTapped() {
        print("Add document button tapped.")
        
        // Create an action sheet to give the user options to either open the camera or photo library
        let actionSheet = UIAlertController(title: "Add Document", message: "Take a photo or import one", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { [weak self] _ in
            self?.openCamera()
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { [weak self] _ in
            self?.openPhotoLibrary()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(photoLibraryAction)
        actionSheet.addAction(cancelAction)
        
        
        present(actionSheet, animated: true, completion: nil)
    }

    
    func promptForEditName(at indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Edit Photo Name", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.text = self.photoNames[indexPath.row]
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self, weak alertController] _ in
            guard let newTitle = alertController?.textFields?.first?.text, !newTitle.isEmpty else { return }
            self?.updateDocument(at: indexPath, newTitle: newTitle)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func updateDocumentImage(at indexPath: IndexPath, newImage: UIImage) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Documents")
        fetchRequest.predicate = NSPredicate(format: "userName == %@ AND childName == %@ AND title == %@", user, childName, photoNames[indexPath.row])
        
        do {
            let documents = try context.fetch(fetchRequest)
            if let document = documents.first {
                let imageData = newImage.jpegData(compressionQuality: 1.0)
                document.setValue(imageData, forKey: "storedImage")
                try context.save()
                print("Document image updated.")
            }
        } catch {
            print("Failed to update document image: \(error.localizedDescription)")
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Deletion from Core Data and update the table view
            deleteDocument(at: indexPath)
        }
    }

    func deleteDocument(at indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Documents")
        fetchRequest.predicate = NSPredicate(format: "userName == %@ AND childName == %@ AND title == %@", user, childName, photoNames[indexPath.row])
        
        do {
            let documents = try context.fetch(fetchRequest)
            if let document = documents.first {
                context.delete(document)
                try context.save()
                photoNames.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                print("Document deleted.")
            }
        } catch {
            print("Failed to delete document: \(error.localizedDescription)")
        }
    }


}

    
