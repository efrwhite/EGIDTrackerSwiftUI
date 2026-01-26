//
//  YesNoTableViewCell.swift
//  Testing_Ground
//
//  Created by Vivek Vangala on 10/1/24.
//

import Foundation
import UIKit

protocol YesNoTableViewCellDelegate: AnyObject {
    func didChangeSwitch(_ isOn: Bool, atIndexPath indexPath: IndexPath)
}

class YesNoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var yesNoSwitch: UISwitch!
    
    weak var delegate: YesNoTableViewCellDelegate?
    var indexPath: IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        yesNoSwitch?.isOn = false
        yesNoSwitch?.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged)
    }
    
    func configureCell(for section: Int) {
            yesNoSwitch.isHidden = section != 1
        }
        
        @objc func switchChanged(_ sender: UISwitch) {
            if let indexPath = indexPath {
                delegate?.didChangeSwitch(sender.isOn, atIndexPath: indexPath)
            }
        }
    }
