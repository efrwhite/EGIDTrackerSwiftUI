import UIKit

class QualityofLifeTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var ratingText: UITextField!
    @IBOutlet weak var questionlabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Ensure the outlets are connected before setting their properties
        if let ratingTextField = ratingText, let questionTextLabel = questionlabel {
            ratingTextField.delegate = self  // Set the cell as the delegate for the text field
            ratingTextField.keyboardType = .numberPad  // Ensure the keyboard is suitable for number input
            ratingTextField.font = UIFont.systemFont(ofSize: 17)  // Adjust the font size as needed

            questionTextLabel.font = UIFont.systemFont(ofSize: 16) // Adjust the font size for the question label
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text {
            let validatedText = validateInput(text: text)
            textField.text = validatedText
            // If you have a delegate method to handle the updated text, call it here
            // delegate?.didEditTextField(validatedText, atIndexPath: indexPath)
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    private func validateInput(text: String) -> String {
        guard let number = Int(text) else { return "" }
        return (0...4).contains(number) ? text : ""
    }
}
