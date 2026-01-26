////
////  ProfileViewController.swift
////  EOEPractice
////
////  Created by Brianna Boston on 6/6/23.
////
//
//import Foundation
//import UIKit
//import CoreData
//
//class ProfileViewController: UIViewController, UITextFieldDelegate{
//    @IBOutlet weak var username: UITextField!
//    @IBOutlet weak var FirstName: UITextField!
//    @IBOutlet weak var lastname: UITextField!
//    @IBOutlet weak var diettype: UIButton!
//    @IBOutlet weak var gender: UIButton!
//    @IBOutlet weak var birthday: UIDatePicker!
//    @IBOutlet weak var image: UIImageView!
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    var receivedString = ""
//    var profiles = [Parent]()
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        receivedString = username.text!
//    }
//    
//    @IBAction func CreateProfile(_ sender: Any) {
//        //Core Data
//        let newProfile = Parent(context: self.context)
//        newProfile.firstname = FirstName.text!
//        newProfile.lastname = lastname.text!
//        newProfile.birthday = birthday.date
//        newProfile.gender = gender.currentTitle
//        newProfile.diettype = diettype.currentTitle
//        newProfile.account = username.text!
//        
//        self.profiles.append(newProfile)
//        self.saveItems()
//        var receivedString = username.text!
//    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if (segue.identifier == "parentSegue"){
//            let displayVC = segue.destination as! ParentViewController
//            displayVC.user = receivedString
//            
//        }
//    }
//    func saveItems(){
//        do{
//            try context.save()
//        }catch{
//            print("Error Saving")
//        }
//    }
//    
//}
