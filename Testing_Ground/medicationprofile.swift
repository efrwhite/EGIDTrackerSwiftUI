import Foundation
import UIKit
import CoreData

class MedicationProfile: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    var user = ""
    var childName = ""
    @IBOutlet weak var currentTableView: UITableView!
    let currentCellIdentifier = "currentcell1"
    
    @IBOutlet weak var discontinuedTableView: UITableView!
    let discontinuedCellIdentifier = "discontinuedcell"
    
    // Create fetchedResultsController for all medications
    var allFetchedResultsController: NSFetchedResultsController<Medication>!
    
    // Create arrays to hold current and discontinued medications
    var currentMedications: [Medication] = []
    var discontinuedMedications: [Medication] = []
    
    // Create a reference to the Core Data managed object context
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the fetched results controllers
        setupFetchedResultsControllers()
        
        // Configure table views and set delegates
        currentTableView.delegate = self
        currentTableView.dataSource = self
        currentTableView.register(UITableViewCell.self, forCellReuseIdentifier: currentCellIdentifier)
        
        discontinuedTableView.delegate = self
        discontinuedTableView.dataSource = self
        discontinuedTableView.register(UITableViewCell.self, forCellReuseIdentifier: discontinuedCellIdentifier)
        print("Child in Medication Profile: ",childName)
        print("Parent in Medication Profile: ",user)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Refresh data when the view appears
        setupFetchedResultsControllers()
        currentTableView.reloadData()
        discontinuedTableView.reloadData()
    }
    
    func setupFetchedResultsControllers() {
        let fetchRequest: NSFetchRequest<Medication> = Medication.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "medName", ascending: true)]
        
        // Filter for medications for a specific user
        let userPredicate = NSPredicate(format: "username == %@ AND childName ==%@ ", user, childName)
        fetchRequest.predicate = userPredicate
        
        allFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                               managedObjectContext: managedObjectContext,
                                                               sectionNameKeyPath: nil,
                                                               cacheName: nil)
        
        do {
            try allFetchedResultsController.performFetch()
            
            // Filter medications into current and discontinued based on enddate
            currentMedications = allFetchedResultsController.fetchedObjects?.filter { $0.enddate == nil } ?? []
            discontinuedMedications = allFetchedResultsController.fetchedObjects?.filter { $0.enddate != nil } ?? []
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    

    
    func didSaveNewMedication() {
        // Refresh data when a new medication is saved
        setupFetchedResultsControllers()
        currentTableView.reloadData()
        discontinuedTableView.reloadData()
    }
    
    // MARK: - Table View Data Source and Delegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.frame = CGRect(x: 15, y: 0, width: tableView.frame.size.width - 30, height: 30)
        
        if tableView == currentTableView {
            label.text = "Current Medications"
        } else if tableView == discontinuedTableView {
            label.text = "Cleared Medications"
        }
        
        headerView.addSubview(label)
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == currentTableView {
            return currentMedications.count
        } else if tableView == discontinuedTableView {
            return discontinuedMedications.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        if tableView == currentTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: currentCellIdentifier, for: indexPath)
            cell.textLabel?.text = currentMedications[indexPath.row].medName
        } else if tableView == discontinuedTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: discontinuedCellIdentifier, for: indexPath)
            cell.textLabel?.text = discontinuedMedications[indexPath.row].medName
        } else {
            cell = UITableViewCell()
        }
        
        // Check if the edit button is already added, and if not, add it
        if cell.contentView.subviews.first(where: { $0 is UIButton }) == nil {
            // Calculate the X position based on the cell's width and button width
            let buttonWidth: CGFloat = 50
            let xPosition = cell.contentView.frame.size.width - buttonWidth - 10 // 10 is the right margin

            // Set up the frame for the edit button
            let editButton = UIButton(type: .system)
            editButton.setTitle("Edit", for: .normal)
            editButton.frame = CGRect(x: xPosition, y: 5, width: buttonWidth, height: 30)
            editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
            
            cell.contentView.addSubview(editButton)
        }
        
        return cell
    }

    @objc func editButtonTapped(sender: UIButton) {
        var selectedMedicationName: String?
        
        if let cell = sender.superview?.superview as? UITableViewCell, let indexPath = currentTableView.indexPath(for: cell) {
            // Handle editing for the currentTableView
            selectedMedicationName = currentMedications[indexPath.row].medName
            // Implement the editing logic for the selected medication
        } else if let cell = sender.superview?.superview as? UITableViewCell, let indexPath = discontinuedTableView.indexPath(for: cell) {
            // Handle editing for the discontinuedTableView
            selectedMedicationName = discontinuedMedications[indexPath.row].medName
            // Implement the editing logic for the selected medication
        }
        
        // Perform the segue and pass the isEdit boolean and selected medication name
        performSegue(withIdentifier: "addmed", sender: (true, selectedMedicationName))
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addmed", let displayVC = segue.destination as? AddMedicationViewController {
            displayVC.user = user
            displayVC.childName = childName //added if not tied to child never will be used
            
            if let (isEdit, medicationName) = sender as? (Bool, String) {
                displayVC.isEditMode = isEdit // Updated the property name
                displayVC.medicationName = medicationName
                displayVC.user = user //added since user would always be null if not added, this will cause the database to pull the first medication meeting the naming requirements which could be wrong for dosage. so I added the user to fix this
                displayVC.childName = childName // added since it will clash with multiple children/patients without a composite key of (user, child)
            } else {
                //IDK what this use case is for but always have user and child
                displayVC.isEditMode = false
                displayVC.medicationName = ""
                displayVC.user = user //added since user would always be null if not added, this will cause the database to pull the first medication meeting the naming requirements which could be wrong for dosage. so I added the user to fix this
                displayVC.childName = childName // added since it will clash with multiple children/patients without a composite key of (user, child)
            }
            
            //displayVC.delegate = self
        }
    }
}


