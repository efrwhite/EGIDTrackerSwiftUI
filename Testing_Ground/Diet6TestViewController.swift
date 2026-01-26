////
////  Diet6TestViewController.swift
////  Testing_Ground
////
//
//
//import Foundation
//import UIKit
//
//class Diet6TestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
//    
//    var user: String?
//    var childName: String?
//    
//    // Declare the table view
//    let tableView = UITableView()
//    
//    // Foods data source
//    var foods = [
//        // Dairy items
//        "Milk",
//        "Butter",
//        "Cream",
//        "Buttermilk",
//        "Half & half",
//        "Yogurt",
//        "Cheese",
//        "Ice cream",
//        "Sour cream",
//        "Cottage cheese",
//        "Chocolates",
//        "Candy",
//        "Whey (listed in ingredients)",
//        "Casein (listed in ingredients)",
//
//        // Gluten items
//        "Flour",
//        "Bread",
//        "Bread products",
//        "Baked goods (muffins, biscuits, cakes, cookies)",
//        "Pasta",
//        "Couscous",
//        "Oats (due to cross-contamination with wheat)",
//        "Soy sauce",
//        "Gravy",
//        "Sauces containing roux",
//        "Breaded/battered fried foods",
//        "Foods containing wheat, rye, or barley",
//
//        // Soy items
//        "Tofu",
//        "Tempeh",
//        "Edamame",
//        "Soy milk",
//        "Soy products (yogurt, ice cream, etc.)",
//        "Soy sauce",
//        "Teriyaki sauce",
//        "Many processed/packaged foods",
//
//        // Egg items
//        "Eggs",
//        "Egg products",
//        "Baked goods containing egg",
//        "Baked goods with egg washes",
//        "Pancakes",
//        "Waffles",
//        "Battered fried foods",
//        "Mayonnaise",
//        "Meatloaf",
//        "Meatballs",
//        "Marshmallow",
//        "Some ice creams",
//        "Some salad dressings",
//
//        // Peanuts/Treenuts items
//        "Peanuts",
//        "Peanut butter",
//        "Other nut butters",
//        "Candy containing nuts",
//        "Ice cream containing nuts",
//        "Foods cooked in peanut oil (Chick-fil-A uses peanut oil)",
//
//        // Fish/Shellfish items
//        "All fish",
//        "Shrimp",
//        "Crab",
//        "Lobster",
//        "Scallops",
//        "Clams",
//        "Mussels",
//        "Steamers",
//        "Imitation crab"
//    ]
//
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Set up navigation bar
//        navigationItem.title = "Diet 6"
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
//        dietLabel.text = "Diet 6: Dairy, Gluten, Egg, Soy, Nuts, Fish Elimination Diet"
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
//


import Foundation
import UIKit

class Diet6TestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var user: String?
    var childName: String?
    
    let tableView = UITableView()
    
    private let purple = UIColor(red: 138/255, green: 96/255, blue: 176/255, alpha: 1)
    private let cardBG = UIColor.systemBackground
    
    var foods = [
        "Milk","Butter","Cream","Buttermilk","Half & half","Yogurt","Cheese","Ice cream","Sour cream","Cottage cheese",
        "Chocolates","Candy","Whey (listed in ingredients)","Casein (listed in ingredients)",
        "Flour","Bread","Bread products","Baked goods (muffins, biscuits, cakes, cookies)","Pasta","Couscous",
        "Oats (due to cross-contamination with wheat)","Soy sauce","Gravy","Sauces containing roux","Breaded/battered fried foods",
        "Foods containing wheat, rye, or barley",
        "Tofu","Tempeh","Edamame","Soy milk","Soy products (yogurt, ice cream, etc.)","Soy sauce","Teriyaki sauce","Many processed/packaged foods",
        "Eggs","Egg products","Baked goods containing egg","Baked goods with egg washes","Pancakes","Waffles","Battered fried foods",
        "Mayonnaise","Meatloaf","Meatballs","Marshmallow","Some ice creams","Some salad dressings",
        "Peanuts","Peanut butter","Other nut butters","Candy containing nuts","Ice cream containing nuts","Foods cooked in peanut oil (Chick-fil-A uses peanut oil)",
        "All fish","Shrimp","Crab","Lobster","Scallops","Clams","Mussels","Steamers","Imitation crab"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Diet 6"
        view.backgroundColor = .systemGroupedBackground
        navigationController?.navigationBar.tintColor = purple
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addFood))
        navigationItem.rightBarButtonItem = addButton
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        let foodsNotOkayLabel = UILabel()
        foodsNotOkayLabel.text = "Foods Not Okay to Eat"
        foodsNotOkayLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        foodsNotOkayLabel.textColor = purple
        foodsNotOkayLabel.textAlignment = .center
        foodsNotOkayLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(foodsNotOkayLabel)
        
        let dietLabel = UILabel()
        dietLabel.text = "Diet 6: Dairy, Gluten, Egg, Soy, Nuts, Fish Elimination Diet"
        dietLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        dietLabel.textColor = purple.withAlphaComponent(0.9)
        dietLabel.textAlignment = .center
        dietLabel.numberOfLines = 0
        dietLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(dietLabel)
        
        NSLayoutConstraint.activate([
            foodsNotOkayLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 18),
            foodsNotOkayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            foodsNotOkayLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            dietLabel.topAnchor.constraint(equalTo: foodsNotOkayLabel.bottomAnchor, constant: 8),
            dietLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dietLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        let tableCard = UIView()
        tableCard.translatesAutoresizingMaskIntoConstraints = false
        tableCard.backgroundColor = cardBG
        tableCard.layer.cornerRadius = 16
        tableCard.layer.borderWidth = 1
        tableCard.layer.borderColor = purple.withAlphaComponent(0.15).cgColor
        tableCard.layer.shadowColor = UIColor.black.cgColor
        tableCard.layer.shadowOpacity = 0.06
        tableCard.layer.shadowRadius = 10
        tableCard.layer.shadowOffset = CGSize(width: 0, height: 6)
        scrollView.addSubview(tableCard)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.rowHeight = 48
        tableView.isScrollEnabled = false
        tableCard.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableCard.topAnchor.constraint(equalTo: dietLabel.bottomAnchor, constant: 16),
            tableCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: tableCard.topAnchor, constant: 6),
            tableView.bottomAnchor.constraint(equalTo: tableCard.bottomAnchor, constant: -6),
            tableView.leadingAnchor.constraint(equalTo: tableCard.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: tableCard.trailingAnchor),
            
            tableCard.heightAnchor.constraint(equalToConstant: CGFloat(max(320, foods.count * 48 + 12)))
        ])
        
        let allergiesButton = UIButton(type: .system)
        allergiesButton.setTitle("Allergies", for: .normal)
        allergiesButton.backgroundColor = purple
        allergiesButton.setTitleColor(.white, for: .normal)
        allergiesButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        allergiesButton.layer.cornerRadius = 14
        allergiesButton.layer.shadowColor = UIColor.black.cgColor
        allergiesButton.layer.shadowOpacity = 0.12
        allergiesButton.layer.shadowRadius = 10
        allergiesButton.layer.shadowOffset = CGSize(width: 0, height: 6)
        allergiesButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(allergiesButton)
        
        NSLayoutConstraint.activate([
            allergiesButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            allergiesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            allergiesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            allergiesButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        allergiesButton.addTarget(self, action: #selector(allergiesButtonTapped), for: .touchUpInside)
    }
    
    @objc func allergiesButtonTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let allergiesVC = storyboard.instantiateViewController(withIdentifier: "AddAllergenViewController") as? AddAllergenViewController {
            allergiesVC.user = user ?? ""
            allergiesVC.childName = childName ?? ""
            navigationController?.pushViewController(allergiesVC, animated: true)
        }
    }
    
    @objc func addFood() {
        let alert = UIAlertController(title: "Add Food to List", message: nil, preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Enter food" }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            if let foodName = alert.textFields?.first?.text, !foodName.isEmpty {
                self?.foods.append(foodName)
                self?.tableView.reloadData()
            }
        }
        
        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { foods.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = foods[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cell.textLabel?.textColor = .label
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
}

