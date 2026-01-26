//
//import UIKit
//import CoreData
//
//protocol SymptomScoreViewControllerDelegate: AnyObject {
//    func symptomScoreViewController(_ controller: SymptomScoreViewController, didUpdateSymptomEntries entries: [Int64])
//}
//
//class SymptomScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SymTableViewCellDelegate {
//    weak var delegate: SymptomScoreViewControllerDelegate?
//    
//    let questions = [
//        "How often does your child have trouble swallowing?",
//        "How bad is your child's trouble swallowing?",
//        "How often does your child feel like food gets stuck in their throat or chest?",
//        "How bad is it when your child gets food stuck in their throat or chest?",
//        "How often does your child need to drink a lot to help them swallow food?",
//        "How bad is it when your child needs to drink a lot to help them swallow food?",
//        "How often does your child eat less than others?",
//        "How often does your child need more time to eat than others?",
//        "How often does your child have heartburn?",
//        "How bad is your child's heartburn (burning in the chest, mouth, or throat)?",
//        "How often does your child have food come back up in their throat when eating?",
//        "How bad is it when food comes back up in your child's throat?",
//        "How often does your child vomit (throw up)?",
//        "How bad is your child's vomiting?",
//        "How often does your child feel nauseous (feel like throwing up, but doesn't)?",
//        "How bad is your child's nausea (feel like throwing up, but doesn't)?",
//        "How often does your child have chest pain, ache, or hurt?",
//        "How bad is your child's chest pain, ache, or hurt?",
//        "How often does your child have stomach aches or belly aches?",
//        "How bad are your child's stomach aches or belly aches?"
//    ]
//    
//    let yesnoquestions = [
//        "Feeding is difficult/refuses food?",
//        "Slow eating",
//        "Prolonged chewing",
//        "Swallowing liquids with solid food",
//        "Avoidance of solid food",
//        "Retching",
//        "Choking",
//        "Food Impaction",
//        "Hoarseness",
//        "Constipation",
//        "Poor weight gain",
//        "Diarrhea"
//    ]
//    
//    var responses: [String?] = []
//    var yesnoResponses: [Bool] = []
//    var totalSymptomScore: Int64 = 0
//    
//    @IBOutlet weak var symptomTableView: UITableView!
//    @IBOutlet weak var yesNoTableView: UITableView!
//    @IBOutlet weak var saveButton: UIButton!
//    var childName = ""
//    var user = ""
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupTables()
//        responses = Array(repeating: nil, count: questions.count)
//        yesnoResponses = Array(repeating: false, count: yesnoquestions.count)
//        updateSaveButtonState()
//    }
//    
//    func setupTables() {
//        symptomTableView.register(UINib(nibName: "SymptomTableViewCell", bundle: nil), forCellReuseIdentifier: "SymptomTableViewCell")
//        symptomTableView.delegate = self
//        symptomTableView.dataSource = self
//        
//        yesNoTableView.register(UINib(nibName: "YesNoTableViewCell", bundle: nil), forCellReuseIdentifier: "YesNoTableViewCell")
//        yesNoTableView.delegate = self
//        yesNoTableView.dataSource = self
//    }
//    
//    func numberOfSections(in tableView: UITableView) -> Int { return 2 }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return section == 0 ? questions.count : yesnoquestions.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return indexPath.section == 0 ? setupSymptomTableViewCell(indexPath: indexPath) : setupYesNoTableViewCell(indexPath: indexPath)
//    }
//    
//    func setupSymptomTableViewCell(indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = symptomTableView.dequeueReusableCell(withIdentifier: "SymptomTableViewCell", for: indexPath) as? SymTableViewCell else {
//            fatalError("Expected SymptomTableViewCell")
//        }
//        cell.questionLabel.text = questions[indexPath.row]
//        cell.Ratingtext.text = responses[indexPath.row]
//        cell.delegate = self
//        cell.indexPath = indexPath
//        return cell
//    }
//    
//    func setupYesNoTableViewCell(indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = yesNoTableView.dequeueReusableCell(withIdentifier: "YesNoTableViewCell", for: indexPath) as? YesNoTableViewCell else {
//            fatalError("Expected YesNoTableViewCell")
//        }
//        cell.questionLabel.text = yesnoquestions[indexPath.row]
//        cell.yesNoSwitch.isOn = yesnoResponses[indexPath.row]
//        cell.indexPath = indexPath
//        
//        // ✅ Ensure switch value updates yesnoResponses
//        cell.yesNoSwitch.addTarget(self, action: #selector(yesNoSwitchChanged(_:)), for: .valueChanged)
//        
//        return cell
//    }
//    
//    @objc func yesNoSwitchChanged(_ sender: UISwitch) {
//        if let cell = sender.superview?.superview as? YesNoTableViewCell,
//           let indexPath = cell.indexPath {
//            yesnoResponses[indexPath.row] = sender.isOn
//            print("Switch changed at index \(indexPath.row), value: \(sender.isOn)")
//        }
//    }
//    
//    func didEditTextField(_ text: String, atIndexPath indexPath: IndexPath) {
//        if let value = Int(text), value >= 0, value <= 5 {
//            responses[indexPath.row] = text
//        } else {
//            responses[indexPath.row] = nil
//        }
//        updateSaveButtonState()
//    }
//    
//    func toggleSwitch(value: Bool, atIndexPath indexPath: IndexPath) {
//        yesnoResponses[indexPath.row] = value
//        print("Updated yesnoResponses:", yesnoResponses) // Debugging
//        updateSaveButtonState()
//    }
//    
//    
//    @IBAction func saveButtonTapped(_ sender: UIButton) {
//        totalSymptomScore = calculateTotalScore()
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        let newSymptomEntry = Symptom(context: context)
//
//        newSymptomEntry.symptomSum = totalSymptomScore
//        newSymptomEntry.date = Date()
//        newSymptomEntry.user = user
//        newSymptomEntry.childName = childName
//
//        let selectedYesNoQuestions = yesnoquestions
//            .enumerated()
//            .filter { yesnoResponses[$0.offset] }
//            .map { $0.element }
//            .joined(separator: ",")
//
//        print("✅ Selected Yes/No Questions:", selectedYesNoQuestions)
//        print("✅ User: \(user), Child Name: \(childName)") // ✅ Debugging Output
//
//        newSymptomEntry.yesnoquestion = selectedYesNoQuestions
//
//        do {
//            try context.save()
//        } catch {
//            print("Failed to save symptom entry: \(error)")
//        }
//
//        delegate?.symptomScoreViewController(self, didUpdateSymptomEntries: responses.compactMap { Int64($0 ?? "") })
//        
//        // ✅ Ensure user and childName are correctly passed
//        performSegue(withIdentifier: "ScoreResultSegue", sender: self)
//    }
//    
//    
//    @IBAction func resultsButtonTapped(_ sender: UIButton) {
//        print("✅ Results Button Tapped -> User: \(user), Child Name: \(childName)")
//        performSegue(withIdentifier: "ShowResultsSegue", sender: self)
//    }
//
//    private func calculateTotalScore() -> Int64 {
//        let symptomScores = responses.compactMap { Int64($0 ?? "0") }
//        let switchScores = yesnoResponses.map { $0 ? 1 : 0 }
//        return symptomScores.reduce(0, +) + Int64(switchScores.reduce(0, +))
//    }
//    
//    private func updateSaveButtonState() {
//        saveButton.isEnabled = !responses.contains(where: { $0 == nil })
//        saveButton.alpha = saveButton.isEnabled ? 1.0 : 0.5
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ScoreResultSegue",
//           let destinationVC = segue.destination as? ScoreViewController {
//            destinationVC.user = user
//            destinationVC.childName = childName
//            print("✅ Passing Data to ScoreViewController from Save -> User: \(user), Child Name: \(childName)")
//        }
//        
//        if segue.identifier == "ShowResultsSegue",
//           let destinationVC = segue.destination as? ScoreViewController {
//            destinationVC.user = user
//            destinationVC.childName = childName
//            print("✅ Passing Data to ScoreViewController from Results -> User: \(user), Child Name: \(childName)")
//        }
//    }
//
//
//}
//

import UIKit
import CoreData

protocol SymptomScoreViewControllerDelegate: AnyObject {
    func symptomScoreViewController(_ controller: SymptomScoreViewController, didUpdateSymptomEntries entries: [Int64])
}

class SymptomScoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SymTableViewCellDelegate {
    weak var delegate: SymptomScoreViewControllerDelegate?
    
    let questions = [
        "How often does your child have trouble swallowing?",
        "How bad is your child's trouble swallowing?",
        "How often does your child feel like food gets stuck in their throat or chest?",
        "How bad is it when your child gets food stuck in their throat or chest?",
        "How often does your child need to drink a lot to help them swallow food?",
        "How bad is it when your child needs to drink a lot to help them swallow food?",
        "How often does your child eat less than others?",
        "How often does your child need more time to eat than others?",
        "How often does your child have heartburn?",
        "How bad is your child's heartburn (burning in the chest, mouth, or throat)?",
        "How often does your child have food come back up in their throat when eating?",
        "How bad is it when food comes back up in your child's throat?",
        "How often does your child vomit (throw up)?",
        "How bad is your child's vomiting?",
        "How often does your child feel nauseous (feel like throwing up, but doesn't)?",
        "How bad is your child's nausea (feel like throwing up, but doesn't)?",
        "How often does your child have chest pain, ache, or hurt?",
        "How bad is your child's chest pain, ache, or hurt?",
        "How often does your child have stomach aches or belly aches?",
        "How bad are your child's stomach aches or belly aches?"
    ]
    
    let yesnoquestions = [
        "Feeding is difficult/refuses food?",
        "Slow eating",
        "Prolonged chewing",
        "Swallowing liquids with solid food",
        "Avoidance of solid food",
        "Retching",
        "Choking",
        "Food Impaction",
        "Hoarseness",
        "Constipation",
        "Poor weight gain",
        "Diarrhea"
    ]
    
    var responses: [String?] = []
    var yesnoResponses: [Bool] = []
    var totalSymptomScore: Int64 = 0
    
    @IBOutlet weak var symptomTableView: UITableView!
    @IBOutlet weak var yesNoTableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    var childName = ""
    var user = ""
    let headerText = "Please Insert the following based on questions below:\n0 = Not at all   -   4 = Very often"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTables()
        responses = Array(repeating: nil, count: questions.count)
        yesnoResponses = Array(repeating: false, count: yesnoquestions.count)
        updateSaveButtonState()
        setupKeyboardDismissal()

    }
    
    func setupTables() {
        symptomTableView.register(UINib(nibName: "SymptomTableViewCell", bundle: nil), forCellReuseIdentifier: "SymptomTableViewCell")
        symptomTableView.delegate = self
        symptomTableView.dataSource = self
        
        yesNoTableView.register(UINib(nibName: "YesNoTableViewCell", bundle: nil), forCellReuseIdentifier: "YesNoTableViewCell")
        yesNoTableView.delegate = self
        yesNoTableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { return 2 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? questions.count + 1 : yesnoquestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return setupHeaderCell(tableView: tableView)
            } else {
                return setupSymptomTableViewCell(indexPath: IndexPath(row: indexPath.row - 1, section: indexPath.section))
            }
        } else {
            return setupYesNoTableViewCell(indexPath: indexPath)
        }
    }

    
    func setupSymptomTableViewCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = symptomTableView.dequeueReusableCell(withIdentifier: "SymptomTableViewCell", for: indexPath) as? SymTableViewCell else {
            fatalError("Expected SymptomTableViewCell")
        }
        cell.questionLabel.text = questions[indexPath.row]
        cell.Ratingtext.text = responses[indexPath.row]
        cell.delegate = self
        cell.indexPath = indexPath
        return cell
    }
    func setupHeaderCell(tableView: UITableView) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "HeaderCell")
        cell.textLabel?.text = "Please Insert the following based on questions below:\n0 = Not at all ... 4 = Very often"
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        cell.textLabel?.textAlignment = .center
        cell.backgroundColor = UIColor.systemGray6
        return cell
    }

    func setupYesNoTableViewCell(indexPath: IndexPath) -> UITableViewCell {
        guard let cell = yesNoTableView.dequeueReusableCell(withIdentifier: "YesNoTableViewCell", for: indexPath) as? YesNoTableViewCell else {
            fatalError("Expected YesNoTableViewCell")
        }
        cell.questionLabel.text = yesnoquestions[indexPath.row]
        cell.yesNoSwitch.isOn = yesnoResponses[indexPath.row]
        cell.indexPath = indexPath
        
        // ✅ Ensure switch value updates yesnoResponses
        cell.yesNoSwitch.addTarget(self, action: #selector(yesNoSwitchChanged(_:)), for: .valueChanged)
        
        return cell
    }
    
    @objc func yesNoSwitchChanged(_ sender: UISwitch) {
        if let cell = sender.superview?.superview as? YesNoTableViewCell,
           let indexPath = cell.indexPath {
            yesnoResponses[indexPath.row] = sender.isOn
            print("Switch changed at index \(indexPath.row), value: \(sender.isOn)")
        }
    }
    
    func didEditTextField(_ text: String, atIndexPath indexPath: IndexPath) {
        if let value = Int(text), value >= 0, value <= 5 {
            responses[indexPath.row] = text
        } else {
            responses[indexPath.row] = nil
        }
        updateSaveButtonState()
    }
    
    func toggleSwitch(value: Bool, atIndexPath indexPath: IndexPath) {
        yesnoResponses[indexPath.row] = value
        print("Updated yesnoResponses:", yesnoResponses) // Debugging
        updateSaveButtonState()
    }
    
    // MARK: - Keyboard Handling
        func setupKeyboardDismissal() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tapGesture)
        }
        
        @objc func dismissKeyboard() {
            view.endEditing(true)
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        totalSymptomScore = calculateTotalScore()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let newSymptomEntry = Symptom(context: context)

        newSymptomEntry.symptomSum = totalSymptomScore
        newSymptomEntry.date = Date()
        newSymptomEntry.user = user
        newSymptomEntry.childName = childName

        let selectedYesNoQuestions = yesnoquestions
            .enumerated()
            .filter { yesnoResponses[$0.offset] }
            .map { $0.element }
            .joined(separator: ",")

        print("✅ Selected Yes/No Questions:", selectedYesNoQuestions)
        print("✅ User: \(user), Child Name: \(childName)") // ✅ Debugging Output

        newSymptomEntry.yesnoquestion = selectedYesNoQuestions

        do {
            try context.save()
        } catch {
            print("Failed to save symptom entry: \(error)")
        }

        delegate?.symptomScoreViewController(self, didUpdateSymptomEntries: responses.compactMap { Int64($0 ?? "") })
        
        // ✅ Ensure user and childName are correctly passed
        //performSegue(withIdentifier: "SymptomResultSegue", sender: self)
    }
    
    
    @IBAction func resultsButtonTapped(_ sender: UIButton) {
        print("✅ Results Button Tapped -> User: \(user), Child Name: \(childName)")
        performSegue(withIdentifier: "ShowResultsSegue", sender: self)
    }

    private func calculateTotalScore() -> Int64 {
        let symptomScores = responses.compactMap { Int64($0 ?? "0") }
        let switchScores = yesnoResponses.map { $0 ? 1 : 0 }
        return symptomScores.reduce(0, +) + Int64(switchScores.reduce(0, +))
    }
    
    private func updateSaveButtonState() {
        saveButton.isEnabled = !responses.contains(where: { $0 == nil })
        saveButton.alpha = saveButton.isEnabled ? 1.0 : 0.5
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SymptomResultSegue",
           let destinationVC = segue.destination as? ScoreViewController {
            destinationVC.user = user
            destinationVC.childName = childName
            print("✅ Passing Data to ScoreViewController from Save -> User: \(user), Child Name: \(childName)")
        }
        
        if segue.identifier == "ShowResultsSegue",
           let destinationVC = segue.destination as? ScoreViewController {
            destinationVC.user = user
            destinationVC.childName = childName
            print("✅ Passing Data to ScoreViewController from Results -> User: \(user), Child Name: \(childName)")
        }
    }


}

