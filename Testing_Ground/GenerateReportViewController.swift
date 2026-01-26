//
//import UIKit
//import CoreData
//import PDFKit
//import Charts
//import MessageUI
//
//class GenerateReportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return (viewdata == "quality") ? historyEntriesQuality.count : historyEntries.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
//        let formatter = DateFormatter()
//        formatter.dateStyle = .short
//
//        if viewdata == "quality" {
//            let entry = historyEntriesQuality[indexPath.row]
//            let dateString = formatter.string(from: entry.date)
//            cell.textLabel?.text = "Date: \(dateString) | Quality Score: \(entry.qualitySum)"
//        } else {
//            let entry = historyEntries[indexPath.row]
//            let dateString = formatter.string(from: entry.date)
//            cell.textLabel?.text = "Date: \(dateString) | Symptom Sum: \(entry.symptomSum)\nYes/No: \(entry.yesNoQuestions)"
//        }
//
//        cell.textLabel?.numberOfLines = 0  // Allow multi-line display
//        return cell
//    }
//
//
//    var user = ""
//    var childName = ""
//    var viewdata = ""  // Determines if we are handling "quality" or "symptom" data
//    var endDate: Date? = nil
//    var startDate: Date? = nil
//
//    var historyEntries: [(date: Date, symptomSum: Int, yesNoQuestions: String)] = []
//    var historyEntriesQuality: [(date: Date, qualitySum: Int)] = []
//
//    let chartView: LineChartView = {
//        let chart = LineChartView()
//        chart.translatesAutoresizingMaskIntoConstraints = false
//        return chart
//    }()
//
//    let historyTableView: UITableView = {
//        let tableView = UITableView()
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HistoryCell")
//        return tableView
//    }()
//    
//    let sendEmailButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Send Report via Email", for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.addTarget(self, action: #selector(sendEmail), for: .touchUpInside)
//        return button
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.backgroundColor = .white
//        setupUI()
//
//        if viewdata == "symptom" {
//            fetchSymptomData()
//        } else if viewdata == "quality" {
//            fetchQualityData()
//        }
//    }
//
//    func setupUI() {
//        view.addSubview(chartView)
//        view.addSubview(historyTableView)
//        view.addSubview(sendEmailButton)
//
//        historyTableView.delegate = self
//        historyTableView.dataSource = self
//
//        NSLayoutConstraint.activate([
//            chartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
//            chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            chartView.heightAnchor.constraint(equalToConstant: 300),
//
//            historyTableView.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 20),
//            historyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            historyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            historyTableView.bottomAnchor.constraint(equalTo: sendEmailButton.topAnchor, constant: -20),
//
//            sendEmailButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
//            sendEmailButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
//        ])
//    }
//
//    func fetchSymptomData() {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        let context = appDelegate.persistentContainer.viewContext
//        let fetchRequest: NSFetchRequest<Symptom> = Symptom.fetchRequest()
//        
//        let datePredicate = NSPredicate(format: "date >= %@ AND date <= %@", startDate! as NSDate, endDate! as NSDate)
//        let userPredicate = NSPredicate(format: "user == %@", user)
//        let childPredicate = NSPredicate(format: "childName == %@", childName)
//        
//        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate, userPredicate, childPredicate])
//        
//        do {
//            let results = try context.fetch(fetchRequest)
//            
//            var chartEntries: [ChartDataEntry] = []
//            historyEntries = []
//            let formatter = DateFormatter()
//            formatter.dateStyle = .short
//
//            for (index, entry) in results.enumerated() {
//                let symptomSum = Int(entry.symptomSum)
//                let date = entry.date ?? Date()
//                let yesNoQuestions = entry.yesnoquestion ?? "None"
//
//                chartEntries.append(ChartDataEntry(x: Double(index), y: Double(symptomSum)))
//                historyEntries.append((date, symptomSum, yesNoQuestions))
//            }
//
//            DispatchQueue.main.async {
//                self.updateGraph(with: chartEntries, label: "Symptom Scores")
//                self.historyTableView.reloadData()
//            }
//
//        } catch {
//            print("Failed to fetch symptom data: \(error)")
//        }
//    }
//
//    func fetchQualityData() {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        let context = appDelegate.persistentContainer.viewContext
//        let fetchRequest: NSFetchRequest<Quality> = Quality.fetchRequest()
//        
//        let datePredicate = NSPredicate(format: "date >= %@ AND date <= %@", startDate! as NSDate, endDate! as NSDate)
//        let userPredicate = NSPredicate(format: "user == %@", user)
//        let childPredicate = NSPredicate(format: "childName == %@", childName)
//        
//        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate, userPredicate, childPredicate])
//        
//        do {
//            let results = try context.fetch(fetchRequest)
//            
//            var chartEntries: [ChartDataEntry] = []
//            historyEntriesQuality = []
//            let formatter = DateFormatter()
//            formatter.dateStyle = .short
//
//            for (index, entry) in results.enumerated() {
//                let qualitySum = Int(entry.qualitySum)
//                let date = entry.date ?? Date()
//
//                chartEntries.append(ChartDataEntry(x: Double(index), y: Double(qualitySum)))
//                historyEntriesQuality.append((date, qualitySum))
//            }
//
//            DispatchQueue.main.async {
//                self.updateGraph(with: chartEntries, label: "Quality of Life Score")
//                self.historyTableView.reloadData()
//            }
//
//        } catch {
//            print("Failed to fetch quality data: \(error)")
//        }
//    }
//
//    func updateGraph(with entries: [ChartDataEntry], label: String) {
//        let dataSet = LineChartDataSet(entries: entries, label: label)
//        dataSet.colors = [.blue]
//        dataSet.circleColors = [.blue]
//        dataSet.circleRadius = 4
//        dataSet.valueColors = [.blue]
//
//        let data = LineChartData(dataSet: dataSet)
//        chartView.data = data
//
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MMM dd"
//
//        let dateEntries = (viewdata == "quality")
//            ? historyEntriesQuality.map { formatter.string(from: $0.date) }
//            : historyEntries.map { formatter.string(from: $0.date) }
//
//        let xAxis = chartView.xAxis
//        xAxis.valueFormatter = IndexAxisValueFormatter(values: dateEntries)
//        xAxis.granularity = 1
//        xAxis.labelRotationAngle = -30
//        xAxis.labelPosition = .bottom
//        xAxis.labelFont = UIFont.systemFont(ofSize: 10)
//        xAxis.wordWrapEnabled = true
//        xAxis.avoidFirstLastClippingEnabled = true
//        xAxis.granularityEnabled = true
//
//        chartView.legend.enabled = true
//        chartView.animate(xAxisDuration: 0.5, yAxisDuration: 0.5)
//    }
//    func getDocumentsDirectory() -> URL {
//        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//    }
//
//    @objc func sendEmail() {
//        guard MFMailComposeViewController.canSendMail() else {
//            print("Mail services are not available")
//            return
//        }
//
//        let mail = MFMailComposeViewController()
//        mail.mailComposeDelegate = self
//        mail.setSubject("\(viewdata.capitalized) Report for \(childName)")
//        mail.setMessageBody("Please find attached the report.", isHTML: false)
//
//        let pdfURL = getDocumentsDirectory().appendingPathComponent("\(viewdata.capitalized)Report.pdf")
//        if let pdfData = try? Data(contentsOf: pdfURL) {
//            mail.addAttachmentData(pdfData, mimeType: "application/pdf", fileName: "\(viewdata.capitalized)Report.pdf")
//        }
//
//        present(mail, animated: true)
//    }
//
//    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        controller.dismiss(animated: true)
//    }
//}



import UIKit
import CoreData
import PDFKit
import DGCharts
import MessageUI

class GenerateReportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (viewdata == "quality") ? historyEntriesQuality.count : historyEntries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath)
        let formatter = DateFormatter()
        formatter.dateStyle = .short

        if viewdata == "quality" {
            let entry = historyEntriesQuality[indexPath.row]
            let dateString = formatter.string(from: entry.date)
            cell.textLabel?.text = "Date: \(dateString) | Quality Score: \(entry.qualitySum)"
        } else {
            let entry = historyEntries[indexPath.row]
            let dateString = formatter.string(from: entry.date)
            cell.textLabel?.text = "Date: \(dateString) | Symptom Sum: \(entry.symptomSum)\nYes/No: \(entry.yesNoQuestions)"
        }

        cell.textLabel?.numberOfLines = 0  // Allow multi-line display
        return cell
    }


    var user = ""
    var childName = ""
    var viewdata = ""  // Determines if we are handling "quality" or "symptom" data
    var endDate: Date? = nil
    var startDate: Date? = nil

    var historyEntries: [(date: Date, symptomSum: Int, yesNoQuestions: String)] = []
    var historyEntriesQuality: [(date: Date, qualitySum: Int)] = []

    let chartView: LineChartView = {
        let chart = LineChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()

    let historyTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "HistoryCell")
        return tableView
    }()
    
    let sendEmailButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send Report via Email", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(sendEmail), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupUI()

        // ✅ Normalize date range so "same day" includes everything on that day
        let calendar = Calendar.current

        if let start = startDate {
            startDate = calendar.startOfDay(for: start)
        } else {
            // If startDate wasn't set, default to yesterday
            startDate = calendar.date(byAdding: .day, value: -1, to: calendar.startOfDay(for: Date()))
        }

        if let end = endDate {
            // end = end of the selected day (23:59:59)
            let startOfEndDay = calendar.startOfDay(for: end)
            endDate = calendar.date(byAdding: DateComponents(day: 1, second: -1), to: startOfEndDay)
        } else {
            // If endDate wasn't set, default to end of today
            let startOfToday = calendar.startOfDay(for: Date())
            endDate = calendar.date(byAdding: DateComponents(day: 1, second: -1), to: startOfToday)
        }

        if viewdata == "symptom" {
            fetchSymptomData()
        } else if viewdata == "quality" {
            fetchQualityData()
        }
    }


    func setupUI() {
        view.addSubview(chartView)
        view.addSubview(historyTableView)
        view.addSubview(sendEmailButton)

        historyTableView.delegate = self
        historyTableView.dataSource = self

        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            chartView.heightAnchor.constraint(equalToConstant: 300),

            historyTableView.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 20),
            historyTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            historyTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            historyTableView.bottomAnchor.constraint(equalTo: sendEmailButton.topAnchor, constant: -20),

            sendEmailButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            sendEmailButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    func fetchSymptomData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Symptom> = Symptom.fetchRequest()
        
        let datePredicate = NSPredicate(format: "date >= %@ AND date <= %@", startDate! as NSDate, endDate! as NSDate)
        let userPredicate = NSPredicate(format: "user == %@", user)
        let childPredicate = NSPredicate(format: "childName == %@", childName)
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate, userPredicate, childPredicate])
        
        do {
            let results = try context.fetch(fetchRequest)
            
            var chartEntries: [ChartDataEntry] = []
            historyEntries = []
            let formatter = DateFormatter()
            formatter.dateStyle = .short

            for (index, entry) in results.enumerated() {
                let symptomSum = Int(entry.symptomSum)
                let date = entry.date ?? Date()
                let yesNoQuestions = entry.yesnoquestion ?? "None"

                chartEntries.append(ChartDataEntry(x: Double(index), y: Double(symptomSum)))
                historyEntries.append((date, symptomSum, yesNoQuestions))
            }

            DispatchQueue.main.async {
                self.updateGraph(with: chartEntries, label: "Symptom Scores")
                self.historyTableView.reloadData()
            }

        } catch {
            print("Failed to fetch symptom data: \(error)")
        }
    }

    func fetchQualityData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Quality> = Quality.fetchRequest()
        
        let datePredicate = NSPredicate(format: "date >= %@ AND date <= %@", startDate! as NSDate, endDate! as NSDate)
        let userPredicate = NSPredicate(format: "user == %@", user)
        let childPredicate = NSPredicate(format: "childName == %@", childName)
        
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate, userPredicate, childPredicate])
        
        do {
            let results = try context.fetch(fetchRequest)
            
            var chartEntries: [ChartDataEntry] = []
            historyEntriesQuality = []
            let formatter = DateFormatter()
            formatter.dateStyle = .short

            for (index, entry) in results.enumerated() {
                let qualitySum = Int(entry.qualitySum)
                let date = entry.date ?? Date()

                chartEntries.append(ChartDataEntry(x: Double(index), y: Double(qualitySum)))
                historyEntriesQuality.append((date, qualitySum))
            }

            DispatchQueue.main.async {
                self.updateGraph(with: chartEntries, label: "Quality of Life Score")
                self.historyTableView.reloadData()
            }

        } catch {
            print("Failed to fetch quality data: \(error)")
        }
    }

    func updateGraph(with entries: [ChartDataEntry], label: String) {
        let dataSet = LineChartDataSet(entries: entries, label: label)
        dataSet.colors = [.blue]
        dataSet.circleColors = [.blue]
        dataSet.circleRadius = 4
        dataSet.valueColors = [.blue]

        let data = LineChartData(dataSet: dataSet)
        chartView.data = data

        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd"

        let dateEntries = (viewdata == "quality")
            ? historyEntriesQuality.map { formatter.string(from: $0.date) }
            : historyEntries.map { formatter.string(from: $0.date) }

        let xAxis = chartView.xAxis
        xAxis.valueFormatter = IndexAxisValueFormatter(values: dateEntries)
        xAxis.granularity = 1
        xAxis.labelRotationAngle = -30
        xAxis.labelPosition = .bottom
        xAxis.labelFont = UIFont.systemFont(ofSize: 10)
        xAxis.wordWrapEnabled = true
        xAxis.avoidFirstLastClippingEnabled = true
        xAxis.granularityEnabled = true

        chartView.legend.enabled = true
        chartView.animate(xAxisDuration: 0.5, yAxisDuration: 0.5)
    }
    func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    @objc func sendEmail() {
        guard MFMailComposeViewController.canSendMail() else {
            print("Mail services are not available")
            return
        }

        let pdfURL = getDocumentsDirectory().appendingPathComponent("\(viewdata.capitalized)Report.pdf")

        // Ensure the PDF is created
        generatePDF(at: pdfURL)

        guard let pdfData = try? Data(contentsOf: pdfURL) else {
            print("❌ ERROR: Could not load PDF data from \(pdfURL.path)")
            return
        }

        print("✅ PDF loaded successfully for attachment.")

        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setSubject("\(viewdata.capitalized) Report for \(childName)")
        mail.setMessageBody("Please find attached the report.", isHTML: false)
        mail.addAttachmentData(pdfData, mimeType: "application/pdf", fileName: "\(viewdata.capitalized)Report.pdf")

        print("📩 Presenting mail compose view")
        present(mail, animated: true)
    }
    func captureChartImage() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: chartView.bounds.size)
        return renderer.image { context in
            chartView.layer.render(in: context.cgContext)
        }
    }

    func generatePDF(at url: URL) {
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 612, height: 792)) // Standard PDF size
        
        do {
            try pdfRenderer.writePDF(to: url, withActions: { context in
                context.beginPage()
                
                let title = "\(viewdata.capitalized) Report for \(childName)"
                let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
                title.draw(at: CGPoint(x: 20, y: 20), withAttributes: attributes)
                
                var yOffset: CGFloat = 50
                let formatter = DateFormatter()
                formatter.dateStyle = .medium

                // ✅ 1. Capture the chart as an image
                if let chartImage = captureChartImage() {
                    let imageRect = CGRect(x: 20, y: yOffset, width: 572, height: 250) // Adjust size
                    chartImage.draw(in: imageRect)
                    yOffset += 270 // Move text below the chart
                }

                // ✅ 2. Draw history data below the chart
                if viewdata == "quality" {
                    for entry in historyEntriesQuality {
                        let dateStr = formatter.string(from: entry.date)
                        let line = "Date: \(dateStr) | Quality Score: \(entry.qualitySum)"
                        line.draw(at: CGPoint(x: 20, y: yOffset), withAttributes: nil)
                        yOffset += 20
                    }
                } else {
                    for entry in historyEntries {
                        let dateStr = formatter.string(from: entry.date)
                        let line = "Date: \(dateStr) | Symptom Score: \(entry.symptomSum) | Yes/No: \(entry.yesNoQuestions)"
                        line.draw(at: CGPoint(x: 20, y: yOffset), withAttributes: nil)
                        yOffset += 20
                    }
                }
            })
            
            print("✅ PDF successfully generated at: \(url.path)")
        } catch {
            print("❌ Failed to generate PDF: \(error)")
        }
    }




    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
