
import Foundation
import CoreData
import UIKit

class HomeViewController: UIViewController {

    var mainChildProfile: Child?
    var user = ""
    var childselected = ""
    @IBOutlet weak var childnames: UILabel!
    @IBOutlet weak var childsimage: UIImageView!
    @IBOutlet weak var childsdiet: UILabel!
    var isButtonEnabled = true

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Home Username: ", user)
        print("Home Childuser: ", childselected)
        //childsimage.contentMode = .scaleAspectFill
        //childsimage.layer.cornerRadius = 5
        childsimage.layer.cornerRadius = 5
        

        // Check if childselected is provided, otherwise fetch first child
        if !childselected.isEmpty {
            // Fetch the selected child if available
            let selectedChildProfile = fetchChildProfile(username: user, childName: childselected)
            if let selectedChildProfile = selectedChildProfile {
                updateUIWithChildProfile(childProfile: selectedChildProfile)
            } else {
                mainChildProfile = fetchFirstChild(username: user)
                setDefaultChildName()
                updateUIWithMainChildProfile()
            }
        } else if childselected.isEmpty {
            // If childName is empty or null, fetch the first child for the user
            mainChildProfile = fetchFirstChild(username: user)
            setDefaultChildName()
            updateUIWithMainChildProfile()
        } else {
            // If no selected child, use the main child profile
            mainChildProfile = fetchMainChildProfile(username: user)
            updateUIWithMainChildProfile()
        }

        // Hide the back button
        self.navigationItem.setHidesBackButton(true, animated: false)
        
        // Setup the child views layout
//        setupChildViews()

        // Add the logout button
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "rectangle.portrait.and.arrow.right"), for: .normal)
        button.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        styleHomeButtons()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("View will Appear Home Username: ", user)
        print("View will Appear Home Childuser: ", childselected)

        // Check if childselected is provided, otherwise fetch first child
        if !childselected.isEmpty {
            // Fetch the selected child if available
            let selectedChildProfile = fetchChildProfile(username: user, childName: childselected)
            if let selectedChildProfile = selectedChildProfile {
                updateUIWithChildProfile(childProfile: selectedChildProfile)
            } else {
                mainChildProfile = fetchFirstChild(username: user)
                setDefaultChildName()
                updateUIWithMainChildProfile()
            }
        } else if childselected.isEmpty {
            // If childName is empty or null, fetch the first child for the user
            mainChildProfile = fetchFirstChild(username: user)
            setDefaultChildName()
            updateUIWithMainChildProfile()
        } else {
            // If no selected child, use the main child profile
            mainChildProfile = fetchMainChildProfile(username: user)
            updateUIWithMainChildProfile()
        }

        // Hide the back button
        self.navigationItem.setHidesBackButton(true, animated: false)

        // Remove SignUpViewController from navigation stack
        if let viewControllers = self.navigationController?.viewControllers {
            for viewController in viewControllers {
                if viewController is SignUpViewController {
                    var newViewControllers = viewControllers
                    if let index = newViewControllers.firstIndex(of: viewController) {
                        newViewControllers.remove(at: index)
                        self.navigationController?.viewControllers = newViewControllers
                    }
                }
            }
        }
    }

    @objc func showAlert() {
        let alertController = UIAlertController(title: "Logout", message: "Are you sure you want to log out?", preferredStyle: .alert)
        
        let logoutAction = UIAlertAction(title: "Log Out", style: .destructive) { (_) in
            if let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") {
                self.navigationController?.setNavigationBarHidden(true, animated: false)
                self.navigationController?.pushViewController(loginVC, animated: true)
                self.navigationController?.setNavigationBarHidden(false, animated: false)
            }
        }
        alertController.addAction(logoutAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

    func updateUIWithMainChildProfile() {
        if let mainChildProfile = mainChildProfile {
            // Update the name label with child's name
            childnames.text = "\(mainChildProfile.firstName!) \(mainChildProfile.lastName!)"

            // Assuming you have a property called 'imageData' in Child entity that stores image data
            if let imageData = mainChildProfile.image {
                // Update the image view with child's image
                childsimage.image = UIImage(data: imageData)
            } else {
                // If there is no image data, you can set a default image or handle it as needed
                childsimage.image = UIImage(named: "DefaultImage")
            }

            // Update the diet label with child's diet type
            childsdiet.text = "Diet: \(String(describing: mainChildProfile.diettype!))"
            // Update other UI elements as needed
        } else {
            // Handle the case when no main child profile is found
            childnames.text = "Welcome!"
            childsimage.image = nil
            childsdiet.text = "Diet: Diet Type"
            // Update other UI elements as needed
        }
    }

    func updateUIWithChildProfile(childProfile: Child) {
        // Update the UI based on the selected child's profile
        childnames.text = "\(childProfile.firstName!) \(childProfile.lastName!)"

        if let imageData = childProfile.image {
            childsimage.image = UIImage(data: imageData)
        } else {
            childsimage.image = UIImage(named: "DefaultImage")
        }

        childsdiet.text = "Diet: \(String(describing: childProfile.diettype!))"
        // Update other UI elements as needed
    }
    private func styleHomeButtons() {
        // style buttons by tags so you don’t need outlets
        let tags = [101, 102, 103, 104, 105, 106]
        for tag in tags {
            if let button = view.viewWithTag(tag) as? UIButton {
                stylePrimaryHomeButton(button)
            }
        }
    }

    private func stylePrimaryHomeButton(_ button: UIButton) {
        let purple = UIColor(red: 138/255, green: 96/255, blue: 176/255, alpha: 1) // #8A60B0

        button.backgroundColor = purple
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)

        // pill shape (works even if height changes on different devices)
        button.layer.cornerRadius = button.bounds.height / 2
        button.layer.masksToBounds = false

        // soft shadow for “lift”
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.14
        button.layer.shadowRadius = 10
        button.layer.shadowOffset = CGSize(width: 0, height: 6)

        // nicer tap feel
        button.configuration = nil // prevents modern UIButton config from overriding styling (iOS 15+)
        button.showsTouchWhenHighlighted = false
    }

    // keep pill shape correct after autolayout
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let tags = [101, 102, 103, 104, 105, 106]
        for tag in tags {
            if let button = view.viewWithTag(tag) as? UIButton {
                button.layer.cornerRadius = button.bounds.height / 2
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "profilessegue", let displayVC = segue.destination as? HomeProfilePageViewController {
            // Pass any necessary data to HomeViewController if needed
            displayVC.user = user
            displayVC.selected = childselected
            print("User value sent to HomeProfilePage: \(user)")
        } else if segue.identifier == "plansegue", let displayVC = segue.destination as? YourPlanViewController {
            displayVC.user = user
            displayVC.childName = childselected
            print("User value sent to Plan: ", user)
        } else if segue.identifier == "symptomsegue", let displayVC = segue.destination as? SymptomScoreViewController {
            displayVC.user = user
            displayVC.childName = childselected
            print("User value sent to Symptom: ", user, childselected)
        }
        else if segue.identifier == "qualitysegue", let displayVC = segue.destination as? QualityofLifeViewController {
            displayVC.user = user
            displayVC.childName = childselected
            print("User value sent to Quality: ", user)
        }
        else if segue.identifier == "Journalsegue", let displayVC = segue.destination as? Diet6GoodViewController{
            displayVC.user = user
            displayVC.childName = childselected
            print("User value sent to Quality: ", user)
        }
    }

    func fetchMainChildProfile(username: String) -> Child? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Child> = Child.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", user)

        do {
            let childProfiles = try context.fetch(fetchRequest)
            return childProfiles.first // Get the first child profile that matches the predicate
        } catch {
            print("Error fetching main child profile: \(error)")
            return nil
        }
    }

    func fetchChildProfile(username: String, childName: String) -> Child? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Child> = Child.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@ AND firstName == %@", user, childselected)

        do {
            let childProfiles = try context.fetch(fetchRequest)
            return childProfiles.first // Get the first child profile that matches the predicate
        } catch {
            print("Error fetching child profile: \(error)")
            return nil
        }
    }

    func fetchFirstChild(username: String) -> Child? {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Child> = Child.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "username == %@", user)

        do {
            let childProfiles = try context.fetch(fetchRequest)
            return childProfiles.first // Get the first child profile that matches the predicate
        } catch {
            print("Error fetching first child: \(error)")
            return nil
        }
    }

    func setDefaultChildName() {
        // Set childselected to the first child's name if it exists
        if let mainChildProfile = mainChildProfile {
            childselected = mainChildProfile.firstName ?? ""
            print("Default child name set to: \(childselected)")
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.setHidesBackButton(false, animated: false)
    }
}
