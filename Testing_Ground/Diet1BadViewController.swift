import UIKit

class Diet1BadViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let sectionTitle = "Foods Not Okay to Eat"
    var items = [
        "Baked goods",
        "Butter",
        "Buttermilk",
        "Casein",
        "Cheese",
        "Chocolate",
        "Condensed milk",
        "Cottage cheese",
        "Cream",
        "Cream cheese",
        "Curd",
        "Custard",
        "Evaporated milk",
        "Ghee",
        "Goat’s milk",
        "Gravy",
        "Half & half",
        "Ice cream",
        "Lactose",
        "Margarine",
        "Milk",
        "Milk powder",
        "Pastries",
        "Pudding",
        "Salad dressing",
        "Sheep’s milk",
        "Sour cream",
        "Whey",
        "Yogurt"
    ]
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // Set up automatic row height
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.numberOfLines = 0 // Allow unlimited lines
        cell.textLabel?.lineBreakMode = .byWordWrapping
        
        return cell
    }
    
    // Method to add a new food item
    func addFood(_ food: String) {
        items.append(food)
        tableView.reloadData()
    }
}

//import UIKit
//import CoreData
//
//class Diet1BadViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//    
//    var dietEntries: [String] = [] // Replace with your Diet model if needed
//    var childName = ""
//    var user = ""
//    let tableView = UITableView()
//    let placeholderLabel: UILabel = {
//        let label = UILabel()
//        label.text = "No Diet"
//        label.textAlignment = .center
//        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
//        label.textColor = .gray
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//
//        setupTableView()
//        setupPlaceholderLabel()
//        loadDietData()
//    }
//
//    func setupTableView() {
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DietCell")
//        view.addSubview(tableView)
//
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.topAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
//        ])
//    }
//
//    func setupPlaceholderLabel() {
//        view.addSubview(placeholderLabel)
//        NSLayoutConstraint.activate([
//            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//    }
//
//    func loadDietData() {
//        // Load dietEntries from Core Data or other source
//        // For now, it's just an empty array for the placeholder example
//        dietEntries = [] // Load your actual data here
//
//        placeholderLabel.isHidden = !dietEntries.isEmpty
//        tableView.reloadData()
//    }
//
//    // MARK: - UITableView DataSource Methods
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return dietEntries.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "DietCell", for: indexPath)
//        cell.textLabel?.text = dietEntries[indexPath.row]
//        return cell
//    }
//
//    // MARK: - UITableView Delegate (optional)
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        // Handle selection
//    }
//}

