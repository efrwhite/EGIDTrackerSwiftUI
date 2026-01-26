//
//import UIKit
//import CoreData
//import MessageUI
//
//extension UIView {
//    func asImage() -> UIImage {
//        let renderer = UIGraphicsImageRenderer(size: bounds.size)
//        return renderer.image { context in
//            layer.render(in: context.cgContext)
//        }
//    }
//}
//
//class QualityResultViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
//
//    @IBOutlet weak var tableView: UITableView!
//    var user = ""
//    var childName = ""
//    var qualityEntries: [QualityEntry] = []
//
////    override func viewDidLoad() {
////        super.viewDidLoad()
////        tableView.dataSource = self
////        tableView.delegate = self
////        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "QualityResultCell")
////        
////        // Fetch quality entries from Core Data
////        fetchQualityEntries()
////        
////        tableView.reloadData()
////        setupNavBarButtons()
////    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Set up the table view's dataSource and delegate
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "QualityResultCell")
//        
//        // Fetch the quality entries from Core Data
//        fetchQualityEntries()
//        
//        // Reload the table view after fetching data
//        DispatchQueue.main.async {
//            self.tableView.reloadData()
//        }
//        
//        // Set up navigation bar buttons
//        setupNavBarButtons()
//    }
//
//    func setupNavBarButtons() {
//        // Create the email button
//        let emailButton = UIBarButtonItem(title: "Email Results", style: .plain, target: self, action: #selector(emailButtonTapped))
//
//        // Create flexible space to adjust positioning
//        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
//
//        // Add the email button next to the flexible space, so it's not fully to the right
//        navigationItem.rightBarButtonItems = [flexibleSpace, emailButton]
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
//            mailComposeVC.setSubject("Quality of Life Survey Results")
//            mailComposeVC.setMessageBody(composeEmailBody(), isHTML: false)
//            present(mailComposeVC, animated: true, completion: nil)
//        } else {
//            if let emailURL = createEmailUrl(to: "provider@example.com", subject: "Quality of Life Survey Results", body: composeEmailBody()) {
//                UIApplication.shared.open(emailURL)
//            } else {
//                let alert = UIAlertController(title: "Error", message: "Mail services are not available. Please set up a mail account in Settings.", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                present(alert, animated: true, completion: nil)
//            }
//        }
//    }
//
//    func createEmailUrl(to: String, subject: String, body: String) -> URL? {
//        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//        let gmailURL = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
//        let outlookURL = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
//        let defaultMailURL = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
//
//        if let gmailURL = gmailURL, UIApplication.shared.canOpenURL(gmailURL) {
//            return gmailURL
//        } else if let outlookURL = outlookURL, UIApplication.shared.canOpenURL(outlookURL) {
//            return outlookURL
//        } else {
//            return defaultMailURL
//        }
//    }
//
//    func composeEmailBody() -> String {
//        var emailBody = "Here are the Quality of Life survey results:\n\n"
//        for entry in qualityEntries {
//            emailBody += "Sum: \(entry.sum), Date: \(entry.date)\n"
//        }
//        return emailBody
//    }
//
//    // MARK: - MFMailComposeViewControllerDelegate
//    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        controller.dismiss(animated: true, completion: nil)
//    }
//
//    // MARK: - UITableViewDataSource
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return qualityEntries.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "QualityResultCell", for: indexPath)
//        let entry = qualityEntries[indexPath.row]
//        cell.textLabel?.text = "Sum: \(entry.sum) - Date: \(entry.date)"
//        return cell
//    }
//
//    @IBAction func goToGenerateReport(_ sender: Any) {
//        let generateReportVC = GenerateReportViewController()
//
//        // Pass the table view reference to GenerateReportViewController
//        generateReportVC.tableViewsToCapture.append(self.tableView)
//
//        // Navigate to GenerateReportViewController
//        navigationController?.pushViewController(generateReportVC, animated: true)
//    }
//
//    // MARK: - Core Data Fetching
//    func fetchQualityEntries() {
//        // Get the app delegate and the managed context
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//
//        // Create a fetch request for the 'Quality' entity
//        let fetchRequest: NSFetchRequest<Quality> = Quality.fetchRequest()
//        
//        // Create a predicate to filter by user and childName
//        let predicate = NSPredicate(format: "user == %@ AND childName == %@", user, childName)
//        
//        // Assign the predicate to the fetch request
//        fetchRequest.predicate = predicate
//
//        do {
//            // Execute the fetch request and get the results
//            let results = try context.fetch(fetchRequest)
//            
//            // Convert the fetched Core Data objects to QualityEntry objects
//            qualityEntries = results.map { QualityEntry(sum: Int($0.qualitySum), date: $0.date ?? Date()) }
//            
//            // Reload the table view to display the data
//            tableView.reloadData()
//        } catch {
//            print("Failed to fetch data: \(error)")
//        }
//    }
//
//}
import UIKit
import CoreData

class QualityResultViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var user = ""
    var childName = ""
    var viewdata = "quality"
    var qualityEntries: [QualityEntry] = []
    var filteredEntries: [QualityEntry] = []

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
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "QualityResultCell")
        
        setupTableHeaderView() // ✅ Adds Date Pickers above Table View
        fetchQualityEntries()
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
        fetchQualityEntries()
    }

    /// ✅ Fetch Quality Entries from Core Data and Filter by Date Range
    func fetchQualityEntries() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Quality> = Quality.fetchRequest()
        
        let predicate = NSPredicate(format: "user == %@ AND childName == %@", user, childName)
        fetchRequest.predicate = predicate

        do {
            let results = try context.fetch(fetchRequest)
            qualityEntries = results.map { QualityEntry(sum: Int($0.qualitySum), date: $0.date ?? Date()) }

            // Apply Date Range Filter
            var startDate = startDatePicker.date
            var endDate = endDatePicker.date
            let calendar = Calendar.current
            // If start and end are the same day and user hasn't adjusted time range,
            // expand window back by 1 hour so entries for today can still appear.
            if calendar.isDate(startDate, inSameDayAs: endDate) {
                startDate = calendar.date(byAdding: .hour, value: -1, to: Date()) ?? startDate
            }
            filteredEntries = qualityEntries.filter { $0.date >= startDate && $0.date <= endDate }

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Failed to fetch data: \(error)")
        }
    }

    /// ✅ IBAction for "Generate Report" button in Storyboard
    @IBAction func generateReportTapped(_ sender: UIButton) {
        if presentedViewController == nil { // ✅ Ensures only one segue at a time
            performSegue(withIdentifier: "showQualityGraph", sender: self)
        }
    }


    /// ✅ Passes selected date range, user, and childName to the next screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showQualityGraph",
              let destinationVC = segue.destination as? GenerateReportViewController else {
            return
        }

        print("✅ Preparing for GenerateReportViewController segue") // Debugging

        destinationVC.user = user
        destinationVC.childName = childName
        destinationVC.startDate = startDatePicker.date
        destinationVC.endDate = endDatePicker.date
        destinationVC.viewdata = viewdata
    }


    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredEntries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QualityResultCell", for: indexPath)
        let entry = filteredEntries[indexPath.row]
        cell.textLabel?.text = "Date: \(formattedDate(entry.date)) - Score: \(entry.sum)"
        return cell
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
