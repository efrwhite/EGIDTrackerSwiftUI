//
//  WhatIsEOEViewController.swift
//  Testing_Ground
//
//  Created by Vivek Vangala on 7/17/23.
//  Editted By Brianna Boston on Sept 10th
//
import UIKit

class WhatIsEOEViewController: UIViewController {
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    
    override func viewDidLoad() {
            super.viewDidLoad()
            
            // Set the label's text to wrap and display the full content
            label1.numberOfLines = 0
            label1.lineBreakMode = .byWordWrapping
            label1.textAlignment = .left
            label1.sizeToFit()
            
            // Add the label to the scrollView's content view
            scrollView.addSubview(label1)
            
            // Add image views to the scrollView's content view
            scrollView.addSubview(imageView1)
            scrollView.addSubview(imageView2)
            scrollView.addSubview(imageView3)
            
            // Disable autoresizing mask for all views
            label1.translatesAutoresizingMaskIntoConstraints = false
            imageView1.translatesAutoresizingMaskIntoConstraints = false
            imageView2.translatesAutoresizingMaskIntoConstraints = false
            imageView3.translatesAutoresizingMaskIntoConstraints = false
            
            // Set constraints for the label
            NSLayoutConstraint.activate([
                // Label constraints
                label1.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.0),
                label1.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16.0),
                label1.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.0),
                label1.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -32.0),
                
                // ImageView1 constraints (centered between Label1 and Label2)
                           imageView1.topAnchor.constraint(equalTo: label1.bottomAnchor, constant: 13.0),
                           imageView1.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
                           imageView1.widthAnchor.constraint(equalToConstant: 150.0),
                           imageView1.heightAnchor.constraint(equalToConstant: 125.0),
                           
                           // Label 2 constraints (below ImageView1)
                           label2.topAnchor.constraint(equalTo: imageView1.bottomAnchor, constant: 16.0),
                           label2.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.0),
                           label2.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.0),
                           
                           // ImageView2 constraints (bottom left, below Label 2)
                           imageView2.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: 16.0),
                           imageView2.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.0),
                           imageView2.widthAnchor.constraint(equalToConstant: 150.0),
                           imageView2.heightAnchor.constraint(equalToConstant: 150.0),
                           
                           // ImageView3 constraints (bottom right, below Label 2)
                           imageView3.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: 16.0),
                           imageView3.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.0),
                           imageView3.widthAnchor.constraint(equalToConstant: 150.0),
                           imageView3.heightAnchor.constraint(equalToConstant: 150.0),
                           
                           // Bottom of scrollView (account for padding)
                           imageView3.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16.0)
                       ])
            
            // Update the scrollView's contentSize dynamically
            DispatchQueue.main.async {
                let contentHeight = self.label1.frame.height + self.imageView1.frame.height + self.imageView2.frame.height + self.imageView3.frame.height + 80.0 // Adding padding
                self.scrollView.contentSize = CGSize(width: self.scrollView.frame.width, height: contentHeight)
            }
        }
    }
