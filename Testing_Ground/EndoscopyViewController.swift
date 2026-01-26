import UIKit
import CoreData

class EndoscopyViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var saveButton: UIButton!
    var user = ""
    var childName = ""
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let eoELabel: UILabel = {
        let label = UILabel()
        label.text = "EoE: "
        label.textColor = .black
        return label
    }()
    
    let procedureDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Procedure Date:"
        label.textColor = .black
        return label
    }()
    
    let procedureDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()
    
    let proximateTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Upper:"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let middleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Middle:"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let lowerTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Lower:"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let stomachLabel: UILabel = {
        let label = UILabel()
        label.text = "Stomach: "
        label.textColor = .black
        return label
    }()
    
    let stomachTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let duodenumLabel: UILabel = {
        let label = UILabel()
        label.text = "Duodenum: "
        label.textColor = .black
        return label
    }()
    
    let duodenumTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let colonLabel: UILabel = {
        let label = UILabel()
        label.text = "Colon: "
        label.textColor = .black
        return label
    }()
    let noteLabel: UILabel = {
        let label = UILabel()
        label.text = "Notes: "
        label.textColor = .black
        return label
    }()
    let notesField: UITextView = {
        let textview = UITextView()
        textview.isEditable = true
        textview.isScrollEnabled = true
        textview.layer.borderWidth = 1
        textview.layer.borderColor = UIColor.lightGray.cgColor
        textview.layer.cornerRadius = 5
        textview.translatesAutoresizingMaskIntoConstraints = false
        return textview
    }()

    
    let rightColonTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Right:"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let middleColonTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Middle:"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    let leftColonTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Left:"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .numberPad
        return textField
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboardObservers()
        print("Child Name in Endoscopy View: ", childName)
        print("User in Endoscopy View: ", user)
        
        // Add "Results" button to the navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Results", style: .plain, target: self, action: #selector(resultsButtonTapped))
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup UI
    
    func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(mainStackView)
        
        
        mainStackView.addArrangedSubview(procedureDateLabel)
        mainStackView.addArrangedSubview(procedureDatePicker)
        mainStackView.addArrangedSubview(eoELabel)
        mainStackView.addArrangedSubview(proximateTextField)
        mainStackView.addArrangedSubview(middleTextField)
        mainStackView.addArrangedSubview(lowerTextField)
        mainStackView.addArrangedSubview(stomachLabel)
        mainStackView.addArrangedSubview(stomachTextField)
        mainStackView.addArrangedSubview(duodenumLabel)
        mainStackView.addArrangedSubview(duodenumTextField)
        mainStackView.addArrangedSubview(colonLabel)
        mainStackView.addArrangedSubview(rightColonTextField)
        mainStackView.addArrangedSubview(middleColonTextField)
        mainStackView.addArrangedSubview(leftColonTextField)
        mainStackView.addArrangedSubview(noteLabel)
        mainStackView.addArrangedSubview(notesField) //why not showing?
        mainStackView.addArrangedSubview(saveButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            notesField.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        let keyboardHeight = keyboardFrame.height
        let bottomSafeAreaInset = view.safeAreaInsets.bottom
        
        UIView.animate(withDuration: duration) {
            self.scrollView.contentInset.bottom = keyboardHeight - bottomSafeAreaInset
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        UIView.animate(withDuration: duration) {
            self.scrollView.contentInset.bottom = 0
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Button Actions
    
    @objc func resultsButtonTapped() {
        let resultsVC = EndoscopyResultsViewController()
        resultsVC.user = user
        resultsVC.childName = childName
        navigationController?.pushViewController(resultsVC, animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        saveEndoscopyResults()
        
        // Perform the segue to the next screen and pass data
//        performSegue(withIdentifier: "showResults", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showResults" {
            if let resultsVC = segue.destination as? EndoscopyResultsViewController {
                resultsVC.user = user
                resultsVC.childName = childName
            }
        }
    }

    //CORE DATA SAVE
    func saveEndoscopyResults() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext

        let entity = NSEntityDescription.entity(forEntityName: "Endoscopy", in: context)!
        let newEndoscopyResult = NSManagedObject(entity: entity, insertInto: context)

        newEndoscopyResult.setValue(childName, forKey: "childName")
        newEndoscopyResult.setValue(user, forKey: "user")
        newEndoscopyResult.setValue(procedureDatePicker.date, forKey: "procedureDate")
        newEndoscopyResult.setValue(Int(proximateTextField.text ?? "0"), forKey: "upper")
        newEndoscopyResult.setValue(Int(middleTextField.text ?? "0"), forKey: "middle")
        newEndoscopyResult.setValue(Int(lowerTextField.text ?? "0"), forKey: "lower")
        newEndoscopyResult.setValue(Int(stomachTextField.text ?? "0"), forKey: "stomach")
        newEndoscopyResult.setValue(Int(duodenumTextField.text ?? "0"), forKey: "duodenum")
        newEndoscopyResult.setValue(Int(rightColonTextField.text ?? "0"), forKey: "rightColon")
        newEndoscopyResult.setValue(Int(middleColonTextField.text ?? "0"), forKey: "middleColon")
        newEndoscopyResult.setValue(Int(leftColonTextField.text ?? "0"), forKey: "leftColon")
        //notes add to core data
        newEndoscopyResult.setValue(notesField.text, forKey: "notes")

        do {
            try context.save()
            print("Endoscopy results saved successfully.")
        } catch {
            print("Failed to save endoscopy results: \(error)")
        }
    }
}
