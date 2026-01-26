//
//  HowItsDiagnosedViewController.swift
//  Testing_Ground
//
//  Created by Vivek Vangala on 7/17/23.
//
//Quick change

import UIKit

class HowItsDiagnosedViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        
        
        // Set the label's text to wrap and display the full content
        label1.numberOfLines = 0
        label1.lineBreakMode = .byWordWrapping
        
        // Add the label and image to the scrollView's content view
        scrollView.addSubview(label1)
        scrollView.addSubview(imageView)
        
        // Set constraints for the label and image
        label1.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Label constraints
            label1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.0),
            label1.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16.0),
            label1.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.0),
            label1.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32.0), // Adjust the constant as needed
            
            // Image constraints (adjust these as needed)
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.0),
            imageView.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 16.0),
            imageView.widthAnchor.constraint(equalToConstant: 200.0), // Adjust the width
            imageView.heightAnchor.constraint(equalToConstant: 200.0), // Adjust the height
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16.0),
        ])
        
        // Update the scrollView's contentSize to fit the label's frame and image
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: label1.frame.size.height + imageView.frame.size.height + 32.0) // Adjust the padding as needed
    }
}
