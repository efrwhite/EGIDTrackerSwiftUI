import UIKit
import CoreData

// Add an extension to Array for safe subscripting
extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

class HomeProfilePageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var user = ""
    var selectedChild: Child?
    var selected = ""

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableView2: UITableView!
    var childProfiles: [Child] = []
    var parentProfiles: [Parent] = []

    let TableviewOne = "ProfilesTableviewcell"
    let TableviewTwo = "ParentTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

        // Register the custom cell from the XIB for the first table view
        let nib1 = UINib(nibName: "ProfilesTableviewcell", bundle: nil)
        tableView.register(nib1, forCellReuseIdentifier: TableviewOne)

        tableView2.dataSource = self
        tableView2.delegate = self

        // Register the custom cell from the XIB for the second table view
        let nib2 = UINib(nibName: "ParentTableViewCell", bundle: nil)
        tableView2.register(nib2, forCellReuseIdentifier: TableviewTwo)

        // Call your fetch functions here to load the data
        childProfiles = fetchChildProfiles(username: user)
        parentProfiles = fetchParentProfiles(username: user)

        // Debugging print statements
        print("Child Profiles Count: \(childProfiles.count)")
        print("Parent Profiles Count: \(parentProfiles.count)")

        // Reload table views to populate data
        tableView.reloadData()
        tableView2.reloadData()
        if !user.isEmpty {
            print("Profile User: \(user)")
        } else {
            print("user is nil")
        }
        setupPrettyTables()

    }
    
    private let purple = UIColor(red: 138/255, green: 96/255, blue: 176/255, alpha: 1) // #8A60B0
    private let pageBG = UIColor(red: 0.97, green: 0.96, blue: 0.95, alpha: 1) // warm off-white

    private func setupPrettyTables() {
        view.backgroundColor = pageBG

        [tableView, tableView2].forEach { tv in
            guard let tv = tv else { return }
            tv.backgroundColor = .clear
            tv.separatorStyle = .none
            tv.showsVerticalScrollIndicator = false

            // spacing around your "card" cells
            tv.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 24, right: 0)
        }
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Reload data for both table views
        childProfiles = fetchChildProfiles(username: user)
        parentProfiles = fetchParentProfiles(username: user)

        tableView.reloadData()
        tableView2.reloadData()
    }
   
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.tableView {
            return 2 // [0: "Please select", 1: Patient List]
        } else if tableView == self.tableView2 {
            return 1 // [0: Caregiver List]
        }
        return 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            selectedChild = childProfiles[indexPath.row]
            tableView.reloadSections(IndexSet(integer: 1), with: .none)
            // Print the selected child's name to the debug console
            if let child = selectedChild, let childName = child.firstName {
                print("Selected Child: \(childName)")
                // This is where we fire off the child name segue
            }
            
            // Reload the table view to apply the new selection style
            tableView.reloadData()
            
            // Show a popup message with the selected child's name
            if let child = selectedChild, let childName = child.firstName {
                let alertController = UIAlertController(title: "Main Patient Selection",
                                                        message: "\(childName) is chosen as the Active Patient.",
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alertController, animated: true, completion: nil)
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == self.tableView && section == 0 { return 70 }
        return 50
    }


//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 50  // Adjust the height to add space above the header
//    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
//        headerView.backgroundColor = .white
//
//        let label = UILabel(frame: CGRect(x: 15, y: 10, width: 200, height: 20))
//        label.font = UIFont.boldSystemFont(ofSize: 18)
//        label.textColor = .black
//        headerView.addSubview(label)
//
//        let addButton = UIButton(type: .system)
//        addButton.setTitle("Add", for: .normal)
//        addButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
//        addButton.frame = CGRect(x: tableView.frame.width - 60, y: 5, width: 50, height: 30)
//
//        if tableView == self.tableView {
//            if section == 0 {
//                label.text = "Please select a patient"
//            } else if section == 1 {
//                label.text = "Patient"
//                addButton.addTarget(self, action: #selector(addChildButtonPressed), for: .touchUpInside)
//                headerView.addSubview(addButton)
//            }
//        }
//
//        if tableView == self.tableView2 {
//            if section == 0 {
//                label.text = "Caregiver"
//                addButton.addTarget(self, action: #selector(addParentButtonPressed), for: .touchUpInside)
//                headerView.addSubview(addButton)
//            }
//        }
//
//        return headerView
//    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let purple = UIColor(red: 138/255, green: 96/255, blue: 176/255, alpha: 1) // #8A60B0

        let container = UIView()
        container.backgroundColor = .clear

        let headerCard = UIView()
        headerCard.backgroundColor = .clear
        headerCard.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(headerCard)

        // Title
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        headerCard.addSubview(label)

        // Subtitle (only used for "Please select a patient")
        let subtitle = UILabel()
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        subtitle.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        subtitle.textColor = UIColor.black.withAlphaComponent(0.55)
        subtitle.numberOfLines = 0
        subtitle.isHidden = true
        headerCard.addSubview(subtitle)

        // "Active" pill (only used for Patient section header)
        let activePill = UILabel()
        activePill.translatesAutoresizingMaskIntoConstraints = false
        activePill.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        activePill.textColor = purple
        activePill.backgroundColor = purple.withAlphaComponent(0.12)
        activePill.layer.cornerRadius = 14
        activePill.clipsToBounds = true
        activePill.textAlignment = .center
        activePill.isHidden = true
        headerCard.addSubview(activePill)

        // Add button
        let addButton = UIButton(type: .system)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setTitle("Add", for: .normal)
        addButton.setTitleColor(purple, for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)

        // pill look
        addButton.backgroundColor = UIColor.white
        addButton.layer.cornerRadius = 16
        addButton.layer.borderWidth = 1
        addButton.layer.borderColor = purple.withAlphaComponent(0.25).cgColor
        addButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 14, bottom: 6, right: 14)

        // Decide header text + whether to show Add / subtitle / active pill
        if tableView == self.tableView {
            if section == 0 {
                label.text = "Please select a patient"
                subtitle.text = "Tap a patient below to set them as the active profile."
                subtitle.isHidden = false
            } else {
                label.text = "Patient"

                // Active patient name (uses your current selection logic)
                let activeName = selectedChild?.firstName ?? selected
                if !activeName.isEmpty {
                    activePill.text = " Active: \(activeName) "
                } else {
                    activePill.text = " Active: None "
                }
                activePill.isHidden = false

                addButton.addTarget(self, action: #selector(addChildButtonPressed), for: .touchUpInside)
                headerCard.addSubview(addButton)
            }
        } else if tableView == self.tableView2 {
            label.text = "Caregiver"
            addButton.addTarget(self, action: #selector(addParentButtonPressed), for: .touchUpInside)
            headerCard.addSubview(addButton)
        }

        // Base layout
        NSLayoutConstraint.activate([
            headerCard.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            headerCard.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            headerCard.topAnchor.constraint(equalTo: container.topAnchor, constant: 10),
            headerCard.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -6),

            label.leadingAnchor.constraint(equalTo: headerCard.leadingAnchor),
            label.topAnchor.constraint(equalTo: headerCard.topAnchor)
        ])

        // Subtitle layout (only if visible)
        if !subtitle.isHidden {
            NSLayoutConstraint.activate([
                subtitle.leadingAnchor.constraint(equalTo: headerCard.leadingAnchor),
                subtitle.trailingAnchor.constraint(equalTo: headerCard.trailingAnchor),
                subtitle.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 6),
                subtitle.bottomAnchor.constraint(equalTo: headerCard.bottomAnchor)
            ])
        } else {
            // If no subtitle, keep label vertically centered-ish
            NSLayoutConstraint.activate([
                label.centerYAnchor.constraint(equalTo: headerCard.centerYAnchor)
            ])
        }

        // Active pill layout (Patient header only)
        if !activePill.isHidden {
            NSLayoutConstraint.activate([
                activePill.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 10),
                activePill.centerYAnchor.constraint(equalTo: label.centerYAnchor),
                activePill.heightAnchor.constraint(equalToConstant: 28)
            ])
            // Don't force width too tight; let it size based on text
            activePill.setContentHuggingPriority(.required, for: .horizontal)
            activePill.setContentCompressionResistancePriority(.required, for: .horizontal)
        }

        // Add button layout (if added)
        if addButton.superview != nil {
            NSLayoutConstraint.activate([
                addButton.trailingAnchor.constraint(equalTo: headerCard.trailingAnchor),
                addButton.centerYAnchor.constraint(equalTo: label.centerYAnchor)
            ])
        }

        return container
    }


    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            // For child/patient tableView
            if indexPath.section == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: TableviewOne, for: indexPath) as! ProfilesTableviewcell
                let childProfile = childProfiles[indexPath.row]
                cell.namelabel.text = childProfile.firstName
                cell.editbutton.tag = indexPath.row
                cell.editbutton.addTarget(self, action: #selector(editButtonPressed(_:)), for: .touchUpInside)
                return cell
            }
        } else if tableView == self.tableView2 {
            // For caregiver tableView2
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: TableviewTwo, for: indexPath) as! ParentTableViewCell
                let parentProfile = parentProfiles[indexPath.row]
                cell.parentname.text = parentProfile.firstname // ✅ Make sure this IBOutlet exists in your XIB
                cell.editbutton.tag = indexPath.row
                cell.editbutton.addTarget(self, action: #selector(editParentButtonPressed(_:)), for: .touchUpInside)
                styleAsCard(cell)
                return cell
            }
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return section == 1 ? childProfiles.count : 0
        } else if tableView == self.tableView2 {
            return section == 0 ? parentProfiles.count : 0
        }
        return 0
    }

    // MARK: - Add Button Actions
    @objc func addChildButtonPressed() {
        let childViewController = storyboard?.instantiateViewController(withIdentifier: "Patient Profile") as! ChildViewController
        childViewController.isAddingChild = true
        childViewController.user = user
        navigationController?.pushViewController(childViewController, animated: true)
    }

    @objc func addParentButtonPressed() {
        let parentViewController = storyboard?.instantiateViewController(withIdentifier: "ParentViewController") as! ParentViewController
        parentViewController.isAddingParent = true
        parentViewController.user = user
        navigationController?.pushViewController(parentViewController, animated: true)
    }

    // MARK: - End of new functionality
    @objc func addButtonPressed(_ sender: UIButton) {
        // Determine which table view's "Add" button was pressed
        if let tableView = sender.superview?.superview as? UITableView {
            if tableView == self.tableView {
                // Handle the "Add" button press for the child table view
                print("add button pressed")
                let childViewController = storyboard?.instantiateViewController(withIdentifier: "Patient Profile") as! ChildViewController
                childViewController.isAddingChild = true
                childViewController.user = user // Set the user property here
                navigationController?.pushViewController(childViewController, animated: true)
            } else if tableView == self.tableView2 {
                // Handle the "Add" button press for the parent table view
                let parentViewController = storyboard?.instantiateViewController(withIdentifier: "ParentViewController") as! ParentViewController
                parentViewController.isAddingParent = true
                parentViewController.user = user
                navigationController?.pushViewController(parentViewController, animated: true)
            }
        }
    }

    @objc func editButtonPressed(_ sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        
        if let childProfile = childProfiles[safe: indexPath.row] {
            let childViewController = storyboard?.instantiateViewController(withIdentifier: "Patient Profile") as! ChildViewController
            childViewController.isEditingChild = true
            childViewController.childName = childProfile.firstName ?? "Default Child Name"
            childViewController.user = user
            navigationController?.pushViewController(childViewController, animated: true)
        }
    }

    @objc func editParentButtonPressed(_ sender: UIButton) {
        let indexPath = IndexPath(row: sender.tag, section: 0)
        
        if let parentProfile = parentProfiles[safe: indexPath.row] {
            let parentViewController = storyboard?.instantiateViewController(withIdentifier: "ParentViewController") as! ParentViewController
            parentViewController.isEditingParent = true
            parentViewController.parentName = parentProfile.firstname ?? "Default Parent Name"
            parentViewController.user = user
            navigationController?.pushViewController(parentViewController, animated: true)
        }
    }

    func fetchChildProfiles(username: String) -> [Child] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Child> = Child.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", username)

        do {
            let childProfiles = try context.fetch(fetchRequest)

            // Filter and remove empty or invalid profiles
            let validChildProfiles = childProfiles.filter { $0.firstName != nil && !$0.firstName!.isEmpty }

            return validChildProfiles
        } catch {
            print("Error fetching child profiles: \(error)")
            return []
        }
    }
    private func styleAsCard(_ cell: UITableViewCell) {
        cell.backgroundColor = .clear
        cell.selectionStyle = .none

        cell.contentView.backgroundColor = .white
        cell.contentView.layer.cornerRadius = 16
        cell.contentView.layer.masksToBounds = true

        // give spacing around the contentView (card margin)
        cell.contentView.layoutMargins = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        cell.preservesSuperviewLayoutMargins = false
    }


    func fetchParentProfiles(username: String) -> [Parent] {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Parent> = Parent.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", username)
        
        do {
            let parentProfiles = try context.fetch(fetchRequest)
            
            // Filter and remove empty or invalid profiles
            let validParentProfiles = parentProfiles.filter { $0.firstname != nil && !$0.firstname!.isEmpty }
            
            return validParentProfiles
        } catch {
            print("Error fetching parent profiles: \(error)")
            return []
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Call saveAndUnwind before the view disappears
        if isMovingFromParent || isBeingDismissed {
            saveAndUnwind(self)
        }
    }
//programmatically in use for  when we go back to homescreen
    @IBAction func saveAndUnwind(_ sender: Any) {
          if let navController = navigationController {
              // Iterate over view controllers in the navigation stack to find HomeViewController
              if let homeViewController = navController.viewControllers.first(where: { $0 is HomeViewController }) as? HomeViewController {
                  homeViewController.user = self.user
                  homeViewController.childselected = self.selectedChild?.firstName ?? selected
                  print("Returning to HomeViewController with user: \(self.user) and child: \(self.selectedChild?.firstName ?? selected)")
              }
              // Pop the current view controller
              //navController.popViewController(animated: true)
          }
      }
}

