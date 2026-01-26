import UIKit
import CoreData

var defaultUsername = "username"
var defaultPassword = "password"

class LoginViewController: UIViewController, UITextFieldDelegate {

    // DO NOT change these outlets (kept exactly)
    @IBOutlet weak var Password: UITextField!
    @IBOutlet weak var Username: UITextField!
    @IBOutlet weak var stackView: UIStackView!

    // Prevent double navigation
    private var isNavigating = false

    override func viewDidLoad() {
        super.viewDidLoad()

        Password.delegate = self
        Username.delegate = self

        // Dismiss keyboard on tap
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false // so buttons still work
        view.addGestureRecognizer(tapGesture)

        // Style fields (use ONE system; your SF symbols)
        setupFields()

        // Keyboard observers
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // reset when coming back to this screen
        isNavigating = false
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Field styling

    private func setupFields() {
        let purple = UIColor(red: 138/255, green: 96/255, blue: 176/255, alpha: 1) // #8A60B0
        let fieldBG = UIColor(red: 230/255, green: 214/255, blue: 241/255, alpha: 1)

        configureField(Username,
                       placeholder: "username",
                       sfSymbol: "person.fill",
                       tint: purple,
                       background: fieldBG,
                       isSecure: false)

        configureField(Password,
                       placeholder: "password",
                       sfSymbol: "lock.fill",
                       tint: purple,
                       background: fieldBG,
                       isSecure: true)

        Username.textContentType = .username
        Password.textContentType = .password
        Password.isSecureTextEntry = true
    }

    private func configureField(_ field: UITextField,
                                placeholder: String,
                                sfSymbol: String,
                                tint: UIColor,
                                background: UIColor,
                                isSecure: Bool) {

        field.borderStyle = .none
        field.backgroundColor = background
        field.layer.cornerRadius = 18
        field.clipsToBounds = true

        field.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [.foregroundColor: tint.withAlphaComponent(0.35)]
        )

        field.textColor = tint.withAlphaComponent(0.95)
        field.font = .systemFont(ofSize: 17, weight: .medium)

        // Left icon with padding
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
        let image = UIImage(systemName: sfSymbol, withConfiguration: config)?.withRenderingMode(.alwaysTemplate)

        let iconView = UIImageView(image: image)
        iconView.tintColor = tint.withAlphaComponent(0.85)
        iconView.contentMode = .scaleAspectFit

        let container = UIView(frame: CGRect(x: 0, y: 0, width: 44, height: 24))
        iconView.frame = CGRect(x: 16, y: 0, width: 18, height: 24)
        container.addSubview(iconView)

        field.leftView = container
        field.leftViewMode = .always

        field.autocorrectionType = .no
        field.autocapitalizationType = .none
        field.isSecureTextEntry = isSecure
    }

    // MARK: - Actions

    @IBAction func EnterButton(_ sender: Any) {
        // IMPORTANT:
        // If your Login button already has a storyboard segue to "homesegue",
        // DO NOT call performSegue here.
        // Validation happens in shouldPerformSegue.
        //
        // If you do NOT have a storyboard segue on the button,
        // then uncomment the following line:
        //
        // performSegue(withIdentifier: "homesegue", sender: sender)
    }

    // MARK: - UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == Username {
            Password.becomeFirstResponder()
        } else if textField == Password {
            textField.resignFirstResponder()
        }
        return true
    }

    // MARK: - Login Validation

    func validateLogin(username: String, password: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Parent")
        fetchRequest.predicate = NSPredicate(format: "username == %@ AND password == %@", username, password)

        do {
            let users = try context.fetch(fetchRequest)
            return !users.isEmpty
        } catch {
            print("Failed to fetch user: \(error)")
            return false
        }
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "homesegue" {

            // Prevent double-fire
            if isNavigating { return false }

            guard let username = Username.text,
                  let password = Password.text,
                  !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                  !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                presentAlert(message: "Please enter both username and password")
                return false
            }

            let valid = (username == defaultUsername && password == defaultPassword)
                        || validateLogin(username: username, password: password)

            if valid {
                isNavigating = true
                return true
            } else {
                presentAlert(message: "Invalid username or password")
                return false
            }
        }

        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homesegue",
           let destinationVC = segue.destination as? HomeViewController {
            destinationVC.user = Username.text ?? ""
        }
    }

    // MARK: - Keyboard

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }

        let keyboardHeight = keyboardFrame.height

        UIView.animate(withDuration: duration) {
            self.view.frame.origin.y = -keyboardHeight / 2
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }

        UIView.animate(withDuration: duration) {
            self.view.frame.origin.y = 0
        }
    }

    // MARK: - Alert

    func presentAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}

