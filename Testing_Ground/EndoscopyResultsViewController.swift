import UIKit
import DGCharts
import CoreData
import MessageUI
//testing 
class EndoscopyResultsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, MFMailComposeViewControllerDelegate  {

    var user: String = ""
    var childName: String = ""

    let categories = ["EOE", "Stomach", "Duodenum", "Colon"]
    var selectedCategory = "EOE"

    let chartView: LineChartView = {
        let chart = LineChartView()
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()
    
    let historyTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = .black
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 8
        return textView
    }()

    let categoryPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let startDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    let endDatePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // Add email button to navigation bar
               navigationItem.rightBarButtonItem = UIBarButtonItem(
                   title: "Email",
                   style: .plain,
                   target: self,
                   action: #selector(confirmEmailReport)
               )
        
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        startDatePicker.addTarget(self, action: #selector(dateRangeChanged), for: .valueChanged)
        endDatePicker.addTarget(self, action: #selector(dateRangeChanged), for: .valueChanged)
        // Apply Date Range Filter
        var startDate = startDatePicker.date
        var endDate = endDatePicker.date
        let calendar = Calendar.current
        // If start and end are the same day and user hasn't adjusted time range,
        // expand window back by 1 hour so entries for today can still appear.
        if calendar.isDate(startDate, inSameDayAs: endDate) {
            startDate = calendar.date(byAdding: .hour, value: -1, to: Date()) ?? startDate
        }
        
        fetchEndoscopyResults(startDate: startDate, endDate: endDate, category: selectedCategory)
    }

//    func setupUI() {
//        view.backgroundColor = .white
//        view.addSubview(chartView)
//        view.addSubview(historyTextView)
//        view.addSubview(categoryPicker)
//        view.addSubview(startDatePicker)
//        view.addSubview(endDatePicker)
//        
//        NSLayoutConstraint.activate([
//            categoryPicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
//            categoryPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            
//            startDatePicker.topAnchor.constraint(equalTo: categoryPicker.bottomAnchor, constant: 10),
//            startDatePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            
//            endDatePicker.topAnchor.constraint(equalTo: categoryPicker.bottomAnchor, constant: 10),
//            endDatePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            
//            chartView.topAnchor.constraint(equalTo: startDatePicker.bottomAnchor, constant: 20),
//            chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            chartView.heightAnchor.constraint(equalToConstant: 300),
//            
//            historyTextView.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 20),
//            historyTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            historyTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            historyTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
//        ])
//    }
    func setupUI() {
            view.backgroundColor = .white
            view.addSubview(chartView)
            view.addSubview(historyTextView)
            view.addSubview(categoryPicker)
            view.addSubview(startDatePicker)
            view.addSubview(endDatePicker)
            
            NSLayoutConstraint.activate([
                categoryPicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
                categoryPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                
                startDatePicker.topAnchor.constraint(equalTo: categoryPicker.bottomAnchor, constant: 10),
                startDatePicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                
                endDatePicker.topAnchor.constraint(equalTo: categoryPicker.bottomAnchor, constant: 10),
                endDatePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                
                chartView.topAnchor.constraint(equalTo: startDatePicker.bottomAnchor, constant: 20),
                chartView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                chartView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                chartView.heightAnchor.constraint(equalToConstant: 300),
                
                historyTextView.topAnchor.constraint(equalTo: chartView.bottomAnchor, constant: 20),
                historyTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                historyTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                historyTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
            ])
        }
    @objc func dateRangeChanged() {
        fetchEndoscopyResults(startDate: startDatePicker.date, endDate: endDatePicker.date, category: selectedCategory)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // Single column picker
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count // Number of categories available
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row] // Display category names
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = categories[row] // Update selected category
        fetchEndoscopyResults(startDate: startDatePicker.date, endDate: endDatePicker.date, category: selectedCategory)
    }

//    func fetchEndoscopyResults(startDate: Date, endDate: Date, category: String) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//        let context = appDelegate.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Endoscopy")
//        
//        let predicate = NSPredicate(
//            format: "user == %@ AND childName == %@ AND procedureDate >= %@ AND procedureDate <= %@",
//            user,
//            childName,
//            startDate as NSDate,
//            endDate as NSDate
//        )
//        fetchRequest.predicate = predicate
//        
//        do {
//            let results = try context.fetch(fetchRequest)
//            
//            if results.isEmpty {
//                historyTextView.text = "No data available for selected range."
//                chartView.data = nil
//                return
//            }
//            
//            var values1: [ChartDataEntry] = []
//            var values2: [ChartDataEntry] = []
//            var values3: [ChartDataEntry] = []
//            var dateEntries: [String] = []
//            var historyText = ""
//
//            for (index, result) in results.enumerated() {
//                guard let date = result.value(forKey: "procedureDate") as? Date else { continue }
//                let formatter = DateFormatter()
//                formatter.dateStyle = .short
//                let dateString = formatter.string(from: date)
//                dateEntries.append(dateString)
//
//                switch category {
//                case "EOE":
//                    values1.append(ChartDataEntry(x: Double(index), y: result.value(forKey: "upper") as? Double ?? 0))
//                    values2.append(ChartDataEntry(x: Double(index), y: result.value(forKey: "middle") as? Double ?? 0))
//                    values3.append(ChartDataEntry(x: Double(index), y: result.value(forKey: "lower") as? Double ?? 0))
//                case "Stomach":
//                    values1.append(ChartDataEntry(x: Double(index), y: result.value(forKey: "stomach") as? Double ?? 0))
//                case "Duodenum":
//                    values1.append(ChartDataEntry(x: Double(index), y: result.value(forKey: "duodenum") as? Double ?? 0))
//                case "Colon":
//                    values1.append(ChartDataEntry(x: Double(index), y: result.value(forKey: "rightColon") as? Double ?? 0))
//                    values2.append(ChartDataEntry(x: Double(index), y: result.value(forKey: "middleColon") as? Double ?? 0))
//                    values3.append(ChartDataEntry(x: Double(index), y: result.value(forKey: "leftColon") as? Double ?? 0))
//                default:
//                    break
//                }
//            }
//            
//            setChartData(upperData: values1, middleData: values2, lowerData: values3, dateEntries: dateEntries)
//        } catch {
//            print("Fetch error")
//        }
//        
//    }
    
    func fetchEndoscopyResults(startDate: Date, endDate: Date, category: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Endoscopy")
        // Apply Date Range Filter
//        var startDate = startDatePicker.date
//        var endDate = endDatePicker.date
//        let calendar = Calendar.current
//        // If start and end are the same day and user hasn't adjusted time range,
//        // expand window back by 1 hour so entries for today can still appear.
//        if calendar.isDate(startDate, inSameDayAs: endDate) {
//            startDate = calendar.date(byAdding: .hour, value: -1, to: Date()) ?? startDate
//        }
        
        let predicate = NSPredicate(
            format: "user == %@ AND childName == %@ AND procedureDate >= %@ AND procedureDate <= %@",
            user,
            childName,
            startDate as NSDate,
            endDate as NSDate
        )
        fetchRequest.predicate = predicate
        
        do {
            let results = try context.fetch(fetchRequest)
            
            if results.isEmpty {
                DispatchQueue.main.async {
                    self.historyTextView.text = "No data available for selected range."
                    self.chartView.data = nil
                }
                return
            }
            
            var values1: [ChartDataEntry] = []
            var values2: [ChartDataEntry] = []
            var values3: [ChartDataEntry] = []
            var dateEntries: [String] = []
            var historyText = ""

            for (index, result) in results.enumerated() {
                guard let date = result.value(forKey: "procedureDate") as? Date else { continue }
                let formatter = DateFormatter()
                formatter.dateStyle = .short
                let dateString = formatter.string(from: date)
                dateEntries.append(dateString)

                historyText += "Date: \(dateString)\n"

                switch category {
                case "EOE":
                    let upper = result.value(forKey: "upper") as? Double ?? 0
                    let middle = result.value(forKey: "middle") as? Double ?? 0
                    let lower = result.value(forKey: "lower") as? Double ?? 0
                    
                    values1.append(ChartDataEntry(x: Double(index), y: upper))
                    values2.append(ChartDataEntry(x: Double(index), y: middle))
                    values3.append(ChartDataEntry(x: Double(index), y: lower))
                    
                    historyText += "Upper: \(upper), Middle: \(middle), Lower: \(lower)\n"
                
                case "Stomach":
                    let stomach = result.value(forKey: "stomach") as? Double ?? 0
                    values1.append(ChartDataEntry(x: Double(index), y: stomach))
                    
                    historyText += "Stomach: \(stomach)\n"
                
                case "Duodenum":
                    let duodenum = result.value(forKey: "duodenum") as? Double ?? 0
                    values1.append(ChartDataEntry(x: Double(index), y: duodenum))
                    
                    historyText += "Duodenum: \(duodenum)\n"
                
                case "Colon":
                    let rightColon = result.value(forKey: "rightColon") as? Double ?? 0
                    let middleColon = result.value(forKey: "middleColon") as? Double ?? 0
                    let leftColon = result.value(forKey: "leftColon") as? Double ?? 0
                    
                    values1.append(ChartDataEntry(x: Double(index), y: rightColon))
                    values2.append(ChartDataEntry(x: Double(index), y: middleColon))
                    values3.append(ChartDataEntry(x: Double(index), y: leftColon))
                    
                    historyText += "Right Colon: \(rightColon), Middle Colon: \(middleColon), Left Colon: \(leftColon)\n"
                
                default:
                    break
                }

                historyText += "\n"
            }

            DispatchQueue.main.async {
                self.historyTextView.text = historyText
                self.setChartData(upperData: values1, middleData: values2, lowerData: values3, dateEntries: dateEntries)
            }

        } catch {
            print("Fetch error: \(error)")
        }
    }
    // EMAIL
    // Step 1: Ask User if They Want to Send a Report
        @objc func confirmEmailReport() {
            let startDateStr = formattedDate(startDatePicker.date)
            let endDateStr = formattedDate(endDatePicker.date)
            let alert = UIAlertController(
                title: "Send Report?",
                message: "Would you like to send a report for **\(selectedCategory)** from **\(startDateStr) to \(endDateStr)**?",
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
                self.sendEmail()
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            
            present(alert, animated: true)
        }

        // Step 2: Send Email with Report Data
    func sendEmail() {
        let startDateStr = formattedDate(startDatePicker.date)
        let endDateStr = formattedDate(endDatePicker.date)
        let subject = "Endoscopy Report - \(selectedCategory) (\(startDateStr) to \(endDateStr))"
        let body = historyTextView.text
        
        if MFMailComposeViewController.canSendMail() {
            // Use Apple Mail
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setSubject(subject)
            mail.setMessageBody(body ?? "nil", isHTML: false)

            // Attach the chart as an image
            if let chartImage = captureChartImage(), let imageData = chartImage.jpegData(compressionQuality: 0.8) {
                mail.addAttachmentData(imageData, mimeType: "image/jpeg", fileName: "EndoscopyChart.jpg")
            }

            present(mail, animated: true)
        } else {
            // Open Gmail in Safari
            let gmailBody = body?.addingPercentEncoding(
                withAllowedCharacters: .urlQueryAllowed
            ) ?? ""
            let gmailSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let gmailURL = "https://mail.google.com/mail/?view=cm&fs=1&to=&su=\(gmailSubject)&body=\(gmailBody)"

            if let url = URL(string: gmailURL) {
                UIApplication.shared.open(url)
            } else {
                print("Error: Could not open Gmail.")
            }
        }
    }

    /// Capture the current chart as an image
       func captureChartImage() -> UIImage? {
           UIGraphicsBeginImageContextWithOptions(chartView.bounds.size, false, UIScreen.main.scale)
           chartView.drawHierarchy(in: chartView.bounds, afterScreenUpdates: true)
           let image = UIGraphicsGetImageFromCurrentImageContext()
           UIGraphicsEndImageContext()
           return image
       }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
        }

    /// Format date for email report
        func formattedDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
// END EMAIL
    func setChartData(upperData: [ChartDataEntry], middleData: [ChartDataEntry], lowerData: [ChartDataEntry], dateEntries: [String]) {
        let upperDataSet = LineChartDataSet(entries: upperData, label: "Upper/Right")
        upperDataSet.colors = [.red]
        upperDataSet.circleColors = [.red]
        upperDataSet.circleRadius = 4
        upperDataSet.valueColors = [.red]
        upperDataSet.valueFont = .systemFont(ofSize: 10)
        upperDataSet.drawValuesEnabled = true

        let middleDataSet = LineChartDataSet(entries: middleData, label: "Middle")
        middleDataSet.colors = [.green]
        middleDataSet.circleColors = [.green]
        middleDataSet.circleRadius = 4
        middleDataSet.valueColors = [.green]
        middleDataSet.valueFont = .systemFont(ofSize: 10)
        middleDataSet.drawValuesEnabled = true

        let lowerDataSet = LineChartDataSet(entries: lowerData, label: "Lower/Left")
        lowerDataSet.colors = [.blue]
        lowerDataSet.circleColors = [.blue]
        lowerDataSet.circleRadius = 4
        lowerDataSet.valueColors = [.blue]
        lowerDataSet.valueFont = .systemFont(ofSize: 10)
        lowerDataSet.drawValuesEnabled = true

        let data = LineChartData(dataSets: [upperDataSet, middleDataSet, lowerDataSet])
        chartView.data = data

        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: dateEntries)
        chartView.xAxis.granularity = 1
        chartView.xAxis.labelRotationAngle = -45
        chartView.xAxis.drawGridLinesEnabled = false
    }
    
    

}

