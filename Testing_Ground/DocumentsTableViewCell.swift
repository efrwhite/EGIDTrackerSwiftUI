//
//  DocumentTableViewCell.swift
//  Testing_Ground
//
//  Created by Vivek Vangala on 1/29/24.
//

import Foundation
import UIKit

class DocumentTableViewCell: UITableViewCell {
    var editButtonAction: (() -> Void)?

    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit", for: .normal)
        
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupEditButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupEditButton()
    }

    private func setupEditButton() {
        contentView.addSubview(editButton)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            editButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            editButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            editButton.widthAnchor.constraint(equalToConstant: 50),
            editButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }

    @objc private func editButtonTapped() {
        editButtonAction?()
    }
}


