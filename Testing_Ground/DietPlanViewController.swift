//
//  DietPlanViewController.swift
//  Testing_Ground
//
//  Created by Brianna Boston on 10/20/23.
//


import Foundation
import UIKit
import CoreData

class DietPlanViewController: UIViewController {

    var user = "" // Username of the parent or child
    var childName = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDietPlanButtons()
    }

    private func fetchChildDietType() -> String? {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Child")

        fetchRequest.predicate = NSPredicate(format: "username == %@", user)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            if let child = result.first as? NSManagedObject, let dietType = child.value(forKey: "diettype") as? String {
                print("Fetched child diet type: \(dietType)")
                return dietType
            } else {
                print("No child found for username \(user) or diet type is nil")
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return nil
    }

    private func configureDietPlanButtons() {
        guard let childDietType = fetchChildDietType() else {
            print("No diet type fetched")
            return
        }
        
        switch childDietType {
        case "Diet 1", "Diet 2", "Diet 4", "Diet 6":
            createButtonWithTitle(childDietType, selector: #selector(dietPlanButtonTapped(_:)))
        default:
            print("Invalid diet type: \(childDietType)")
        }
    }

    private func createButtonWithTitle(_ title: String, selector: Selector) {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.backgroundColor = UIColor(red: 57/255, green: 67/255, blue: 144/255, alpha: 1) // #394390
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Times New Roman", size: 17.0)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: selector, for: .touchUpInside)

        self.view.addSubview(button)

        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor), // Centered vertically in the view
            button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor), // Centered horizontally in the view
            button.widthAnchor.constraint(equalToConstant: 250), // Fixed width, adjust as needed
            button.heightAnchor.constraint(equalToConstant: 50) // Fixed height, adjust as needed
        ])
        
        print("Button for \(title) created and constraints set")
    }

    @objc private func dietPlanButtonTapped(_ sender: UIButton) {
        guard let dietPlanTitle = sender.title(for: .normal) else { return }
        let storyboardID = dietPlanTitle.replacingOccurrences(of: " ", with: "") + "ViewController"
        
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: storyboardID) else {
            print("ViewController with ID \(storyboardID) not found")
            return
        }
        
        print("Navigating to \(storyboardID)")
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
