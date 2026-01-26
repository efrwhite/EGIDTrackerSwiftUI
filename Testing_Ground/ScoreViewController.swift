////import UIKit
////import CoreData
////
////class ScoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
////    @IBOutlet weak var tableView: UITableView!
////
////    struct SurveyEntry {
////        var sum: Int
////        var date: Date
////    }
////
////    var qualitySumScores: [SurveyEntry] = []
////    var symptomSumScores: [SurveyEntry] = []
////
////    override func viewDidLoad() {
////        super.viewDidLoad()
////        setupView()
////        fetchSurveySumScores()
////    }
////
////    func setupView() {
////        tableView.dataSource = self
////        tableView.delegate = self
////        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ScoreCell")
////        tableView.allowsMultipleSelectionDuringEditing = true
////        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(toggleEditingMode))
////    }
////
////    @objc func toggleEditingMode() {
////        let isEditingMode = !tableView.isEditing
////        tableView.setEditing(isEditingMode, animated: true)
////        navigationItem.rightBarButtonItem?.title = isEditingMode ? "Done" : "Edit"
////    }
////
////    @objc func generateReportTapped() {
////        guard let selectedIndexPaths = tableView.indexPathsForSelectedRows else { return }
////
////        var selectedEntries: [SurveyEntry] = []
////        for indexPath in selectedIndexPaths {
////            let entry = indexPath.section == 0 ? qualitySumScores[indexPath.row] : symptomSumScores[indexPath.row]
////            selectedEntries.append(entry)
////        }
////
////        // Print the selected entries for debugging
////        print("Selected Entries for Report: \(selectedEntries)")
////
////        if let generateReportVC = storyboard?.instantiateViewController(withIdentifier: "GenerateReportViewController") as? GenerateReportViewController {
////            generateReportVC.selectedEntries = selectedEntries
////            navigationController?.pushViewController(generateReportVC, animated: true)
////        }
////
////        let generateReportVC = GenerateReportViewController()
////        generateReportVC.selectedEntries = selectedEntries
////        print("Navigating to GenerateReportViewController with \(selectedEntries.count) entries.")
////        navigationController?.pushViewController(generateReportVC, animated: true)
////    }
////
////    func numberOfSections(in tableView: UITableView) -> Int {
////        return 2
////    }
////
////    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        return section == 0 ? qualitySumScores.count : symptomSumScores.count
////    }
////
////    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
////        return section == 0 ? "Quality of Life Surveys" : "Symptom Surveys"
////    }
////
////    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath)
////        let entry = indexPath.section == 0 ? qualitySumScores[indexPath.row] : symptomSumScores[indexPath.row]
////        cell.textLabel?.text = "Sum: \(entry.sum) - Date: \(formatDate(entry.date))"
////        return cell
////    }
////
////    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
////        return true // Allow editing for all rows
////    }
////
////    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
////        if editingStyle == .delete {
////            // Determine whether we're deleting from qualitySumScores or symptomSumScores
////            let entityName = indexPath.section == 0 ? "Quality" : "Symptom"
////            let entry = indexPath.section == 0 ? qualitySumScores[indexPath.row] : symptomSumScores[indexPath.row]
////
////            deleteEntry(entityName: entityName, entry: entry) {
////                // Remove the entry from the local array
////                if indexPath.section == 0 {
////                    self.qualitySumScores.remove(at: indexPath.row)
////                } else {
////                    self.symptomSumScores.remove(at: indexPath.row)
////                }
////                // Delete the row from the table view
////                tableView.deleteRows(at: [indexPath], with: .fade)
////            }
////        }
////    }
////
////    private func formatDate(_ date: Date) -> String {
////        let formatter = DateFormatter()
////        formatter.dateStyle = .short
////        formatter.timeStyle = .none
////        return formatter.string(from: date)
////    }
////
////    func fetchSurveySumScores() {
////        fetchSumScoresFromEntity(entityName: "Quality", completion: { entries in
////            self.qualitySumScores = entries
////            DispatchQueue.main.async {
////                self.tableView.reloadData()
////            }
////        })
////
////        fetchSumScoresFromEntity(entityName: "Symptom", completion: { entries in
////            self.symptomSumScores = entries
////            DispatchQueue.main.async {
////                self.tableView.reloadData()
////            }
////        })
////    }
////
////    func fetchSumScoresFromEntity(entityName: String, completion: @escaping ([SurveyEntry]) -> Void) {
////        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
////        var entries: [SurveyEntry] = []
////
////        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
////        fetchRequest.resultType = .dictionaryResultType
////
////        let sumAttribute = entityName == "Quality" ? "qualitySum" : "symptomSum"
////
////        let sumExpressionDesc = NSExpressionDescription()
////        sumExpressionDesc.name = "sum"
////        sumExpressionDesc.expression = NSExpression(forFunction: "sum:", arguments: [NSExpression(forKeyPath: sumAttribute)])
////        sumExpressionDesc.expressionResultType = .integer64AttributeType
////
////        let dateExpression = NSExpressionDescription()
////        dateExpression.name = "date"
////        dateExpression.expression = NSExpression(forKeyPath: "date")
////        dateExpression.expressionResultType = .dateAttributeType
////
////        fetchRequest.propertiesToFetch = [sumExpressionDesc, dateExpression]
////        fetchRequest.propertiesToGroupBy = ["date"]
////
////        do {
////            let results = try context.fetch(fetchRequest) as! [NSDictionary]
////            for result in results {
////                if let sum = result["sum"] as? Int, let date = result["date"] as? Date {
////                    entries.append(SurveyEntry(sum: sum, date: date))
////                }
////            }
////            completion(entries)
////        } catch {
////            print("Error fetching \(entityName) sum scores: \(error)")
////        }
////    }
////
////    func deleteEntry(entityName: String, entry: SurveyEntry, completion: @escaping () -> Void) {
////        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
////        let context = appDelegate.persistentContainer.viewContext
////
////        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
////        fetchRequest.predicate = NSPredicate(format: "date == %@", entry.date as NSDate)
////
////        do {
////            let results = try context.fetch(fetchRequest)
////            for object in results {
////                guard let objectData = object as? NSManagedObject else { continue }
////                context.delete(objectData)
////            }
////
////            try context.save()
////            completion()
////        } catch let error as NSError {
////            print("Delete error: \(error), \(error.userInfo)")
////        }
////    }
////}
//
//
//import UIKit
//import CoreData
//import MessageUI
//
//class ScoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
//
//    @IBOutlet weak var tableView: UITableView!
//
//    struct SurveyEntry {
//        var sum: Int
//        var date: Date
//    }
//
//    var symptomSumScores: [SurveyEntry] = []
//    var selectedSurveyEntry: SurveyEntry?
//    var totalSymptomScore: Int64 = 0
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        setupView()
//        setupNavBarButtons()
//        tableView.reloadData()
//    }
//
//    func setupNavBarButtons() {
//        let emailButton = UIBarButtonItem(title: "Email Results", style: .plain, target: self, action: #selector(emailButtonTapped))
//        navigationItem.rightBarButtonItem = emailButton
//    }
//    
//    func setupView() {
//        tableView.dataSource = self
//        tableView.delegate = self
//        
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ScoreCell")
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return symptomSumScores.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath)
//        
//        let surveyEntry = symptomSumScores[indexPath.row]
//        let formatter = DateFormatter()
//        formatter.dateStyle = .short
//        
//        cell.textLabel?.text = "Date: \(formatter.string(from: surveyEntry.date)), Total Score: \(surveyEntry.sum)"
//        
//        return cell
//    }
//
//    func formattedDate(_ date: Date) -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .short
//        return dateFormatter.string(from: date)
//    }
//
//    @objc func emailButtonTapped() {
//        sendEmail()
//    }
//
//    func sendEmail() {
//        if MFMailComposeViewController.canSendMail() {
//            let mailComposeVC = MFMailComposeViewController()
//            mailComposeVC.mailComposeDelegate = self
//            mailComposeVC.setSubject("Symptom Survey Results")
//            mailComposeVC.setMessageBody(composeEmailBody(), isHTML: false)
//            present(mailComposeVC, animated: true, completion: nil)
//        } else {
//            let alert = UIAlertController(title: "Error", message: "Mail services are not available. Please set up an account in Settings.", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//            present(alert, animated: true, completion: nil)
//        }
//    }
//
//    func composeEmailBody() -> String {
//        var emailBody = "Here are the symptom survey results:\n\n"
//        for entry in symptomSumScores {
//            emailBody += "Date: \(formattedDate(entry.date)), Score: \(entry.sum)\n"
//        }
//        return emailBody
//    }
//
//    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        controller.dismiss(animated: true, completion: nil)
//    }
//}


import UIKit
import CoreData

class ScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!

    struct SurveyEntry {
        var sum: Int
        var date: Date
        var yesNoQuestions: [String]
    }
    var user = ""
    var childName = ""
    var viewdata = "symptom"

    var symptomSumScores: [SurveyEntry] = []
    var filteredEntries: [SurveyEntry] = []

    /// ✅ Start Date Picker
    let startDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    /// ✅ End Date Picker
    let endDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        print(user,childName, "IN Score view")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ScoreCell")
        
        setupTableHeaderView() // ✅ Adds Date Pickers above Table View
        fetchSurveyEntries()
    }

    /// ✅ Adds Date Pickers to Table Header
    func setupTableHeaderView() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 120))

        let instructionLabel = UILabel()
        instructionLabel.text = "Select Date Range:"
        instructionLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false

        headerView.addSubview(instructionLabel)
        headerView.addSubview(startDatePicker)
        headerView.addSubview(endDatePicker)

        NSLayoutConstraint.activate([
            instructionLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 5),
            instructionLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),

            startDatePicker.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 10),
            startDatePicker.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),

            endDatePicker.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: 10),
            endDatePicker.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16)
        ])

        tableView.tableHeaderView = headerView
        
        startDatePicker.addTarget(self, action: #selector(dateRangeChanged), for: .valueChanged)
        endDatePicker.addTarget(self, action: #selector(dateRangeChanged), for: .valueChanged)
    }

    /// ✅ Filters history based on selected date range
    @objc func dateRangeChanged() {
        fetchSurveyEntries()
    }

    /// ✅ Fetch Symptom Survey Entries from Core Data and Filter by Date Range
    func fetchSurveyEntries() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Symptom> = Symptom.fetchRequest()

        do {
            let results = try context.fetch(fetchRequest)
            
            symptomSumScores = results.map { survey in
                let yesNoList = survey.yesnoquestion as? [String] ?? []
                return SurveyEntry(sum: Int(survey.symptomSum), date: survey.date ?? Date(), yesNoQuestions: yesNoList)
            }

            // Apply Date Range Filter
            var startDate = startDatePicker.date
            var endDate = endDatePicker.date
            let calendar = Calendar.current

            // If start and end are the same day and user hasn't adjusted time range,
            // expand window back by 1 hour so entries for today can still appear.
            if calendar.isDate(startDate, inSameDayAs: endDate) {
                startDate = calendar.date(byAdding: .hour, value: -1, to: Date()) ?? startDate
            }
            filteredEntries = symptomSumScores.filter { $0.date >= startDate && $0.date <= endDate }

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Failed to fetch survey data: \(error)")
        }
    }

    /// ✅ IBAction for "Generate Report" button in Storyboard
    @IBAction func generateReportTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showSymptomReport", sender: self)
    }

    /// ✅ Passes selected date range and user details to the next screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSymptomReport",
           let destinationVC = segue.destination as? GenerateReportViewController {
            destinationVC.user = user
            destinationVC.childName = childName
            destinationVC.startDate = startDatePicker.date
            destinationVC.endDate = endDatePicker.date
            destinationVC.viewdata = viewdata
        }
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredEntries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath)
        let entry = filteredEntries[indexPath.row]

        // Convert yes/no question list to string
        let yesNoString = entry.yesNoQuestions.joined(separator: ", ")

        cell.textLabel?.text = "Date: \(formattedDate(entry.date))\nScore: \(entry.sum)\nYes/No: \(yesNoString)"
        cell.textLabel?.numberOfLines = 0 // Allows multi-line text

        return cell
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
