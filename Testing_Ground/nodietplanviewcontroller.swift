////
////  nodietplanviewcontroller.swift
////  Testing_Ground
////
////  Created by Brianna Boston on 4/11/25.
////
//
//import Foundation
//import UIKit
//import CoreData
//
//class nodietplanviewcontroller: UIViewController, UITableViewDataSource, UITableViewDelegate {
//    
//    var dietEntries: [String] = [] // Replace with your Diet model if needed
//    var childName = ""
//    var user = ""
//    let tableView = UITableView()
//    let placeholderLabel: UILabel = {
//        let label = UILabel()
//        label.text = "No Diet, Go to profiles page to set your diet."
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


//
//  nodietplanviewcontroller.swift
//  Testing_Ground
//

import Foundation
import UIKit
import CoreData

class nodietplanviewcontroller: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var dietEntries: [String] = [] // Replace with your Diet model if needed
    var childName = ""
    var user = ""

    let tableView = UITableView(frame: .zero, style: .insetGrouped)

    // Soft “card” placeholder so it looks intentional (and matches your app vibe)
    private let placeholderCard: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        v.layer.cornerRadius = 18
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.black.withAlphaComponent(0.06).cgColor
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.06
        v.layer.shadowRadius = 10
        v.layer.shadowOffset = CGSize(width: 0, height: 6)
        return v
    }()

    private let placeholderTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No Diet Plan Selected"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()

    private let placeholderSubtitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Go to Profiles to choose a diet for this patient.\nThen come back here to view the plan."
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.black.withAlphaComponent(0.55)
        label.numberOfLines = 0
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Keep this consistent with your other screens
        view.backgroundColor = UIColor(white: 0.97, alpha: 1.0)

        setupTableView()
        setupPlaceholder()
        loadDietData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadDietData()
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DietCell")

        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        // If empty, we’ll show our placeholder card instead of empty rows.
        tableView.tableFooterView = UIView()

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupPlaceholder() {
        view.addSubview(placeholderCard)
        placeholderCard.addSubview(placeholderTitle)
        placeholderCard.addSubview(placeholderSubtitle)

        NSLayoutConstraint.activate([
            placeholderCard.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderCard.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholderCard.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 24),
            placeholderCard.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -24),

            placeholderTitle.topAnchor.constraint(equalTo: placeholderCard.topAnchor, constant: 18),
            placeholderTitle.leadingAnchor.constraint(equalTo: placeholderCard.leadingAnchor, constant: 18),
            placeholderTitle.trailingAnchor.constraint(equalTo: placeholderCard.trailingAnchor, constant: -18),

            placeholderSubtitle.topAnchor.constraint(equalTo: placeholderTitle.bottomAnchor, constant: 8),
            placeholderSubtitle.leadingAnchor.constraint(equalTo: placeholderCard.leadingAnchor, constant: 18),
            placeholderSubtitle.trailingAnchor.constraint(equalTo: placeholderCard.trailingAnchor, constant: -18),
            placeholderSubtitle.bottomAnchor.constraint(equalTo: placeholderCard.bottomAnchor, constant: -18),
        ])
    }

    private func loadDietData() {
        // Load dietEntries from Core Data or other source
        // For now, it's just an empty array for the placeholder example
        dietEntries = [] // Load your actual data here

        let hasData = !dietEntries.isEmpty
        placeholderCard.isHidden = hasData
        tableView.isHidden = !hasData ? false : false // keep table visible for layout; placeholder overlays nicely
        tableView.reloadData()
    }

    // MARK: - UITableView DataSource Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dietEntries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DietCell", for: indexPath)

        var config = cell.defaultContentConfiguration()
        config.text = dietEntries[indexPath.row]
        config.textProperties.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        config.textProperties.color = .black

        cell.contentConfiguration = config
        cell.backgroundColor = .white
        cell.selectionStyle = .default

        return cell
    }

    // MARK: - UITableView Delegate (optional)

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Handle selection if needed
    }
}
