//
//  Diet2ViewController.swift
//  Testing_Ground
//
//  Created by Vivek Vangala on 2/1/24.
//

import Foundation
import UIKit
import CoreData

class Diet2ViewController: UIViewController {
    
    @IBOutlet weak var Diet2GoodView: UIView!
    @IBOutlet weak var Diet2BadView: UIView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var user = ""
    var userchild = ""
    var Diet2GoodViewController: Diet2GoodViewController?
    var Diet2BadViewController: Diet2BadViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .selected)
        
        // initial view at view load
        Diet2GoodView.isHidden = false
        Diet2BadView.isHidden = true
        
        // Get reference to child view controllers
        Diet2GoodViewController = children.first(where: { $0 is Diet2GoodViewController }) as? Diet2GoodViewController
        Diet2BadViewController = children.first(where: { $0 is Diet2BadViewController }) as? Diet2BadViewController
        
    }
   
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            Diet2GoodView.isHidden = false
            Diet2BadView.isHidden = true
        } else {
            Diet2GoodView.isHidden = true
            Diet2BadView.isHidden = false
        }
    }
}

