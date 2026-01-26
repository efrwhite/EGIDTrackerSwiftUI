//
//import Foundation
//import UIKit
//import CoreData
//
//protocol AddAllergenDelegate: AnyObject {
//    func didSaveNewAllergen()
//}
//
//class AllergenViewController: UIViewController, UITextFieldDelegate {
//
//    @IBOutlet weak var allergyname: UITextField!
//    @IBOutlet weak var severity: UIButton!
//    @IBOutlet weak var notes: UITextView!
//    @IBOutlet weak var startdate: UIDatePicker!
//    @IBOutlet weak var enddate: UIDatePicker!
//    @IBOutlet weak var endDateLabel: UILabel!
//    @IBOutlet weak var offonswitch: UISwitch!
//    @IBOutlet weak var allergyTypeSwitch: UISegmentedControl! // IgE or Non-IgE Switch
//
//    var user = ""
//    var allergenName = ""
//    var isEditMode = false
//    var childName = ""
//
//    weak var delegate: AddAllergenDelegate?
//
//    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        view.addGestureRecognizer(tapGesture)
//
//        endDateLabel.isHidden = !offonswitch.isOn
//        enddate.isHidden = !offonswitch.isOn
//
//        notes.layer.cornerRadius = 5
//        notes.layer.borderWidth = 1
//        notes.layer.borderColor = UIColor.lightGray.cgColor
//
//        offonswitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
//
//        // Set default severity button title if not editing
//        if !isEditMode {
//            severity.setTitle("Select Severity", for: .normal)
//        }
//
//        // Setup severity menu
//        let severityOptions: [String] = ["Mild", "Moderate", "Severe"]
//        let menuItems = severityOptions.map { level in
//            UIAction(title: level) { [weak self] _ in
//                self?.severity.setTitle(level, for: .normal)
//            }
//        }
//        severity.menu = UIMenu(title: "Select Severity", options: .displayInline, children: menuItems)
//        severity.showsMenuAsPrimaryAction = true
//        severity.changesSelectionAsPrimaryAction = false
//
//        if isEditMode {
//            populateDataForEditing()
//        }
//    }
//
//    @objc func dismissKeyboard() {
//        view.endEditing(true)
//    }
//
//    @objc func switchValueChanged(_ sender: UISwitch) {
//        endDateLabel.isHidden = !sender.isOn
//        enddate.isHidden = !sender.isOn
//    }
//
//    func populateDataForEditing() {
//        let fetchRequest: NSFetchRequest<Allergies> = Allergies.fetchRequest()
//        fetchRequest.predicate = NSPredicate(
//            format: "childname == %@  AND username == %@ AND name == %@",
//            childName,
//            user,
//            allergenName
//        )
//        do {
//            let allergens = try managedObjectContext.fetch(fetchRequest)
//            if let existingAllergen = allergens.first {
//                print("Editing existing allergen: \(existingAllergen.name ?? "No name")")
//
//                allergyname.text = existingAllergen.name
//                severity.setTitle(existingAllergen.severity, for: .normal)
//                startdate.date = existingAllergen.startdate ?? Date()
//                notes.text = existingAllergen.notes
//
//                if let enddate = existingAllergen.enddate {
//                    offonswitch.isOn = true
//                    self.enddate.date = enddate
//                } else {
//                    offonswitch.isOn = false
//                }
//
//                allergyTypeSwitch.selectedSegmentIndex = existingAllergen.isIgE ? 0 : 1
//                switchValueChanged(offonswitch)
//
//                print("Allergen severity: \(existingAllergen.severity ?? "No severity")")
//                print("Allergen type: \(existingAllergen.isIgE ? "IgE" : "Non-IgE")")
//                print("Allergen start date: \(existingAllergen.startdate ?? Date())")
//            }
//        } catch {
//            print("Error fetching allergen for editing: \(error)")
//        }
//    }
//
//    @IBAction func saveButton(_ sender: Any) {
//        print("Save button tapped")
//
//        // Optional: Validate severity selection
//        guard let selectedSeverity = severity.title(for: .normal), selectedSeverity != "Select Severity" else {
//            let alert = UIAlertController(title: "Missing Severity", message: "Please select a severity level.", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default))
//            present(alert, animated: true)
//            return
//        }
//
//        if isEditMode {
//            let fetchRequest: NSFetchRequest<Allergies> = Allergies.fetchRequest()
//            fetchRequest.predicate = NSPredicate(
//                format: "childname == %@ AND username == %@ AND name == %@",
//                childName, user, allergenName
//            )
//
//            do {
//                let allergens = try managedObjectContext.fetch(fetchRequest)
//                if let existingAllergen = allergens.first {
//                    print("Updating existing allergen: \(existingAllergen.name ?? "No name")")
//                    existingAllergen.childname = childName
//                    existingAllergen.username = user
//                    existingAllergen.name = allergyname.text
//                    existingAllergen.severity = selectedSeverity
//                    existingAllergen.startdate = startdate.date
//                    existingAllergen.isIgE = allergyTypeSwitch.selectedSegmentIndex == 0
//
//                    if offonswitch.isOn {
//                        existingAllergen.enddate = enddate.date
//                    } else {
//                        existingAllergen.enddate = nil
//                    }
//
//                    print("Updated allergen name: \(existingAllergen.name ?? "No name")")
//                    print("Updated allergen severity: \(existingAllergen.severity ?? "No severity")")
//                    print("Updated allergen type: \(existingAllergen.isIgE ? "IgE" : "Non-IgE")")
//                }
//            } catch {
//                print("Error updating allergen: \(error)")
//            }
//        } else {
//            let newAllergen = Allergies(context: managedObjectContext)
//            newAllergen.username = user
//            newAllergen.childname = childName
//            newAllergen.name = allergyname.text
//            newAllergen.severity = selectedSeverity
//            newAllergen.startdate = startdate.date
//            newAllergen.isIgE = allergyTypeSwitch.selectedSegmentIndex == 0
//
//            if offonswitch.isOn {
//                newAllergen.enddate = enddate.date
//            } else {
//                newAllergen.enddate = nil
//            }
//
//            print("New allergen added:")
//            print("Name: \(newAllergen.name ?? "No name")")
//            print("Severity: \(newAllergen.severity ?? "No severity")")
//            print("Type: \(newAllergen.isIgE ? "IgE" : "Non-IgE")")
//            print("Start date: \(String(describing: newAllergen.startdate))")
//        }
//
//        do {
//            try managedObjectContext.save()
//            print("Allergen saved successfully")
//            delegate?.didSaveNewAllergen()
//            self.navigationController?.popViewController(animated: true)
//        } catch {
//            print("Error saving allergen: \(error)")
//        }
//    }
//}


import Foundation
import UIKit
import CoreData

protocol AddAllergenDelegate: AnyObject {
    func didSaveNewAllergen()
}

class AllergenViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var allergyname: UITextField!
    @IBOutlet weak var severity: UIButton!
    @IBOutlet weak var notes: UITextView!
    @IBOutlet weak var startdate: UIDatePicker!
    @IBOutlet weak var enddate: UIDatePicker!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var offonswitch: UISwitch!
    @IBOutlet weak var allergyTypeSwitch: UISegmentedControl! // IgE or Non-IgE Switch

    var user = ""
    var allergenName = ""
    var isEditMode = false
    var childName = ""

    weak var delegate: AddAllergenDelegate?

    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // MARK: - Theme (match your purple UI)
    private let appPurple = UIColor(red: 138/255, green: 96/255, blue: 176/255, alpha: 1.0) // #8A60B0-ish
    private let pageBackground = UIColor(red: 0.97, green: 0.96, blue: 0.95, alpha: 1.0)     // warm off-white

    override func viewDidLoad() {
        super.viewDidLoad()

        // Background (no overlays)
        view.backgroundColor = pageBackground

        // Tap to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)

        // Toggle end date visibility
        endDateLabel.isHidden = !offonswitch.isOn
        enddate.isHidden = !offonswitch.isOn
        offonswitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)

        // Default severity title (if not editing)
        if !isEditMode {
            severity.setTitle("Select Severity", for: .normal)
        }

        // Setup severity menu
        setupSeverityMenu()

        // Apply styling
        applyStyling()

        // Populate edit mode data
        if isEditMode {
            populateDataForEditing()
        }
    }

    // MARK: - Styling
    private func applyStyling() {
        // Navigation title tint (safe)
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: appPurple
        ]
        navigationController?.navigationBar.tintColor = appPurple

        // Allergen text field (WHITE, rounded)
        styleTextField(allergyname, placeholder: "Allergen Name")

        // Severity button (gray pill)
        stylePillButton(severity)

        // Date pickers
        styleDatePicker(startdate)
        styleDatePicker(enddate)

        // Switch tint
        offonswitch.onTintColor = appPurple

        // Notes (white card)
        notes.backgroundColor = .white
        notes.layer.cornerRadius = 12
        notes.layer.borderWidth = 1
        notes.layer.borderColor = UIColor.systemGray4.cgColor
        notes.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

        // Segmented control (soft gray background + purple selected)
        allergyTypeSwitch.backgroundColor = UIColor.systemGray5
        allergyTypeSwitch.selectedSegmentTintColor = appPurple

        allergyTypeSwitch.setTitleTextAttributes([.foregroundColor: UIColor.label], for: .normal)
        allergyTypeSwitch.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
    }

    private func styleTextField(_ tf: UITextField, placeholder: String? = nil) {
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 12
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.systemGray4.cgColor
        tf.clipsToBounds = true
        tf.textColor = .label
        tf.tintColor = appPurple

        // left padding
        let pad = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 1))
        tf.leftView = pad
        tf.leftViewMode = .always

        // placeholder styling
        if let placeholder = placeholder {
            tf.attributedPlaceholder = NSAttributedString(
                string: placeholder,
                attributes: [.foregroundColor: UIColor.systemGray3]
            )
        }

        // keyboard return behavior
        tf.delegate = self
        tf.returnKeyType = .done
    }

    private func stylePillButton(_ button: UIButton) {
        button.backgroundColor = UIColor.systemGray5
        button.layer.cornerRadius = 18
        button.clipsToBounds = true
        button.tintColor = appPurple
        button.setTitleColor(.label, for: .normal)

        // Better spacing inside the pill (doesn't affect constraints)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 14, bottom: 10, right: 14)

        // Make the menu chevron feel like your UI
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
    }

    private func styleDatePicker(_ picker: UIDatePicker) {
        picker.tintColor = appPurple

        // Keep your layout stable: don't force inline if it breaks spacing
        // Compact looks like the "pill" style you already have elsewhere.
        if #available(iOS 14.0, *) {
            picker.preferredDatePickerStyle = .compact
        }
    }

    private func setupSeverityMenu() {
        let severityOptions: [String] = ["Mild", "Moderate", "Severe"]
        let menuItems = severityOptions.map { level in
            UIAction(title: level) { [weak self] _ in
                self?.severity.setTitle(level, for: .normal)
            }
        }
        severity.menu = UIMenu(title: "Select Severity", options: .displayInline, children: menuItems)
        severity.showsMenuAsPrimaryAction = true
        severity.changesSelectionAsPrimaryAction = false
    }

    // MARK: - Keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // MARK: - End Date Toggle
    @objc func switchValueChanged(_ sender: UISwitch) {
        endDateLabel.isHidden = !sender.isOn
        enddate.isHidden = !sender.isOn
    }

    // MARK: - Populate Edit Data
    func populateDataForEditing() {
        let fetchRequest: NSFetchRequest<Allergies> = Allergies.fetchRequest()
        fetchRequest.predicate = NSPredicate(
            format: "childname == %@  AND username == %@ AND name == %@",
            childName,
            user,
            allergenName
        )
        do {
            let allergens = try managedObjectContext.fetch(fetchRequest)
            if let existingAllergen = allergens.first {
                print("Editing existing allergen: \(existingAllergen.name ?? "No name")")

                allergyname.text = existingAllergen.name
                severity.setTitle(existingAllergen.severity, for: .normal)
                startdate.date = existingAllergen.startdate ?? Date()
                notes.text = existingAllergen.notes

                if let enddate = existingAllergen.enddate {
                    offonswitch.isOn = true
                    self.enddate.date = enddate
                } else {
                    offonswitch.isOn = false
                }

                allergyTypeSwitch.selectedSegmentIndex = existingAllergen.isIgE ? 0 : 1
                switchValueChanged(offonswitch)

                print("Allergen severity: \(existingAllergen.severity ?? "No severity")")
                print("Allergen type: \(existingAllergen.isIgE ? "IgE" : "Non-IgE")")
                print("Allergen start date: \(existingAllergen.startdate ?? Date())")
            }
        } catch {
            print("Error fetching allergen for editing: \(error)")
        }
    }

    // MARK: - Save
    @IBAction func saveButton(_ sender: Any) {
        print("Save button tapped")

        // Validate severity selection
        guard let selectedSeverity = severity.title(for: .normal),
              selectedSeverity != "Select Severity" else {
            let alert = UIAlertController(
                title: "Missing Severity",
                message: "Please select a severity level.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }

        if isEditMode {
            let fetchRequest: NSFetchRequest<Allergies> = Allergies.fetchRequest()
            fetchRequest.predicate = NSPredicate(
                format: "childname == %@ AND username == %@ AND name == %@",
                childName, user, allergenName
            )

            do {
                let allergens = try managedObjectContext.fetch(fetchRequest)
                if let existingAllergen = allergens.first {
                    print("Updating existing allergen: \(existingAllergen.name ?? "No name")")
                    existingAllergen.childname = childName
                    existingAllergen.username = user
                    existingAllergen.name = allergyname.text
                    existingAllergen.severity = selectedSeverity
                    existingAllergen.startdate = startdate.date
                    existingAllergen.isIgE = allergyTypeSwitch.selectedSegmentIndex == 0
                    existingAllergen.notes = notes.text

                    if offonswitch.isOn {
                        existingAllergen.enddate = enddate.date
                    } else {
                        existingAllergen.enddate = nil
                    }
                }
            } catch {
                print("Error updating allergen: \(error)")
            }
        } else {
            let newAllergen = Allergies(context: managedObjectContext)
            newAllergen.username = user
            newAllergen.childname = childName
            newAllergen.name = allergyname.text
            newAllergen.severity = selectedSeverity
            newAllergen.startdate = startdate.date
            newAllergen.isIgE = allergyTypeSwitch.selectedSegmentIndex == 0
            newAllergen.notes = notes.text

            if offonswitch.isOn {
                newAllergen.enddate = enddate.date
            } else {
                newAllergen.enddate = nil
            }
        }

        do {
            try managedObjectContext.save()
            print("Allergen saved successfully")
            delegate?.didSaveNewAllergen()
            self.navigationController?.popViewController(animated: true)
        } catch {
            print("Error saving allergen: \(error)")
        }
    }
}
