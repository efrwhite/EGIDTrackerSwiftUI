//
//
//import Foundation
//import UIKit
//import CoreData
//
//class AddMedicationViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
//
//    
//    var isEditMode = false
//    var user = ""
//    var childName = ""
//    var medicationName = ""
//
//    @IBOutlet weak var medicationname: UITextField!
//    @IBOutlet weak var enddatelabel: UILabel!
//    @IBOutlet weak var enddate: UIDatePicker!
//    @IBOutlet weak var discontinuedswitch: UISwitch!
//    @IBOutlet weak var notes: UITextView!
//    @IBOutlet weak var frequency: UITextField!
//    @IBOutlet weak var startdate: UIDatePicker!
//    @IBOutlet weak var dosagetype: UIPickerView!
//    @IBOutlet weak var dosageAmount: UITextField!
//
//    let dosageUnits = ["mg", "ml", "tablet", "capsule"] // PickerView options
//    var selectedDosageUnit: String? // Stores selected unit
//
//    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        print(
//            "On add medication page: ",
//            "User: ",
//            user,
//            "Child Name: ",
//            childName
//            , "MedName: ", medicationName )
//        
//        // Set PickerView delegates
//        dosagetype.delegate = self
//        dosagetype.dataSource = self
//        
//        // Set switch to off by default
//        discontinuedswitch.isOn = false
//        
//        // Initially hide end date and label
//        toggleEndDateVisibility(isVisible: false)
//        
//        // Add target to switch for value change
//        discontinuedswitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
//        
//        //notes layer
//        notes.layer.cornerRadius = 5
//        notes.layer.borderWidth = 1
//        notes.layer.borderColor = UIColor.lightGray.cgColor
//        // Populate fields if edit mode is active
//        populatedataifeditison()
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//           tapGesture.cancelsTouchesInView = false
//           view.addGestureRecognizer(tapGesture)
//        // Set delegates to handle return key dismiss
//            medicationname.delegate = self
//            frequency.delegate = self
//            dosageAmount.delegate = self
//    }
//    @objc func dismissKeyboard() {
//        view.endEditing(true) // ✅ Hides the keyboard
//    }
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder() // ✅ Closes keyboard
//        return true
//    }
//
//
//    // Function to toggle visibility of end date and label
//    func toggleEndDateVisibility(isVisible: Bool) {
//        enddatelabel.isHidden = !isVisible
//        enddate.isHidden = !isVisible
//    }
//
//    // Called when switch value changes
//    @objc func switchValueChanged() {
//        toggleEndDateVisibility(isVisible: discontinuedswitch.isOn)
//    }
//
//    // MARK: - UIPickerView DataSource Methods
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1 // Only one column
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return dosageUnits.count
//    }
//
//    // MARK: - UIPickerView Delegate Methods
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return dosageUnits[row]
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        selectedDosageUnit = dosageUnits[row] // Store the selected unit
//    }
//
//    @IBAction func savebutton(_ sender: Any) {
//        print("Save Button pressed")
//        SaveToCoreData()
//    }
//
//    func SaveToCoreData() {
//        guard let medName = medicationname.text, !medName.isEmpty else {
//            print("Medication name is required.")
//            return
//        }
//        
//        guard let dosageUnit = selectedDosageUnit else {
//            print("Please select a dosage unit.")
//            return
//        }
//
//        if isEditMode {
//            let fetchRequest: NSFetchRequest<Medication> = Medication.fetchRequest()
//            fetchRequest.predicate = NSPredicate(format: "username == %@ AND childName == %@ AND medName == %@", user, childName, medicationName)
//
//            do {
//                print("Edit mode")
//                let medications = try managedObjectContext.fetch(fetchRequest)
//                if let existingMedication = medications.first {
//                    existingMedication.username = user
//                    existingMedication.childName = childName
//                    existingMedication.medName = medicationname.text
//                    existingMedication.notes = notes.text
//                    existingMedication.frequency = frequency.text
//                    existingMedication.startdate = startdate.date
//                    existingMedication.enddate = discontinuedswitch.isOn ? enddate.date : nil
//                    existingMedication.medunits = dosageUnit
//                }
//            } catch {
//                print("Error updating medication: \(error)")
//            }
//        } else {
//            print("Add mode")
//            let newMedication = Medication(context: managedObjectContext)
//            newMedication.username = user
//            newMedication.childName = childName
//            newMedication.medName = medicationname.text
//            newMedication.notes = notes.text
//            newMedication.frequency = frequency.text
//            newMedication.startdate = startdate.date
//            newMedication.enddate = discontinuedswitch.isOn ? enddate.date : nil
//            newMedication.medunits = dosageUnit
//        }
//
//        do {
//            try managedObjectContext.save()
//            print("Medication saved successfully!")
//            self.navigationController?.popViewController(animated: true)
//        } catch {
//            print("Error saving medication: \(error)")
//        }
//    }
//    
//    func populatedataifeditison() {
//        guard isEditMode else { return } // Only populate if edit mode is enabled
//
//        let fetchRequest: NSFetchRequest<Medication> = Medication.fetchRequest()
//        fetchRequest.predicate = NSPredicate(format: "username == %@ AND childName == %@ AND medName == %@", user, childName, medicationName)
//
//        do {
//            let medications = try managedObjectContext.fetch(fetchRequest)
//            if let existingMedication = medications.first {
//                // Populate UI elements with existing medication data
//                medicationname.text = existingMedication.medName
//                notes.text = existingMedication.notes
//                frequency.text = existingMedication.frequency
//                startdate.date = existingMedication.startdate ?? Date()
//                
//                if let endDate = existingMedication.enddate {
//                    enddate.date = endDate
//                    discontinuedswitch.isOn = true
//                    toggleEndDateVisibility(isVisible: true)
//                } else {
//                    discontinuedswitch.isOn = false
//                    toggleEndDateVisibility(isVisible: false)
//                }
//                
//                // Set the picker to the correct dosage unit
//                if let medUnit = existingMedication.medunits, let index = dosageUnits.firstIndex(of: medUnit) {
//                    dosagetype.selectRow(index, inComponent: 0, animated: true)
//                    selectedDosageUnit = medUnit
//                }
//            }
//        } catch {
//            print("Error fetching medication data: \(error)")
//        }
//    }
//
//}
//


import Foundation
import UIKit
import CoreData

class AddMedicationViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    var isEditMode = false
    var user = ""
    var childName = ""
    var medicationName = ""

    @IBOutlet weak var medicationname: UITextField!
    @IBOutlet weak var enddatelabel: UILabel!
    @IBOutlet weak var enddate: UIDatePicker!
    @IBOutlet weak var discontinuedswitch: UISwitch!
    @IBOutlet weak var notes: UITextView!
    @IBOutlet weak var frequency: UITextField!
    @IBOutlet weak var startdate: UIDatePicker!
    @IBOutlet weak var dosagetype: UIPickerView!
    @IBOutlet weak var dosageAmount: UITextField!

    let dosageUnits = ["mg", "ml", "tablet", "capsule"] // PickerView options
    var selectedDosageUnit: String? // Stores selected unit

    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // MARK: - Colors (match your app)
    private let purple = UIColor(red: 138/255, green: 96/255, blue: 176/255, alpha: 1) // #8A60B0
    private let pageBG = UIColor(red: 0.96, green: 0.95, blue: 0.94, alpha: 1)        // soft off-white
    private let fieldBorder = UIColor.black.withAlphaComponent(0.10)
    private let pillBG = UIColor.black.withAlphaComponent(0.06)

    override func viewDidLoad() {
        super.viewDidLoad()

        print(
            "On add medication page: ",
            "User: ",
            user,
            "Child Name: ",
            childName,
            "MedName: ",
            medicationName
        )

        // PickerView delegates
        dosagetype.delegate = self
        dosagetype.dataSource = self

        // Switch default
        discontinuedswitch.isOn = false

        // Initially hide end date + label
        toggleEndDateVisibility(isVisible: false)

        // Target for switch
        discontinuedswitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)

        // Populate fields if edit mode is active
        populatedataifeditison()

        // Tap to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)

        // Delegates to handle return key
        medicationname.delegate = self
        frequency.delegate = self
        dosageAmount.delegate = self

        // ✅ Apply styling
        applyStyling()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Keep pill shapes correct after layout
        dosagetype.layer.cornerRadius = dosagetype.bounds.height / 2
        dosagetype.clipsToBounds = true

        medicationname.layer.cornerRadius = medicationname.bounds.height / 2
        dosageAmount.layer.cornerRadius = dosageAmount.bounds.height / 2
        frequency.layer.cornerRadius = frequency.bounds.height / 2

        notes.layer.cornerRadius = 14
    }

    // MARK: - Styling
    private func applyStyling() {
        view.backgroundColor = pageBG
        navigationController?.navigationBar.tintColor = purple

        // TextFields = white pill
        styleTextField(medicationname, placeholder: "Medication name")
        styleTextField(dosageAmount, placeholder: "dosage amount")
        styleTextField(frequency, placeholder: "frequency")

        // Notes box = white card
        notes.backgroundColor = .white
        notes.layer.borderWidth = 1
        notes.layer.borderColor = fieldBorder.cgColor
        notes.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        notes.font = .systemFont(ofSize: 16)
        notes.textColor = .label

        // Date pickers = subtle “chip” look (optional, but makes it nicer)
        styleDatePicker(startdate)
        styleDatePicker(enddate)

        // Switch tint to your purple
        discontinuedswitch.onTintColor = purple.withAlphaComponent(0.55)

        // ✅ UIPickerView styled like the “mg” pill
        styleDosagePickerPill()

        // If no selection yet, default to first row so “mg” shows centered
        if selectedDosageUnit == nil {
            selectedDosageUnit = dosageUnits.first
            dosagetype.selectRow(0, inComponent: 0, animated: false)
        }
    }

    private func styleTextField(_ field: UITextField, placeholder: String) {
        field.borderStyle = .none
        field.backgroundColor = .white
        field.layer.borderWidth = 1
        field.layer.borderColor = fieldBorder.cgColor
        field.clipsToBounds = true

        field.textColor = .label
        field.font = .systemFont(ofSize: 16, weight: .regular)

        field.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: UIColor.secondaryLabel]
        )

        // padding
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 10))
        field.leftView = padding
        field.leftViewMode = .always
    }

    private func styleDatePicker(_ picker: UIDatePicker) {
        // Gives it a small “chip” vibe if you’re using compact style in storyboard
        picker.tintColor = purple
    }

    private func styleDosagePickerPill() {
        // Make the picker itself look like the small gray “mg” pill
        dosagetype.backgroundColor = pillBG
        dosagetype.layer.borderWidth = 0
        dosagetype.clipsToBounds = true

        // Important: if your picker is tall right now, it will show multiple rows.
        // In storyboard, set its HEIGHT constraint to ~36–44 for the “pill” effect.
        // Then it will clip and only show the selected row.
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // MARK: - Function to toggle visibility of end date and label
    func toggleEndDateVisibility(isVisible: Bool) {
        enddatelabel.isHidden = !isVisible
        enddate.isHidden = !isVisible
    }

    // Called when switch value changes
    @objc func switchValueChanged() {
        toggleEndDateVisibility(isVisible: discontinuedswitch.isOn)
    }

    // MARK: - UIPickerView DataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        dosageUnits.count
    }

    // MARK: - UIPickerView Delegate
    // Use attributed titles so the “mg” text matches your UI
    func pickerView(_ pickerView: UIPickerView,
                    attributedTitleForRow row: Int,
                    forComponent component: Int) -> NSAttributedString? {
        let title = dosageUnits[row]
        return NSAttributedString(
            string: title,
            attributes: [
                .foregroundColor: UIColor.label.withAlphaComponent(0.85),
                .font: UIFont.systemFont(ofSize: 18, weight: .semibold)
            ]
        )
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDosageUnit = dosageUnits[row]
    }

    @IBAction func savebutton(_ sender: Any) {
        print("Save Button pressed")
        SaveToCoreData()
    }

    func SaveToCoreData() {
        guard let medName = medicationname.text, !medName.isEmpty else {
            print("Medication name is required.")
            return
        }

        guard let dosageUnit = selectedDosageUnit else {
            print("Please select a dosage unit.")
            return
        }

        if isEditMode {
            let fetchRequest: NSFetchRequest<Medication> = Medication.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "username == %@ AND childName == %@ AND medName == %@", user, childName, medicationName)

            do {
                print("Edit mode")
                let medications = try managedObjectContext.fetch(fetchRequest)
                if let existingMedication = medications.first {
                    existingMedication.username = user
                    existingMedication.childName = childName
                    existingMedication.medName = medicationname.text
                    existingMedication.notes = notes.text
                    existingMedication.frequency = frequency.text
                    existingMedication.startdate = startdate.date
                    existingMedication.enddate = discontinuedswitch.isOn ? enddate.date : nil
                    existingMedication.medunits = dosageUnit
                }
            } catch {
                print("Error updating medication: \(error)")
            }
        } else {
            print("Add mode")
            let newMedication = Medication(context: managedObjectContext)
            newMedication.username = user
            newMedication.childName = childName
            newMedication.medName = medicationname.text
            newMedication.notes = notes.text
            newMedication.frequency = frequency.text
            newMedication.startdate = startdate.date
            newMedication.enddate = discontinuedswitch.isOn ? enddate.date : nil
            newMedication.medunits = dosageUnit
        }

        do {
            try managedObjectContext.save()
            print("Medication saved successfully!")
            self.navigationController?.popViewController(animated: true)
        } catch {
            print("Error saving medication: \(error)")
        }
    }

    func populatedataifeditison() {
        guard isEditMode else { return }

        let fetchRequest: NSFetchRequest<Medication> = Medication.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@ AND childName == %@ AND medName == %@", user, childName, medicationName)

        do {
            let medications = try managedObjectContext.fetch(fetchRequest)
            if let existingMedication = medications.first {
                medicationname.text = existingMedication.medName
                notes.text = existingMedication.notes
                frequency.text = existingMedication.frequency
                startdate.date = existingMedication.startdate ?? Date()

                if let endDate = existingMedication.enddate {
                    enddate.date = endDate
                    discontinuedswitch.isOn = true
                    toggleEndDateVisibility(isVisible: true)
                } else {
                    discontinuedswitch.isOn = false
                    toggleEndDateVisibility(isVisible: false)
                }

                if let medUnit = existingMedication.medunits,
                   let index = dosageUnits.firstIndex(of: medUnit) {
                    dosagetype.selectRow(index, inComponent: 0, animated: true)
                    selectedDosageUnit = medUnit
                } else {
                    selectedDosageUnit = dosageUnits.first
                    dosagetype.selectRow(0, inComponent: 0, animated: false)
                }
            }
        } catch {
            print("Error fetching medication data: \(error)")
        }
    }
}
