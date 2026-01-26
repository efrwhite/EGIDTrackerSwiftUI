import UIKit
import CoreData

class ResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!

    struct EndoscopyEntry {
        var sum: Int
        var date: Date
    }

    var endoscopySumScores: [EndoscopyEntry] = []
    
    // Add properties to store username and childname
    var user: String = "" // Replace with actual value or pass it in
    var childName: String = "" // Replace with actual value or pass it in

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchEndoscopySumScores()
        print("Endoscopy User: ", user, "Endoscopy Child: ", childName)
    }

    func setupView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ResultCell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return endoscopySumScores.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath)
        let entry = endoscopySumScores[indexPath.row]
        cell.textLabel?.text = "Sum: \(entry.sum) - Date: \(formatDate(entry.date))"
        return cell
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }

    func fetchEndoscopySumScores() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Endoscopy")
        fetchRequest.resultType = .dictionaryResultType

        // Filter by username and childname using NSPredicate
        let predicate = NSPredicate(format: "username == %@ AND childName == %@", user, childName)
        fetchRequest.predicate = predicate

        // Create expressions for sum and date
        let sumExpressionDesc = NSExpressionDescription()
        sumExpressionDesc.name = "sum"
        sumExpressionDesc.expression = NSExpression(forFunction: "sum:", arguments: [NSExpression(forKeyPath: "sum")])
        sumExpressionDesc.expressionResultType = .integer32AttributeType

        let dateExpression = NSExpressionDescription()
        dateExpression.name = "date"
        dateExpression.expression = NSExpression(forKeyPath: "date")
        dateExpression.expressionResultType = .dateAttributeType

        fetchRequest.propertiesToFetch = [sumExpressionDesc, dateExpression]
        fetchRequest.propertiesToGroupBy = ["date"]

        do {
            let results = try context.fetch(fetchRequest) as! [NSDictionary]
            endoscopySumScores.removeAll()  // Clear previous results
            
            for result in results {
                if let sum = result["sum"] as? Int, let date = result["date"] as? Date {
                    endoscopySumScores.append(EndoscopyEntry(sum: sum, date: date))
                    print("Fetched Endoscopy result with sum: \(sum) for date: \(formatDate(date))")
                }
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Failed to fetch Endoscopy sums: \(error)")
        }
    }
}

