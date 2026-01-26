//
//import UIKit
//import CoreData
//
//class Diet6GoodViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
//
//    var user = ""
//    var childName = ""
//
//    let categories = ["Endoscopy", "Allergies", "Medication", "Accidental Exposure", "Symptom Score", "Quality of Life"]
//    var selectedCategory: String?
//
//    var tableViewData: [(date: String, descriptor: String)] = []
//
//    let categoryPicker: UIPickerView = {
//        let picker = UIPickerView()
//        picker.translatesAutoresizingMaskIntoConstraints = false
//        return picker
//    }()
//    
//    let tableView: UITableView = {
//        let table = UITableView()
//        table.translatesAutoresizingMaskIntoConstraints = false
//        table.register(UITableViewCell.self, forCellReuseIdentifier: "HistoryCell")
//        return table
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        print("In Journal, ",user, childName)
//        view.backgroundColor = .white
//        setupPicker()
//        setupTableView()
//    }
//    
//    func setupPicker() {
//        categoryPicker.delegate = self
//        categoryPicker.dataSource = self
//        view.addSubview(categoryPicker)
//        
//        NSLayoutConstraint.activate([
//            categoryPicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
//            categoryPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            categoryPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            categoryPicker.heightAnchor.constraint(equalToConstant: 150)
//        ])
//    }
//    
//    func setupTableView() {
//        view.addSubview(tableView)
//        tableView.delegate = self
//        tableView.dataSource = self
//        
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: categoryPicker.bottomAnchor, constant: 10),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
//        ])
//    }
//
//    // MARK: - UIPickerView DataSource & Delegate
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return categories.count
//    }
//
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        return categories[row]
//    }
//
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        selectedCategory = categories[row]
//        fetchData(for: selectedCategory!)
//    }
// 
//    func fetchData(for category: String) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        let context = appDelegate.persistentContainer.viewContext
//
//        var fetchRequest: NSFetchRequest<NSManagedObject>?
//
//        switch category {
//        case "Endoscopy":
//            fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Endoscopy")
//        case "Allergies":
//            fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Allergies")
//        case "Medication":
//            fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Medication")
//        case "Accidental Exposure":
//            fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AccidentalExposure")
//        case "Symptom Score":
//            fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Symptom")
//        case "Quality of Life":
//            fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Quality")
//        default:
//            return
//        }
//       
//        // Apply correct predicates based on entity type
//        var userPredicate: NSPredicate?
//        //let userPredicate = NSPredicate(format: "username == %@", user)
//        var childPredicate: NSPredicate?
//        switch category {
//        case "Quality of Life", "Symptom Score":
//            userPredicate = NSPredicate(format: "user == %@", user)
//        case "Endoscopy", "Medication", "Allergies", "Accidental Exposure":
//            userPredicate = NSPredicate(format: "username == %@", user)
//        default:
//            break
//        }
//        switch category {
//        case "Endoscopy", "Medication":
//            childPredicate = NSPredicate(format: "childName == %@", childName)
//        case "Allergies", "Accidental Exposure":
//            childPredicate = NSPredicate(format: "childname == %@", childName) // Lowercase "childname"
//        
//        default:
//            break
//        }
//
////        if let childPredicate = childPredicate {
////            fetchRequest?.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [userPredicate, childPredicate])
////        } else {
////            fetchRequest?.predicate = userPredicate
////        }
//        if let userPredicate = userPredicate {
//            if let childPredicate = childPredicate {
//                fetchRequest?.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [userPredicate, childPredicate])
//            } else {
//                fetchRequest?.predicate = userPredicate
//            }
//        } else if let childPredicate = childPredicate {
//            fetchRequest?.predicate = childPredicate
//        } else {
//            fetchRequest?.predicate = nil // or handle fallback
//        }
//
//
//        do {
//            let results = try context.fetch(fetchRequest!)
//            let formatter = DateFormatter()
//            formatter.dateStyle = .short
//
//            tableViewData = results.map {
//                var dateString = "N/A"
//                var descriptor = "N/A"
//
//                switch category {
//                case "Endoscopy":
//                    if let procedureDate = $0.value(forKey: "procedureDate") as? Date {
//                        dateString = formatter.string(from: procedureDate)
//                    }
//
//                    let duodenum = $0.value(forKey: "duodenum") as? String ?? ""
//                    let stomach = $0.value(forKey: "stomach") as? String ?? ""
//                    let leftColon = $0.value(forKey: "leftColon") as? String ?? ""
//                    let middleColon = $0.value(forKey: "middleColon") as? String ?? ""
//                    let rightColon = $0.value(forKey: "rightColon") as? String ?? ""
//
//                    if !leftColon.isEmpty || !middleColon.isEmpty || !rightColon.isEmpty {
//                        descriptor = "Endoscopy Colon"
//                    } else if !duodenum.isEmpty {
//                        descriptor = "Endoscopy Duodenum"
//                    } else if !stomach.isEmpty {
//                        descriptor = "Endoscopy Stomach"
//                    } else {
//                        descriptor = "Endoscopy EoE"
//                    }
//
//                case "Allergies":
//                    let startDate = $0.value(forKey: "startdate") as? Date
//                    let endDate = $0.value(forKey: "enddate") as? Date
//                    let start = startDate != nil ? formatter.string(from: startDate!) : "N/A"
//                    let end = endDate != nil ? formatter.string(from: endDate!) : "N/A"
//                    dateString = "Start: \(start), End: \(end)"
//                    descriptor = $0.value(forKey: "name") as? String ?? "Unknown Allergen"
//
//                case "Medication":
//                    let startDate = $0.value(forKey: "startdate") as? Date
//                    let endDate = $0.value(forKey: "enddate") as? Date
//                    let start = startDate != nil ? formatter.string(from: startDate!) : "N/A"
//                    let end = endDate != nil ? formatter.string(from: endDate!) : "N/A"
//                    dateString = "Start: \(start), End: \(end)"
//                    descriptor = $0.value(forKey: "medName") as? String ?? "Unknown Medication"
//
//                case "Accidental Exposure":
//                    if let exposureDate = $0.value(forKey: "date") as? Date {
//                        dateString = formatter.string(from: exposureDate)
//                    }
//                    descriptor = $0.value(forKey: "item") as? String ?? "Unknown Substance"
//                case "Symptom Score":
//                    let startDate = $0.value(forKey: "date") as? Date
//                    dateString = "Date: \(String(describing: startDate))"
//                    let sum = $0.value(forKey: "symptomSum") as? Int
//                    descriptor = "Symptom Score: \(String(describing: sum))"
//                case "Quality of Life":
//                    let startDate = $0.value(forKey: "date") as? Date
//                    dateString = "Date: \(String(describing: startDate))"
//                    let sum = $0.value(forKey: "qualitySum") as? Int
//                    descriptor = "Quality Score: \(String(describing: sum))"
//                default:
//                    break
//                }
//
//                return (dateString, descriptor)
//            }
//            tableView.reloadData()
//        } catch {
//            print("Error fetching \(category) data: \(error)")
//        }
//    }
//
//    // MARK: - UITableView DataSource & Delegate
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return tableViewData.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
//        let entry = tableViewData[indexPath.row]
//
//        cell.textLabel?.text = "Date: \(entry.date) | Info: \(entry.descriptor)"
//        cell.textLabel?.numberOfLines = 0
//
//        return cell
//    }
//}


import UIKit
import CoreData

class Diet6GoodViewController: UIViewController,
                              UITableViewDelegate, UITableViewDataSource,
                              UIPickerViewDelegate, UIPickerViewDataSource {

    var user = ""
    var childName = ""

    let categories = ["Endoscopy", "Allergies", "Medication", "Accidental Exposure", "Symptom Score", "Quality of Life"]
    var selectedCategory: String?

    // Keep as plain strings so the cell never prints "Optional(...)"
    var tableViewData: [(date: String, descriptor: String)] = []

    let categoryPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "HistoryCell")
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("In Journal, ", user, childName)

        view.backgroundColor = .white
        setupPicker()
        setupTableView()

        // ✅ Make the first category load immediately (fixes “first in queue” feeling)
        selectedCategory = categories.first
        categoryPicker.selectRow(0, inComponent: 0, animated: false)
        if let first = selectedCategory {
            fetchData(for: first)
        }
    }

    func setupPicker() {
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        view.addSubview(categoryPicker)

        NSLayoutConstraint.activate([
            categoryPicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            categoryPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryPicker.heightAnchor.constraint(equalToConstant: 150)
        ])
    }

    func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: categoryPicker.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    // MARK: - UIPickerView DataSource & Delegate
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        categories.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        categories[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = categories[row]
        fetchData(for: categories[row])
    }

    // MARK: - Helpers (no Optional(...) ever)
    private func formatDate(_ date: Date?, formatter: DateFormatter) -> String {
        guard let date else { return "N/A" }
        return formatter.string(from: date)
    }

    private func formatInt(_ value: Int?) -> String {
        guard let value else { return "N/A" }
        return "\(value)"
    }

    func fetchData(for category: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<NSManagedObject>

        switch category {
        case "Endoscopy":
            fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Endoscopy")
        case "Allergies":
            fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Allergies")
        case "Medication":
            fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Medication")
        case "Accidental Exposure":
            fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AccidentalExposure")
        case "Symptom Score":
            fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Symptom")
        case "Quality of Life":
            fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Quality")
        default:
            return
        }

        // Date formatter
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none

        // ---- Predicates ----
        // Endoscopy is the one most likely to have "user" vs "username" differences,
        // so we allow either.
        var userPredicate: NSPredicate?
        var childPredicate: NSPredicate?

        switch category {
        case "Endoscopy":
            // ✅ Match either field name, so you still get results if your model uses "user"
            userPredicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
                NSPredicate(format: "username == %@", user),
                NSPredicate(format: "user == %@", user)
            ])
            childPredicate = NSPredicate(format: "childName == %@", childName)

        case "Quality of Life", "Symptom Score":
            userPredicate = NSPredicate(format: "user == %@", user)

        case "Medication":
            userPredicate = NSPredicate(format: "username == %@", user)
            childPredicate = NSPredicate(format: "childName == %@", childName)

        case "Allergies", "Accidental Exposure":
            userPredicate = NSPredicate(format: "username == %@", user)
            childPredicate = NSPredicate(format: "childname == %@", childName) // lower-case matches your model usage

        default:
            break
        }

        if let userPredicate, let childPredicate {
            fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [userPredicate, childPredicate])
        } else if let userPredicate {
            fetchRequest.predicate = userPredicate
        } else if let childPredicate {
            fetchRequest.predicate = childPredicate
        } else {
            fetchRequest.predicate = nil
        }

        do {
            let results = try context.fetch(fetchRequest)

            tableViewData = results.map { obj in
                var dateString = "N/A"
                var descriptor = "N/A"

                switch category {
                case "Endoscopy":
                    let procedureDate = obj.value(forKey: "procedureDate") as? Date
                    dateString = formatDate(procedureDate, formatter: formatter)

                    let duodenum = (obj.value(forKey: "duodenum") as? String) ?? ""
                    let stomach = (obj.value(forKey: "stomach") as? String) ?? ""
                    let leftColon = (obj.value(forKey: "leftColon") as? String) ?? ""
                    let middleColon = (obj.value(forKey: "middleColon") as? String) ?? ""
                    let rightColon = (obj.value(forKey: "rightColon") as? String) ?? ""

                    if !leftColon.isEmpty || !middleColon.isEmpty || !rightColon.isEmpty {
                        descriptor = "Endoscopy (Colon)"
                    } else if !duodenum.isEmpty {
                        descriptor = "Endoscopy (Duodenum)"
                    } else if !stomach.isEmpty {
                        descriptor = "Endoscopy (Stomach)"
                    } else {
                        descriptor = "Endoscopy"
                    }

                case "Allergies":
                    let start = formatDate(obj.value(forKey: "startdate") as? Date, formatter: formatter)
                    let end = formatDate(obj.value(forKey: "enddate") as? Date, formatter: formatter)
                    dateString = "Start: \(start) • End: \(end)"
                    descriptor = (obj.value(forKey: "name") as? String) ?? "Unknown Allergen"

                case "Medication":
                    let start = formatDate(obj.value(forKey: "startdate") as? Date, formatter: formatter)
                    let end = formatDate(obj.value(forKey: "enddate") as? Date, formatter: formatter)
                    dateString = "Start: \(start) • End: \(end)"
                    descriptor = (obj.value(forKey: "medName") as? String) ?? "Unknown Medication"

                case "Accidental Exposure":
                    let exposureDate = obj.value(forKey: "date") as? Date
                    dateString = formatDate(exposureDate, formatter: formatter)
                    descriptor = (obj.value(forKey: "item") as? String) ?? "Unknown Substance"

                case "Symptom Score":
                    let d = obj.value(forKey: "date") as? Date
                    dateString = formatDate(d, formatter: formatter)
                    let sum = obj.value(forKey: "symptomSum") as? Int
                    descriptor = "Symptom Score: \(formatInt(sum))"

                case "Quality of Life":
                    let d = obj.value(forKey: "date") as? Date
                    dateString = formatDate(d, formatter: formatter)
                    let sum = obj.value(forKey: "qualitySum") as? Int
                    descriptor = "Quality Score: \(formatInt(sum))"

                default:
                    break
                }

                return (dateString, descriptor)
            }

            tableView.reloadData()
        } catch {
            print("Error fetching \(category) data: \(error)")
        }
    }

    // MARK: - UITableView DataSource & Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
        let entry = tableViewData[indexPath.row]

        // ✅ Clean text (no duplicate “Date: Date:”)
        cell.textLabel?.text = "Date: \(entry.date)\nInfo: \(entry.descriptor)"
        cell.textLabel?.numberOfLines = 0

        return cell
    }
}
