//import UIKit
//
//class Diet1TestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//    
//    var user: String?
//    var childName: String?
//    
//    // Declare the table view
//    let tableView = UITableView()
//    
//    // Foods data source
//    var foods = ["Baked goods",
//                 "Butter",
//                 "Buttermilk",
//                 "Casein",
//                 "Cheese",
//                 "Chocolate",
//                 "Condensed milk",
//                 "Cottage cheese",
//                 "Cream",
//                 "Cream cheese",
//                 "Curd",
//                 "Custard",
//                 "Evaporated milk",
//                 "Ghee",
//                 "Goat’s milk",
//                 "Gravy",
//                 "Half & half",
//                 "Ice cream",
//                 "Lactose",
//                 "Margarine",
//                 "Milk",
//                 "Milk powder",
//                 "Pastries",
//                 "Pudding",
//                 "Salad dressing",
//                 "Sheep’s milk",
//                 "Sour cream",
//                 "Whey",
//                 "Yogurt"]
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Set up navigation bar
//        navigationItem.title = "Diet 1"
//        //navigationController?.navigationBar.prefersLargeTitles = true
//        
//        // Add plus button to navigation bar
//        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFood))
//        navigationItem.rightBarButtonItem = addButton
//        
//        // Create and configure scroll view
//        let scrollView = UIScrollView()
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(scrollView)
//        
//        NSLayoutConstraint.activate([
//            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
//        ])
//        
//        // Create and configure the 'Foods Not Okay to Eat' label
//        let foodsNotOkayLabel = UILabel()
//        foodsNotOkayLabel.text = "Foods Not Okay to Eat"
//        foodsNotOkayLabel.font = UIFont(name: "Times New Roman", size: 17)
//        foodsNotOkayLabel.textColor = UIColor(red: 57/255, green: 67/255, blue: 144/255, alpha: 1.0)
//        foodsNotOkayLabel.textAlignment = .center
//        foodsNotOkayLabel.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.addSubview(foodsNotOkayLabel)
//        
//        NSLayoutConstraint.activate([
//            foodsNotOkayLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
//            foodsNotOkayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            foodsNotOkayLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
//        ])
//        
//        // Create and configure the 'Diet 1: Dairy Elimination Diet' label
//        let dietLabel = UILabel()
//        dietLabel.text = "Diet 1: Dairy Elimination Diet"
//        dietLabel.font = UIFont(name: "Times New Roman", size: 17)
//        dietLabel.textColor = UIColor(red: 57/255, green: 67/255, blue: 144/255, alpha: 1.0)
//        dietLabel.textAlignment = .center
//        dietLabel.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.addSubview(dietLabel)
//        
//        NSLayoutConstraint.activate([
//            dietLabel.topAnchor.constraint(equalTo: foodsNotOkayLabel.bottomAnchor, constant: 10),
//            dietLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            dietLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
//        ])
//        
//        // Configure the table view
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.addSubview(tableView)
//        
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: dietLabel.bottomAnchor, constant: 20),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
//            tableView.heightAnchor.constraint(equalToConstant: 550) // Adjust the height based on content
//        ])
//        
//        // Create and configure the 'Allergies' button
//        let allergiesButton = UIButton(type: .system)
//        allergiesButton.setTitle("Allergies", for: .normal)
//        allergiesButton.backgroundColor = UIColor(red: 57/255, green: 67/255, blue: 144/255, alpha: 1.0)
//        allergiesButton.setTitleColor(.white, for: .normal)
//        allergiesButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
//        allergiesButton.layer.cornerRadius = 10
//        allergiesButton.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(allergiesButton)
//        
//        NSLayoutConstraint.activate([
//            allergiesButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
//            allergiesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            allergiesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            allergiesButton.heightAnchor.constraint(equalToConstant: 50)
//        ])
//        
//        allergiesButton.addTarget(self, action: #selector(allergiesButtonTapped), for: .touchUpInside)
//    }
//    
//    @objc func allergiesButtonTapped() {
// 
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        
//        // Instantiate the AllergiesViewController (AddAllergenViewController)
//        if let allergiesVC = storyboard.instantiateViewController(withIdentifier: "AddAllergenViewController") as? AddAllergenViewController {
//            
//            // Optionally pass any data if needed
//            allergiesVC.user = user ?? ""
//            allergiesVC.childName = childName ?? ""
//            
//            // Navigate to the AllergiesViewController
//            navigationController?.pushViewController(allergiesVC, animated: true)
//        }
//    }
//
//    
//    
//    
//    // Add Food menu
//    @objc func addFood() {
//        // Create alert controller with text field for adding food
//        let alert = UIAlertController(title: "Add Food to List", message: nil, preferredStyle: .alert)
//        
//        alert.addTextField { (textField) in
//            textField.placeholder = "Enter food"
//        }
//        
//        // Define the action for adding food
//        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
//            if let foodName = alert.textFields?.first?.text, !foodName.isEmpty {
//                self?.foods.append(foodName) // Add food to the data source
//                self?.tableView.reloadData()  // Reload table view to display new food
//            }
//        }
//        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        
//        // Add actions to alert controller
//        alert.addAction(addAction)
//        alert.addAction(cancelAction)
//        
//        // Present the alert controller
//        present(alert, animated: true, completion: nil)
//    }
//    
//    // Table View Data Source methods
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return foods.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
//        cell.textLabel?.text = foods[indexPath.row]
//        return cell
//    }
//}


import UIKit

class Diet1TestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var user: String?
    var childName: String?

    // MARK: - Theme
    private let appPurple = UIColor(red: 0.54, green: 0.38, blue: 0.69, alpha: 1.0) // your purple vibe
    private let pageBG = UIColor(red: 0.97, green: 0.96, blue: 0.95, alpha: 1.0)    // warm off-white like your screens

    // MARK: - UI
    private let headerStack = UIStackView()
    private let foodsNotOkayLabel = UILabel()
    private let dietLabel = UILabel()

    // Table view
    let tableView = UITableView(frame: .zero, style: .insetGrouped)

    // Bottom button
    private let allergiesButton = UIButton(type: .system)

    // Foods data source
    var foods = [
        "Baked goods","Butter","Buttermilk","Casein","Cheese","Chocolate","Condensed milk",
        "Cottage cheese","Cream","Cream cheese","Curd","Custard","Evaporated milk","Ghee",
        "Goat’s milk","Gravy","Half & half","Ice cream","Lactose","Margarine","Milk",
        "Milk powder","Pastries","Pudding","Salad dressing","Sheep’s milk","Sour cream",
        "Whey","Yogurt"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = pageBG
        configureNavBar()
        buildHeader()
        configureTable()
        configureAllergiesButton()
        layoutUI()
    }

    // MARK: - Nav
    private func configureNavBar() {
        navigationItem.title = "Diet 1"

        // plus button
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFood))
        navigationItem.rightBarButtonItem = addButton

        // purple accents
        navigationController?.navigationBar.tintColor = appPurple
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: appPurple,
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold)
        ]
    }

    // MARK: - Header
    private func buildHeader() {
        headerStack.axis = .vertical
        headerStack.alignment = .center
        headerStack.spacing = 6
        headerStack.translatesAutoresizingMaskIntoConstraints = false

        foodsNotOkayLabel.text = "Foods Not Okay to Eat"
        foodsNotOkayLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        foodsNotOkayLabel.textColor = appPurple
        foodsNotOkayLabel.textAlignment = .center
        foodsNotOkayLabel.numberOfLines = 0

        dietLabel.text = "Diet 1: Dairy Elimination Diet"
        dietLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        dietLabel.textColor = appPurple.withAlphaComponent(0.85)
        dietLabel.textAlignment = .center
        dietLabel.numberOfLines = 0

        headerStack.addArrangedSubview(foodsNotOkayLabel)
        headerStack.addArrangedSubview(dietLabel)
    }

    // MARK: - Table
    private func configureTable() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self

        // nicer look
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.black.withAlphaComponent(0.08)
        tableView.showsVerticalScrollIndicator = false

        // cell registration
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    // MARK: - Allergies button
    private func configureAllergiesButton() {
        allergiesButton.translatesAutoresizingMaskIntoConstraints = false
        allergiesButton.setTitle("Allergies", for: .normal)
        allergiesButton.setTitleColor(.white, for: .normal)
        allergiesButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        allergiesButton.backgroundColor = appPurple
        allergiesButton.layer.cornerRadius = 18
        allergiesButton.layer.masksToBounds = true
        allergiesButton.addTarget(self, action: #selector(allergiesButtonTapped), for: .touchUpInside)
    }

    // MARK: - Layout
    private func layoutUI() {
        view.addSubview(headerStack)
        view.addSubview(tableView)
        view.addSubview(allergiesButton)

        NSLayoutConstraint.activate([
            headerStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 14),
            headerStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headerStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            allergiesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            allergiesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            allergiesButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -14),
            allergiesButton.heightAnchor.constraint(equalToConstant: 56),

            tableView.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 10),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: allergiesButton.topAnchor, constant: -10)
        ])
    }

    // MARK: - Allergies Nav
    @objc private func allergiesButtonTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let allergiesVC = storyboard.instantiateViewController(withIdentifier: "AddAllergenViewController") as? AddAllergenViewController {
            allergiesVC.user = user ?? ""
            allergiesVC.childName = childName ?? ""
            navigationController?.pushViewController(allergiesVC, animated: true)
        }
    }

    // MARK: - Add Food
    @objc private func addFood() {
        let alert = UIAlertController(title: "Add Food to List", message: nil, preferredStyle: .alert)
        alert.addTextField { tf in
            tf.placeholder = "Enter food"
        }

        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let self = self else { return }
            let text = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            guard !text.isEmpty else { return }
            self.foods.append(text)
            self.tableView.reloadData()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addAction(addAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        foods.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        var content = cell.defaultContentConfiguration()
        content.text = foods[indexPath.row]
        content.textProperties.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        content.textProperties.color = .black
        cell.contentConfiguration = content

        cell.backgroundColor = .white
        cell.selectionStyle = .none
        return cell
    }
}
