//import UIKit
//
//protocol SymTableViewCellDelegate: AnyObject {
//    func didEditTextField(_ text: String, atIndexPath indexPath: IndexPath)
//}
//
//class SymTableViewCell: UITableViewCell, UITextFieldDelegate {
//    
//    @IBOutlet weak var questionLabel: UILabel!
//    @IBOutlet weak var Ratingtext: UITextField!
//    @IBOutlet weak var yesNoSwitch: UISwitch!
//    
//    weak var delegate: SymTableViewCellDelegate?
//    var indexPath: IndexPath?
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//
//        if let ratingText = Ratingtext {
//            ratingText.delegate = self
//            ratingText.keyboardType = .numberPad
//            ratingText.font = UIFont.systemFont(ofSize: 17)
//        }
//
//        if let questionLbl = questionLabel {
//            questionLbl.font = UIFont.systemFont(ofSize: 14)
//        }
//        
//        yesNoSwitch?.isOn = false
//        yesNoSwitch?.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
//    }
//    
//    func configureCell(for section: Int) {
//        if section == 0 {
//            Ratingtext.isHidden = false
//            yesNoSwitch.isHidden = true
//        } else if section == 1 {
//            Ratingtext.isHidden = true
//            yesNoSwitch.isHidden = false
//            yesNoSwitch.isUserInteractionEnabled = true  // Ensure switch is interactable
//        }
//    }
//    
//    @objc func switchChanged(_ sender: UISwitch) {
//        if let indexPath = indexPath {
//            delegate?.didEditTextField(sender.isOn ? "1" : "0", atIndexPath: indexPath)
//        }
//    }
//    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        if let text = textField.text, let indexPath = indexPath {
//            let validatedText = validateInput(text: text, section: indexPath.section)
//            textField.text = validatedText
//            delegate?.didEditTextField(validatedText, atIndexPath: indexPath)
//        }
//    }
//
//    private func validateInput(text: String, section: Int) -> String {
//        guard let number = Int(text) else { return "" }
//
//        if section == 0 {
//            return (0...5).contains(number) ? text : ""
//        } else if section == 1 {
//            return (0...1).contains(number) ? text : ""
//        }
//
//        return ""
//    }
//}


import UIKit

protocol SymTableViewCellDelegate: AnyObject {
    func didEditTextField(_ text: String, atIndexPath indexPath: IndexPath)
}

class SymTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var Ratingtext: UITextField!
    
    weak var delegate: SymTableViewCellDelegate?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        if let ratingText = Ratingtext {
            ratingText.delegate = self
            ratingText.keyboardType = .numberPad
            ratingText.font = UIFont.systemFont(ofSize: 17)
            ratingText.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }

        if let questionLbl = questionLabel {
            questionLbl.font = UIFont.systemFont(ofSize: 14)
        }
    }
    
    func configureCell(for section: Int) {
        Ratingtext.isHidden = section != 0
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, let indexPath = indexPath {
            delegate?.didEditTextField(text, atIndexPath: indexPath)
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, let indexPath = indexPath {
            let validatedText = validateInput(text: text)
            textField.text = validatedText
            delegate?.didEditTextField(validatedText, atIndexPath: indexPath)
        }
    }

    private func validateInput(text: String) -> String {
        guard let number = Int(text) else { return "" }
        return (0...5).contains(number) ? text : ""
    }
}
