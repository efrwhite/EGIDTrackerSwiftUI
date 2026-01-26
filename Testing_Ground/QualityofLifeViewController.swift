//
//import UIKit
//import CoreData
//
//struct QualityEntry {
//    let sum: Int
//    let date: Date
//}
//
//protocol QualityofLifeViewControllerDelegate: AnyObject {
//    func qualityOfLifeViewController(_ controller: QualityofLifeViewController, didAddNewQualityEntry entry: QualityEntry)
//}
//
//class QualityofLifeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//    
//    weak var delegate: QualityofLifeViewControllerDelegate?
//    var capturedData: [[String: Any]] = []
//    
//    let symptomsone = ["I have chest pain, ache, or hurt", "I have burning in my chest, mouth, or throat (heartburn)", "I have stomach aches or belly aches", "I throw up (vomit)", "I feel like I'm going to throw up, but I don't (nausea)", "When I am eating, food comes back up my throat"]
//    let symptomstwo = ["I have trouble swallowing", "I feel like food gets stuck in my throat or chest", "I need to drink to help me swallow my food", "I need more time to eat than other kids my age"]
//    let treatment = ["It is hard for me to take my medicine", "I do not want to take my medicines", "I do not like going to the doctor", "I do not like getting an endoscopy (scope, EGD)", "I do not like getting allergy testing"]
//    let worry = ["I worry about having EOE", "I worry about getting sick in front of other people", "I worry about what other people think about me because of EOE", "I worry about getting allergy testing"]
//    let communication = ["I have trouble telling other people about EOE", "I have trouble talking to my parents about how I feel", "I have trouble talking to other adults about how I feel", "I have trouble talking to my friends about how I feel", "I have trouble talking to doctors or nurses about how I feel"]
//    let foodandeating = ["It is hard not being allowed to eat some foods", "It is hard for me not to sneak foods I'm allergic to", "It is hard for me to not eat the same things as my family", "It is hard not to eat the same things as my friends"]
//    let foodfeelingQ = ["I worry about eating foods I'm allergic to or not supposed to eat", "I'm upset about not eating foods I'm allergic to/not supposed to eat", "I'm sad about not eating foods I'm allergic to/not supposed to eat"]
//    
//    let sections = [
//        "SYMPTOMS I",
//        "SYMPTOMS II",
//        "TREATMENT",
//        "WORRY",
//        "COMMUNICATION",
//        "FOOD AND EATING",
//        "FOOD FEELINGS"
//    ]
//    var user = ""
//    var childName = ""
//    var sectionData: [[String]] {
//        return [
//            symptomsone,
//            symptomstwo,
//            treatment,
//            worry,
//            communication,
//            foodandeating,
//            foodfeelingQ
//        ]
//    }
//    
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var saveButton: UIButton!
//    
//    var sectionResponses: [[String?]] = []
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        print("Save Button Frame:", saveButton.frame)
//        
//        // Register table view cell
//        let nib = UINib(nibName: "QualityofLifeTableViewCell", bundle: nil)
//        tableView.register(nib, forCellReuseIdentifier: "QualityofLifeTableViewCell")
//        
//        // Set table view delegate and data source
//        tableView.delegate = self
//        tableView.dataSource = self
//        
//        // Initialize section responses
//        for section in sectionData {
//            sectionResponses.append(Array(repeating: nil, count: section.count))
//        }
//        
//        // Disable save button initially
//        saveButton.isEnabled = false
//        
//        // Setup keyboard notifications
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//        
//        // Setup tap gesture to dismiss keyboard
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//        tapGesture.cancelsTouchesInView = false
//        view.addGestureRecognizer(tapGesture)
//    }
//    
//    @objc func dismissKeyboard() {
//        view.endEditing(true)
//    }
//    
//    @objc func keyboardWillShow(notification: Notification) {
//        if let userInfo = notification.userInfo,
//           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//            let keyboardHeight = keyboardFrame.cgRectValue.height
//            tableView.contentInset.bottom = keyboardHeight
//            tableView.scrollIndicatorInsets.bottom = keyboardHeight
//        }
//    }
//    
//    @objc func keyboardWillHide(notification: Notification) {
//        tableView.contentInset.bottom = 0
//        tableView.scrollIndicatorInsets.bottom = 0
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return sections.count
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return sectionData[section].count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "QualityofLifeTableViewCell", for: indexPath) as! QualityofLifeTableViewCell
//        
//        // Set question label and configure text field
//        cell.questionlabel.text = sectionData[indexPath.section][indexPath.row]
//        cell.ratingText.tag = indexPath.section * 100 + indexPath.row
//        cell.ratingText.text = sectionResponses[indexPath.section][indexPath.row]
//        cell.ratingText.addTarget(self, action: #selector(responseTextFieldDidChange(_:)), for: .editingChanged)
//        
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//        headerView.backgroundColor = UIColor.lightGray
//        
//        let label = UILabel()
//        label.text = sections[section]
//        label.font = UIFont.boldSystemFont(ofSize: 16)
//        label.frame = CGRect(x: 16, y: 8, width: tableView.bounds.width - 32, height: 0)
//        label.sizeToFit()
//        headerView.addSubview(label)
//        
//        return headerView
//    }
//    
//    @objc func responseTextFieldDidChange(_ textField: UITextField) {
//        let section = textField.tag / 100
//        let row = textField.tag % 100
//        let response = textField.text
//        
//        // Validate input (ensure it's a number between 0 and 4)
//        if let responseValue = response, let intValue = Int(responseValue), intValue >= 0 && intValue <= 4 {
//            sectionResponses[section][row] = response
//        } else {
//            sectionResponses[section][row] = nil
//            textField.text = ""
//            showAlertInvalidInput()
//        }
//        
//        updateSaveButtonState()
//    }
//
//    func showAlertInvalidInput() {
//        let alert = UIAlertController(title: "Invalid Input", message: "Please enter a value between 0 and 4.", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//    }
//    
//    func updateSaveButtonState() {
//        // Check if all fields have been filled out
//        for section in sectionResponses {
//            for response in section {
//                if response == nil || response!.isEmpty {
//                    saveButton.isEnabled = false
//                    return
//                }
//            }
//        }
//        saveButton.isEnabled = true
//    }
//    
//    @IBAction func saveButtonTapped(_ sender: Any) {
//        // Disable the button immediately to prevent double taps
//        saveButton.isEnabled = false
//        
//        // Add a small delay before saving to avoid double taps
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.captureData()  // Capture the data (question-answer pairs)
//            
//            // Save the data to CoreData
//            let entries = self.saveDataToCoreData()  // Save the captured data to CoreData
//            
//            // Optionally notify the delegate about the new entries
//            if let entry = entries.first {
//                self.delegate?.qualityOfLifeViewController(self, didAddNewQualityEntry: entry)
//            }
//            
//            // After saving, perform the segue
//            //self.performSegue(withIdentifier: "QualityResultSegue", sender: self)
//            
//            // Re-enable the save button when the action is complete
//            self.saveButton.isEnabled = true
//        }
//    }
//
//
//
//
//    
//    func captureData() {
//        var sum = 0
//        
//        // Iterate over each section and row to calculate the sum of all responses
//        for sectionIndex in 0..<sectionResponses.count {
//            for rowIndex in 0..<sectionResponses[sectionIndex].count {
//                if let response = sectionResponses[sectionIndex][rowIndex], let intValue = Int(response) {
//                    sum += intValue  // Add the response value to the sum
//                }
//            }
//        }
//        
//        // Store the sum and the current date
//        capturedData = [["sum": sum, "date": Date()]]
//    }
//
//    func saveDataToCoreData() -> [QualityEntry] {
//        let appDelegate = UIApplication.shared.delegate as? AppDelegate
//        let context = appDelegate?.persistentContainer.viewContext
//        var entries: [QualityEntry] = []
//        print("In core data save function: ", entries)
//        // Get the sum and date from capturedData
//        if let data = capturedData.first {
//            let sum = data["sum"] as? Int ?? 0
//            let currentDate = data["date"] as? Date ?? Date()
//            print("Sum in save function",sum)
//            print("date in save function", currentDate)
//            // Create a new Quality object in Core Data
//            let newQuality = NSEntityDescription.insertNewObject(forEntityName: "Quality", into: context!)
//            
//            // Save the sum and date to Core Data
//            newQuality.setValue(user, forKey: "user")
//            newQuality.setValue(childName, forKey: "childName")
//            newQuality.setValue(Int64(sum), forKey: "qualitySum") // Store the sum
//            newQuality.setValue(currentDate, forKey: "date") // Store the current date
//            
//            do {
//                try context!.save()  // Save the object to Core Data
//                print("Quality data saved successfully.")
//                
//                // Create a QualityEntry from the saved data
//                let entry = QualityEntry(sum: sum, date: currentDate)
//                entries.append(entry)
//            } catch let error as NSError {
//                print("Could not save Quality data. \(error), \(error.userInfo)")
//            }
//        }
//        
//        return entries
//    }
//
//
//
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "QualityResultSegue",
//           let destinationVC = segue.destination as? QualityResultViewController {
//            let entries = saveDataToCoreData()
//                destinationVC.user = user
//                destinationVC.childName = childName
//            
//        } else if segue.identifier == "QualityResultsSegue",
//                  let destinationVC = segue.destination as? QualityResultViewController {
//                destinationVC.user = user
//                destinationVC.childName = childName
//            
//        }
//        
//    }
//}

//addition of the headers and extra coredata functionality

import UIKit
import CoreData

struct QualityEntry {
    let sum: Int
    let date: Date
}

protocol QualityofLifeViewControllerDelegate: AnyObject {
    func qualityOfLifeViewController(_ controller: QualityofLifeViewController, didAddNewQualityEntry entry: QualityEntry)
}

class QualityofLifeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: QualityofLifeViewControllerDelegate?
    var capturedData: [[String: Any]] = []
    
    let symptomsone = ["I have chest pain, ache, or hurt", "I have burning in my chest, mouth, or throat (heartburn)", "I have stomach aches or belly aches", "I throw up (vomit)", "I feel like I'm going to throw up, but I don't (nausea)", "When I am eating, food comes back up my throat"]
    let symptomstwo = ["I have trouble swallowing", "I feel like food gets stuck in my throat or chest", "I need to drink to help me swallow my food", "I need more time to eat than other kids my age"]
    let treatment = ["It is hard for me to take my medicine", "I do not want to take my medicines", "I do not like going to the doctor", "I do not like getting an endoscopy (scope, EGD)", "I do not like getting allergy testing"]
    let worry = ["I worry about having EOE", "I worry about getting sick in front of other people", "I worry about what other people think about me because of EOE", "I worry about getting allergy testing"]
    let communication = ["I have trouble telling other people about EOE", "I have trouble talking to my parents about how I feel", "I have trouble talking to other adults about how I feel", "I have trouble talking to my friends about how I feel", "I have trouble talking to doctors or nurses about how I feel"]
    let foodandeating = ["It is hard not being allowed to eat some foods", "It is hard for me not to sneak foods I'm allergic to", "It is hard for me to not eat the same things as my family", "It is hard not to eat the same things as my friends"]
    let foodfeelingQ = ["I worry about eating foods I'm allergic to or not supposed to eat", "I'm upset about not eating foods I'm allergic to/not supposed to eat", "I'm sad about not eating foods I'm allergic to/not supposed to eat"]
    
    let sections = [
        "SYMPTOMS I",
        "SYMPTOMS II",
        "TREATMENT",
        "WORRY",
        "COMMUNICATION",
        "FOOD AND EATING",
        "FOOD FEELINGS"
    ]
    var user = ""
    var childName = ""
    var sectionData: [[String]] {
        return [
            symptomsone,
            symptomstwo,
            treatment,
            worry,
            communication,
            foodandeating,
            foodfeelingQ
        ]
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    
    var sectionResponses: [[String?]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Save Button Frame:", saveButton.frame)
        
        // Register table view cell
        let nib = UINib(nibName: "QualityofLifeTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "QualityofLifeTableViewCell")
        
        // Set table view delegate and data source
        tableView.delegate = self
        tableView.dataSource = self
        
        // Initialize section responses
        for section in sectionData {
            sectionResponses.append(Array(repeating: nil, count: section.count))
        }
        
        // Disable save button initially
        saveButton.isEnabled = false
        
        // Setup keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Setup tap gesture to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        setupKeyboardDismissal()
        setupTableHeader()

    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }


    @objc func keyboardWillShow(notification: Notification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            let keyboardHeight = keyboardFrame.cgRectValue.height
            let bottomInset = keyboardHeight - view.safeAreaInsets.bottom  // Adjust for safe area
            
            tableView.contentInset.bottom = bottomInset
            tableView.verticalScrollIndicatorInsets.bottom = bottomInset  // ✅ Fixed this line
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    @objc func keyboardWillHide(notification: Notification) {
        tableView.contentInset.bottom = 0
        tableView.verticalScrollIndicatorInsets.bottom = 0  // ✅ Reset properly
    }

    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "QualityofLifeTableViewCell", for: indexPath) as! QualityofLifeTableViewCell
            let actualIndex = indexPath.row  // Adjust index for the data array
            
            cell.questionlabel.text = sectionData[indexPath.section][actualIndex]
            cell.ratingText.tag = indexPath.section * 100 + actualIndex
            cell.ratingText.text = sectionResponses[indexPath.section][actualIndex]
            cell.ratingText.addTarget(self, action: #selector(responseTextFieldDidChange(_:)), for: .editingChanged)
            
            return cell
        
    }
  

    func setupTableHeader() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 80))
        headerView.backgroundColor = UIColor.systemGray6

        let headerLabel = UILabel()
        headerLabel.text = "Please Insert the following based on questions below:\n0 = Not at all - 4 = Very often"
        headerLabel.numberOfLines = 0
        headerLabel.font = UIFont.boldSystemFont(ofSize: 16)
        headerLabel.textAlignment = .center
        headerLabel.textColor = .black
        headerLabel.translatesAutoresizingMaskIntoConstraints = false

        headerView.addSubview(headerLabel)

        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            headerLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),
            headerLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
        ])

        tableView.tableHeaderView = headerView
    }
    

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.lightGray

        let label = UILabel()
        label.text = sections[section]  // Uses the section title
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false

        headerView.addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -8)
        ])

        return headerView
    }





    
    @objc func responseTextFieldDidChange(_ textField: UITextField) {
        let section = textField.tag / 100
        let row = textField.tag % 100
        let response = textField.text
        
        // Validate input (ensure it's a number between 0 and 4)
        if let responseValue = response, let intValue = Int(responseValue), intValue >= 0 && intValue <= 4 {
            sectionResponses[section][row] = response
        } else {
            sectionResponses[section][row] = nil
            textField.text = ""
            showAlertInvalidInput()
        }
        
        updateSaveButtonState()
    }

    func showAlertInvalidInput() {
        let alert = UIAlertController(title: "Invalid Input", message: "Please enter a value between 0 and 4.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateSaveButtonState() {
        // Check if all fields have been filled out
        for section in sectionResponses {
            for response in section {
                if response == nil || response!.isEmpty {
                    saveButton.isEnabled = false
                    return
                }
            }
        }
        saveButton.isEnabled = true
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        // Disable the button immediately to prevent double taps
        saveButton.isEnabled = false
        
        // Add a small delay before saving to avoid double taps
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.captureData()  // Capture the data (question-answer pairs)
            
            // Save the data to CoreData
            let entries = self.saveDataToCoreData()  // Save the captured data to CoreData
            
            // Optionally notify the delegate about the new entries
            if let entry = entries.first {
                self.delegate?.qualityOfLifeViewController(self, didAddNewQualityEntry: entry)
            }
            
            // After saving, perform the segue
            //self.performSegue(withIdentifier: "QualityResultSegue", sender: self)
            
            // Re-enable the save button when the action is complete
            self.saveButton.isEnabled = true
        }
    }




    
    func captureData() {
        var sum = 0
        
        // Iterate over each section and row to calculate the sum of all responses
        print("PRINTING SECTION DATA, \(sectionResponses) and \(sectionData)")
        for sectionIndex in 0..<sectionResponses.count {
            print("section",sectionIndex)
            for rowIndex in 0..<sectionResponses[sectionIndex].count {
                print("row",rowIndex)
                if let response = sectionResponses[sectionIndex][rowIndex], let intValue = Int(response) {
                    sum += intValue  // Add the response value to the sum
                }
            }
        }
        
        // Store the sum and the current date
        capturedData = [["sum": sum, "date": Date()]]
    }

    func saveDataToCoreData() -> [QualityEntry] {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        var entries: [QualityEntry] = []
        print("In core data save function: ", entries)
        // Get the sum and date from capturedData
        let sectionResponsesCopy = sectionResponses.map { $0 }
        let flattened = sectionResponsesCopy.flatMap { $0 }
        let sumSymptomsOne = flattened[0..<min(flattened.count, 5)].compactMap { Int($0 ?? "") }.reduce(0, +)
        let sumSymptomsTwo = flattened[6..<min(flattened.count, 10)].compactMap { Int($0 ?? "") }.reduce(0, +)
        let sumTreatment = flattened[11..<min(flattened.count, 15)].compactMap { Int($0 ?? "") }.reduce(0, +)
        let sumWorry = flattened[16..<min(flattened.count, 19)].compactMap { Int($0 ?? "") }.reduce(0, +)
        let sumCommunication = flattened[20..<min(flattened.count, 24)].compactMap { Int($0 ?? "") }.reduce(0, +)
        let sumFoodAndEating = flattened[25..<min(flattened.count, 28)].compactMap { Int($0 ?? "") }.reduce(0, +)
        let sumFoodFeelings = flattened[29..<min(flattened.count, 31)].compactMap { Int($0 ?? "") }.reduce(0, +)

        print("COPY OF Section Responses, \(sectionResponsesCopy)")
        if let data = capturedData.first {
            let sum = data["sum"] as? Int ?? 0
            let currentDate = data["date"] as? Date ?? Date()
            print("Sum in save function",sum)
            print("date in save function", currentDate)
            // Create a new Quality object in Core Data
            let newQuality = NSEntityDescription.insertNewObject(forEntityName: "Quality", into: context!)
            //adding subsections lazy method
            // Step 3: Save to Core Data
            newQuality.setValue(sumSymptomsOne, forKey: "symptomsone")
            newQuality.setValue(sumSymptomsTwo, forKey: "symptomstwo")
            newQuality.setValue(sumTreatment, forKey: "treatment")
            newQuality.setValue(sumWorry, forKey: "worry")
            newQuality.setValue(sumCommunication, forKey: "communication")
            newQuality.setValue(sumFoodAndEating, forKey: "foodandeating")
            newQuality.setValue(sumFoodFeelings, forKey: "foodfeelings")
            

            // Save the sum and date to Core Data
            newQuality.setValue(user, forKey: "user")
            newQuality.setValue(childName, forKey: "childName")
            newQuality.setValue(Int64(sum), forKey: "qualitySum") // Store the sum
            newQuality.setValue(currentDate, forKey: "date") // Store the current date
            
            do {
                try context!.save()  // Save the object to Core Data
                print("Quality data saved successfully.")
                
                // Create a QualityEntry from the saved data
                let entry = QualityEntry(sum: sum, date: currentDate)
                entries.append(entry)
            } catch let error as NSError {
                print("Could not save Quality data. \(error), \(error.userInfo)")
            }
        }
        
        return entries
    }




    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "QualityResultSegue",
           let destinationVC = segue.destination as? QualityResultViewController {
            let entries = saveDataToCoreData()
                destinationVC.user = user
                destinationVC.childName = childName
            
        } else if segue.identifier == "QualityResultsSegue",
                  let destinationVC = segue.destination as? QualityResultViewController {
                destinationVC.user = user
                destinationVC.childName = childName
            
        }
        
    }
}
