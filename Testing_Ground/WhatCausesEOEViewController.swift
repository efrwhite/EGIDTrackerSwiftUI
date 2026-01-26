//
//  WhatCausesEOEViewController.swift
//  Testing_Ground
//
//  Created by Vivek Vangala on 7/17/23.
//

import UIKit

class WhatCausesEOEViewController: UIViewController {
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Set the label's text to wrap and display the full content
        label1.numberOfLines = 0
        label1.lineBreakMode = .byWordWrapping
        
        
        // Add the label to the scrollView's content view
        scrollView.addSubview(label1)
        
        // Set constraints for the label
        label1.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Label constraints
            label1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.0),
            label1.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16.0),
            label1.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.0),
            label1.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32.0), // Adjust the constant as needed
        ])
        
        // Update the scrollView's contentSize to fit the label's frame
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: label1.frame.size.height + 32.0) // Adjust the padding as needed
    }
}
