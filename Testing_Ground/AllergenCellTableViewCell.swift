import UIKit

class AllergenCell: UITableViewCell {

    @IBOutlet weak var allergenNameLabel: UILabel!
    @IBOutlet weak var allergyTypeLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
