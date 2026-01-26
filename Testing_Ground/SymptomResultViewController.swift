//
//  SymptomResultViewController.swift
//  Testing_Ground
//
//  Created by Vivek Vangala on 7/14/24.
//

import Foundation
import UIKit

class SymptomResultViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var symptomEntries: [SymptomScoreViewController.SymptomEntry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return symptomEntries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SymptomResultCell", for: indexPath)
        let entry = symptomEntries[indexPath.row]
        cell.textLabel?.text = "Sum: \(entry.sum) - Date: \(entry.date)"
        return cell
    }
}

