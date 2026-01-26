//
//  Diet6ViewController.swift
//  Testing_Ground
//
//  Created by Vivek Vangala on 2/1/24.
//

import Foundation
import UIKit
import CoreData

class Diet6ViewController: UIViewController {
    
    @IBOutlet weak var Diet6GoodView: UIView!
    @IBOutlet weak var Diet6BadView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var user = ""
    var userchild = ""
    var Diet6GoodViewController: Diet6GoodViewController?
    var Diet6BadViewController: Diet6BadViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .selected)
        
        // initial view at view load
        Diet6GoodView.isHidden = false
        Diet6BadView.isHidden = true
        
        // Get reference to child view controllers
        Diet6GoodViewController = children.first(where: { $0 is Diet6GoodViewController }) as? Diet6GoodViewController
        Diet6BadViewController = children.first(where: { $0 is Diet6BadViewController }) as? Diet6BadViewController
        
    }
   
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            Diet6GoodView.isHidden = false
            Diet6BadView.isHidden = true
        } else {
            Diet6GoodView.isHidden = true
            Diet6BadView.isHidden = false
        }
    }
}

