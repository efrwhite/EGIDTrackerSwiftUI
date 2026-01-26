import UIKit
import CoreData

class Diet1ViewController: UIViewController {
    
    @IBOutlet weak var Diet1GoodView: UIView!
    @IBOutlet weak var Diet1BadView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var user = ""
    var childName = ""
    var Diet1GoodViewController: Diet1GoodViewController?
    var Diet1BadViewController: Diet1BadViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .selected)
        
        // initial view at view load
        Diet1GoodView.isHidden = false
        Diet1BadView.isHidden = true
        
        // Get reference to child view controllers
        Diet1GoodViewController = children.first(where: { $0 is Diet1GoodViewController }) as? Diet1GoodViewController
        Diet1BadViewController = children.first(where: { $0 is Diet1BadViewController }) as? Diet1BadViewController
    }
   
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            Diet1GoodView.isHidden = false
            Diet1BadView.isHidden = true
        } else {
            Diet1GoodView.isHidden = true
            Diet1BadView.isHidden = false
        }
    }

    @IBAction func addFoodTapped(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Add Food", message: "Choose which list to add the food to:", preferredStyle: .actionSheet)
        
        let addGoodFoodAction = UIAlertAction(title: "Foods Okay to Eat", style: .default) { [weak self] _ in
            self?.presentAddFoodAlert(isGoodFood: true)
        }
        
        let addBadFoodAction = UIAlertAction(title: "Foods Not Okay to Eat", style: .default) { [weak self] _ in
            self?.presentAddFoodAlert(isGoodFood: false)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(addGoodFoodAction)
        alertController.addAction(addBadFoodAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

    private func presentAddFoodAlert(isGoodFood: Bool) {
        let alertController = UIAlertController(title: "Add Food", message: "Enter the name of the food", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Food name"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let foodName = alertController.textFields?.first?.text, !foodName.isEmpty else { return }
            
            if isGoodFood {
                self?.Diet1GoodViewController?.addFood(foodName)
            } else {
                self?.Diet1BadViewController?.addFood(foodName)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
