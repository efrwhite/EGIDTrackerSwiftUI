import UIKit

class DocumentTableViewCell: UITableViewCell {
    
    var editButtonTapped: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupEditButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupEditButton()
    }
    
    func setupEditButton() {
        let editButton = UIButton(type: .system)
        editButton.setTitle("Edit", for: .normal)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        
        contentView.addSubview(editButton)
        
        NSLayoutConstraint.activate([
            editButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            editButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    @objc func editButtonPressed() {
        editButtonTapped?()
    }
}
