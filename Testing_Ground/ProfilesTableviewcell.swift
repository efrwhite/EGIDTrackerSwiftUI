//
//  ProfilesTableviewcell.swift
//  Testing_Ground
//
//  Created by Brianna Boston on 10/4/23.
//

import UIKit

class ProfilesTableviewcell: UITableViewCell {

    @IBOutlet weak var editbutton: UIButton!
    @IBOutlet weak var addbutton: UIButton!
    @IBOutlet weak var namelabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
