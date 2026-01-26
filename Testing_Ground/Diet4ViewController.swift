//
//  Diet4ViewController.swift
//  Testing_Ground
//
//  Created by Vivek Vangala on 2/1/24.
//

import Foundation
import UIKit
import CoreData

class Diet4ViewController: UIViewController {
    
    @IBOutlet weak var Diet4GoodView: UIView!
    @IBOutlet weak var Diet4BadView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var user = ""
    var userchild = ""
    var Diet4GoodViewController: Diet4GoodViewController?
    var Diet4BadViewController: Diet4BadViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .selected)
        
        // initial view at view load
        Diet4GoodView.isHidden = false
        Diet4BadView.isHidden = true
        
        // Get reference to child view controllers
        Diet4GoodViewController = children.first(where: { $0 is Diet4GoodViewController }) as? Diet4GoodViewController
        Diet4BadViewController = children.first(where: { $0 is Diet4BadViewController }) as? Diet4BadViewController
        
    }
   
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            Diet4GoodView.isHidden = false
            Diet4BadView.isHidden = true
        } else {
            Diet4GoodView.isHidden = true
            Diet4BadView.isHidden = false
        }
    }
}

