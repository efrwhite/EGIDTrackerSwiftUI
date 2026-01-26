import UIKit
import CoreData

class ExposureTableViewCell: UITableViewCell {
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let itemLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var isExpanded: Bool = false {
        didSet {
            descriptionLabel.isHidden = !isExpanded
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(dateLabel)
        addSubview(itemLabel)
        addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            itemLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 10),
            itemLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            itemLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            
            descriptionLabel.topAnchor.constraint(equalTo: itemLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
        
        descriptionLabel.isHidden = true
    }
    
    func configure(with exposure: NSManagedObject, isExpanded: Bool) {
        let date = exposure.value(forKey: "date") as! Date
        let item = exposure.value(forKey: "item") as! String
        let description = exposure.value(forKey: "desc") as! String
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        let dateString = dateFormatter.string(from: date)
        
        dateLabel.text = "Date: \(dateString)"
        itemLabel.text = "Item: \(item)"
        descriptionLabel.text = "Description: \(description)"
        
        self.isExpanded = isExpanded
    }
}
