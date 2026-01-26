//import UIKit
//import CoreData
//
//class AccidentalExposureViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//   
//    // CoreData context
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    var user = "" // User variable
//    var childName = "" // Child variable
//    
//    // Assuming a child object is passed to this view controller
//    var child: NSManagedObject?
//    
//    // Form UI elements
//    let titleLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Accidental Exposure"
//        label.font = UIFont.boldSystemFont(ofSize: 20)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    let dateLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Date:"
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    let datePicker: UIDatePicker = {
//        let datePicker = UIDatePicker()
//        datePicker.datePickerMode = .date
//        datePicker.translatesAutoresizingMaskIntoConstraints = false
//        return datePicker
//    }()
//    
//    let itemExposedLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Item Exposed To:"
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    let itemExposedTextField: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "Enter Item"
//        textField.borderStyle = .roundedRect
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        return textField
//    }()
//    
//    let descriptionLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Description:"
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    let descriptionTextField: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "Enter Description"
//        textField.borderStyle = .roundedRect
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        return textField
//    }()
//    
//    let addButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Add Exposure", for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.backgroundColor = UIColor(red: 0x39/255, green: 0x43/255, blue: 0x90/255, alpha: 1.0) // #394390
//        button.setTitleColor(.white, for: .normal)
//        button.layer.cornerRadius = 8 // Optional for rounded corners
//        button.addTarget(self, action: #selector(addExposure), for: .touchUpInside)
//        return button
//    }()
//
//
//    // History UI elements
//    let historyLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Accidental Exposure History"
//        label.font = UIFont.boldSystemFont(ofSize: 20)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    let historyTableView: UITableView = {
//        let tableView = UITableView()
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        //notes layer
//        tableView.layer.cornerRadius = 5
//        tableView.layer.borderWidth = 1
//        tableView.layer.borderColor = UIColor.lightGray.cgColor
//        return tableView
//    }()
//    
//    var exposureHistory: [NSManagedObject] = []
//    var expandedIndexSet = Set<IndexPath>()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        print("Accidental Exposure User: ", user)
//        print("Accidental Exposure Child: ", childName)
//
//        view.backgroundColor = .white
//        
//        // Add subviews
//        setupSubviews()
//
//        // Additional setup for the table view
//        historyTableView.delegate = self
//        historyTableView.dataSource = self
//        historyTableView.register(ExposureTableViewCell.self, forCellReuseIdentifier: "ExposureTableViewCell")
//        
//        // Load exposure history from CoreData
//        loadExposureHistory()
//        
//        // Dismiss keyboard on tap outside
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        view.addGestureRecognizer(tapGesture)
//        NSLayoutConstraint.activate([
//            addButton.widthAnchor.constraint(equalToConstant: 350),
//            // Add other constraints like top, leading, etc.
//        ])
//
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        // Load data and reload the tableView when view reappears
//        loadExposureHistory()
//        historyTableView.reloadData()
//    }
//    
//    // Setup all the subviews and their constraints
//    func setupSubviews() {
//        view.addSubview(titleLabel)
//        view.addSubview(dateLabel)
//        view.addSubview(datePicker)
//        view.addSubview(itemExposedLabel)
//        view.addSubview(itemExposedTextField)
//        view.addSubview(descriptionLabel)
//        view.addSubview(descriptionTextField)
//        view.addSubview(addButton)
//        view.addSubview(historyLabel)
//        view.addSubview(historyTableView)
//        
//        NSLayoutConstraint.activate([
//            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
//            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            
//            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
//            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            
//            datePicker.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
//            datePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            
//            itemExposedLabel.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
//            itemExposedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            
//            itemExposedTextField.topAnchor.constraint(equalTo: itemExposedLabel.bottomAnchor, constant: 8),
//            itemExposedTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            itemExposedTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            
//            descriptionLabel.topAnchor.constraint(equalTo: itemExposedTextField.bottomAnchor, constant: 20),
//            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            
//            descriptionTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
//            descriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            descriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            
//            addButton.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 20),
//            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            
//            historyLabel.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 20),
//            historyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            
//            historyTableView.topAnchor.constraint(equalTo: historyLabel.bottomAnchor, constant: 8),
//            historyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            historyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            historyTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
//        ])
//    }
//    
//    @objc func addExposure() {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .medium
//        dateFormatter.timeStyle = .none
//        let date = dateFormatter.string(from: datePicker.date)
//        
//        guard let item = itemExposedTextField.text, !item.isEmpty,
//              let description = descriptionTextField.text, !description.isEmpty else {
//            // Show alert for missing fields
//            let alert = UIAlertController(title: "Missing Information", message: "Please fill out all fields.", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default))
//            present(alert, animated: true)
//            return
//        }
//        
//        // Create a new AccidentalExposure entity
//        let entity = NSEntityDescription.entity(forEntityName: "AccidentalExposure", in: context)!
//        let newExposure = NSManagedObject(entity: entity, insertInto: context)
//        newExposure.setValue(datePicker.date, forKey: "date")
//        newExposure.setValue(item, forKey: "item")
//        newExposure.setValue(description, forKey: "desc")
//        newExposure.setValue(childName, forKey: "childname")
//        newExposure.setValue(user, forKey: "username")
//        
//        // Save to CoreData
//        do {
//            try context.save()
//            exposureHistory.append(newExposure)
//            loadExposureHistory()
//            historyTableView.reloadData()
//            print("Exposure saved: \(date) - \(item) - \(description)")
//        } catch {
//            print("Failed to save exposure: \(error)")
//        }
//        
//        // Clear text fields
//        itemExposedTextField.text = ""
//        descriptionTextField.text = ""
//    }
//    
//    // Load exposure history from CoreData
//    func loadExposureHistory() {
//        let request = NSFetchRequest<NSManagedObject>(entityName: "AccidentalExposure")
//        request.predicate = NSPredicate(format: "username == %@ && childname == %@", user, childName)
//        
//        do {
//            exposureHistory = try context.fetch(request)
//            print("Loaded \(exposureHistory.count) exposures")
//            historyTableView.reloadData()
//        } catch {
//            print("Failed to load exposures: \(error)")
//        }
//    }
//    
//    // Dismiss keyboard on tap outside
//    @objc func dismissKeyboard() {
//        view.endEditing(true)
//    }
//    
//    // MARK: - UITableViewDataSource
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return exposureHistory.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ExposureTableViewCell", for: indexPath) as! ExposureTableViewCell
//        let exposure = exposureHistory[indexPath.row]
//        
//        // Configure the cell
//        let date = exposure.value(forKey: "date") as? Date ?? Date()
//        let item = exposure.value(forKey: "item") as? String ?? ""
//        let desc = exposure.value(forKey: "desc") as? String ?? ""
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .medium
//        dateFormatter.timeStyle = .none
//        
//        cell.dateLabel.text = dateFormatter.string(from: date)
//        cell.itemLabel.text = item
//        cell.descriptionLabel.text = desc
//        cell.descriptionLabel.numberOfLines = expandedIndexSet.contains(indexPath) ? 0 : 1
//        
//        return cell
//    }
//    
//    // Expand/collapse cell description on tap
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if expandedIndexSet.contains(indexPath) {
//            expandedIndexSet.remove(indexPath)
//        } else {
//            expandedIndexSet.insert(indexPath)
//        }
//        tableView.reloadRows(at: [indexPath], with: .automatic)
//    }
//}
//
//
//

import UIKit
import CoreData

class AccidentalExposureViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // CoreData context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var user = "" // User variable
    var childName = "" // Child variable

    // Assuming a child object is passed to this view controller
    var child: NSManagedObject?

    // MARK: - Theme
    private let appPurple = UIColor(red: 138.0/255.0, green: 96.0/255.0, blue: 176.0/255.0, alpha: 1.0) // #8A60B0
    private let pageBG = UIColor(red: 0.965, green: 0.953, blue: 0.945, alpha: 1) // warm off-white (matches your app vibe)
    private let fieldBorder = UIColor.black.withAlphaComponent(0.06)

    // MARK: - UI

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Accidental Exposure"
        label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Date"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()

    let itemExposedLabel: UILabel = {
        let label = UILabel()
        label.text = "Item Exposed To"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let itemExposedTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter item"
        textField.borderStyle = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Description"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter description"
        textField.borderStyle = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Exposure", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 18
        button.addTarget(self, action: #selector(addExposure), for: .touchUpInside)
        return button
    }()

    let historyLabel: UILabel = {
        let label = UILabel()
        label.text = "Accidental Exposure History"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let historyTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 10
        tableView.layer.borderWidth = 1
        tableView.layer.borderColor = UIColor.black.withAlphaComponent(0.06).cgColor
        tableView.clipsToBounds = true
        return tableView
    }()

    var exposureHistory: [NSManagedObject] = []
    var expandedIndexSet = Set<IndexPath>()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Accidental Exposure User: ", user)
        print("Accidental Exposure Child: ", childName)

        view.backgroundColor = pageBG

        setupSubviews()
        applyStyling()

        // Table setup
        historyTableView.delegate = self
        historyTableView.dataSource = self
        historyTableView.register(ExposureTableViewCell.self, forCellReuseIdentifier: "ExposureTableViewCell")

        loadExposureHistory()

        // Dismiss keyboard on tap outside
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadExposureHistory()
        historyTableView.reloadData()
    }

    // MARK: - Styling

    private func applyStyling() {
        // Title
        titleLabel.textColor = .black

        // Labels
        dateLabel.textColor = .black
        itemExposedLabel.textColor = .black
        descriptionLabel.textColor = .black
        historyLabel.textColor = .black

        // Date picker style
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .compact
        }

        // Button (your purple)
        addButton.backgroundColor = appPurple
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowOpacity = 0.12
        addButton.layer.shadowRadius = 10
        addButton.layer.shadowOffset = CGSize(width: 0, height: 6)

        // Fields: WHITE (your requested change)
        styleField(itemExposedTextField)
        styleField(descriptionTextField)
    }

    private func styleField(_ field: UITextField) {
        field.backgroundColor = .white  // ✅ changed to white
        field.layer.cornerRadius = 14
        field.layer.borderWidth = 1
        field.layer.borderColor = fieldBorder.cgColor
        field.clipsToBounds = true

        field.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        field.textColor = .black
        field.autocorrectionType = .no
        field.autocapitalizationType = .none

        // Left padding
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 14, height: 44))
        field.leftView = padding
        field.leftViewMode = .always

        // Placeholder softer
        if let ph = field.placeholder {
            field.attributedPlaceholder = NSAttributedString(
                string: ph,
                attributes: [.foregroundColor: UIColor.black.withAlphaComponent(0.25)]
            )
        }
    }

    // MARK: - Layout

    func setupSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(dateLabel)
        view.addSubview(datePicker)
        view.addSubview(itemExposedLabel)
        view.addSubview(itemExposedTextField)
        view.addSubview(descriptionLabel)
        view.addSubview(descriptionTextField)
        view.addSubview(addButton)
        view.addSubview(historyLabel)
        view.addSubview(historyTableView)

        NSLayoutConstraint.activate([
            // Title
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 18),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            // Date label
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 18),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            // Date picker
            datePicker.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            // Item label
            itemExposedLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 22),
            itemExposedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            // Item field
            itemExposedTextField.topAnchor.constraint(equalTo: itemExposedLabel.bottomAnchor, constant: 10),
            itemExposedTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            itemExposedTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            itemExposedTextField.heightAnchor.constraint(equalToConstant: 44),

            // Description label
            descriptionLabel.topAnchor.constraint(equalTo: itemExposedTextField.bottomAnchor, constant: 18),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            // Description field
            descriptionTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            descriptionTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 44),

            // Add button
            addButton.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 18),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.heightAnchor.constraint(equalToConstant: 48),

            // History label
            historyLabel.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 22),
            historyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            // History table
            historyTableView.topAnchor.constraint(equalTo: historyLabel.bottomAnchor, constant: 10),
            historyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            historyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            historyTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -18)
        ])
    }

    // MARK: - Actions

    @objc func addExposure() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let date = dateFormatter.string(from: datePicker.date)

        guard let item = itemExposedTextField.text, !item.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              let description = descriptionTextField.text, !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {

            let alert = UIAlertController(title: "Missing Information",
                                          message: "Please fill out all fields.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        // Create a new AccidentalExposure entity
        let entity = NSEntityDescription.entity(forEntityName: "AccidentalExposure", in: context)!
        let newExposure = NSManagedObject(entity: entity, insertInto: context)
        newExposure.setValue(datePicker.date, forKey: "date")
        newExposure.setValue(item, forKey: "item")
        newExposure.setValue(description, forKey: "desc")
        newExposure.setValue(childName, forKey: "childname")
        newExposure.setValue(user, forKey: "username")

        do {
            try context.save()
            exposureHistory.append(newExposure)
            loadExposureHistory()
            historyTableView.reloadData()
            print("Exposure saved: \(date) - \(item) - \(description)")
        } catch {
            print("Failed to save exposure: \(error)")
        }

        itemExposedTextField.text = ""
        descriptionTextField.text = ""
        dismissKeyboard()
    }

    func loadExposureHistory() {
        let request = NSFetchRequest<NSManagedObject>(entityName: "AccidentalExposure")
        request.predicate = NSPredicate(format: "username == %@ && childname == %@", user, childName)

        do {
            exposureHistory = try context.fetch(request)
            print("Loaded \(exposureHistory.count) exposures")
            historyTableView.reloadData()
        } catch {
            print("Failed to load exposures: \(error)")
        }
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exposureHistory.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExposureTableViewCell", for: indexPath) as! ExposureTableViewCell
        let exposure = exposureHistory[indexPath.row]

        let date = exposure.value(forKey: "date") as? Date ?? Date()
        let item = exposure.value(forKey: "item") as? String ?? ""
        let desc = exposure.value(forKey: "desc") as? String ?? ""

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none

        cell.dateLabel.text = dateFormatter.string(from: date)
        cell.itemLabel.text = item
        cell.descriptionLabel.text = desc
        cell.descriptionLabel.numberOfLines = expandedIndexSet.contains(indexPath) ? 0 : 1

        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if expandedIndexSet.contains(indexPath) {
            expandedIndexSet.remove(indexPath)
        } else {
            expandedIndexSet.insert(indexPath)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

