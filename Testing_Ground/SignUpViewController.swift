import Foundation
import UIKit
import CoreData

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var Email: UITextField!
    @IBOutlet weak var Mobile: UITextField!
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var ConfirmPassword: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!  // Add an IBOutlet for the ScrollView
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var receivedString = ""
    var parents = [Parent]()
    var seguePerformed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the textField delegates
        Username.delegate = self
        Email.delegate = self
        Mobile.delegate = self
        Password.delegate = self
        ConfirmPassword.delegate = self
        
        // Add tap gesture to dismiss the keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        // Add observers for keyboard notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Save button action
    @IBAction func EnterButton(_ sender: Any) {
        let username = Username.text ?? ""
        let password = Password.text ?? ""
        let userPhone = Mobile.text ?? ""
        let emails = Email.text ?? ""
        let confirmPassword = ConfirmPassword.text ?? ""
        
        if(username.isEmpty || userPhone.isEmpty || password.isEmpty || confirmPassword.isEmpty || emails.isEmpty) {
            let alertController = UIAlertController(title: "Incomplete Form", message: "Please complete the sign-up form", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(confirmAction)
            present(alertController, animated: true, completion: nil)
        } else {
            let newAccount = Parent(context: self.context)
            newAccount.username = Username.text!
            newAccount.phone = Mobile.text!
            newAccount.email = Email.text!
            newAccount.password = Password.text!
            self.parents.append(newAccount)
            self.SaveItems()
            
            if !seguePerformed {
                seguePerformed = true
                receivedString = Username.text!
            }
        }
    }
    
    // Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "parentSegue", let displayVC = segue.destination as? ParentViewController {
            displayVC.user = receivedString
            displayVC.usernamesup = Username.text!
        }
    }
    
    // Dismiss keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // Adjust the scroll view when keyboard appears
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }

        let keyboardHeight = keyboardFrame.height
        
        // Find the currently active text field
        var activeTextField: UITextField?
        for subview in stackView.arrangedSubviews {
            if let textField = subview as? UITextField, textField.isFirstResponder {
                activeTextField = textField
                break
            }
        }
        
        if let activeTextField = activeTextField {
            let textFieldFrame = activeTextField.convert(activeTextField.bounds, to: self.view)
            
            // Calculate the offset so that the active text field is visible above the keyboard
            let targetY = textFieldFrame.maxY + keyboardHeight - self.view.frame.height + 100  // Adjust 100 to account for the navbar
            if targetY > 0 {
                UIView.animate(withDuration: duration) {
                    self.scrollView.contentOffset = CGPoint(x: 0, y: targetY)
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        // Reset scrollView offset when the keyboard hides
        UIView.animate(withDuration: duration) {
            self.scrollView.contentOffset = CGPoint.zero
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func SaveItems() {
        do {
            try context.save()
        } catch {
            print("Error Saving")
        }
    }
}
