//
//  ParentTableViewCell.swift
//  Testing_Ground
//
//  Created by Brianna Boston on 10/6/23.
//

import UIKit

class ParentTableViewCell: UITableViewCell {

    @IBOutlet weak var editbutton: UIButton!
    @IBOutlet weak var addbutton: UIButton!
    @IBOutlet weak var parentname: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
