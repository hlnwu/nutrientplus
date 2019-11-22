//
//  EditProfile.swift
//  NutrientPlus
//
//  Created by hoo on 11/21/19.
//  Copyright © 2019 hoo. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class EditProfile: UIViewController {
    
    @IBOutlet weak var heightField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var bodyFatField: UITextField!
    @IBOutlet weak var birthdayField: UITextField!
    @IBOutlet weak var sex: UISegmentedControl!
    @IBOutlet weak var heightUnit: UISegmentedControl!
    @IBOutlet weak var weightUnit: UISegmentedControl!
    
    var birthdateRevised: Date!
    var user = [User]()
    
    // populate fields with previous user info
//    override func viewWillAppear() {
//        super.viewWillAppear(animated)
//    }
    
    // update user info with (newly?) inputted info
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting the height, weight, and body fat fields to themselves to be able to manipulate variable
        heightField.delegate = self
        weightField.delegate = self
        bodyFatField.delegate = self
        
        // old values as default in text field
        self.retrieveCoreData()
        
        // creating instance of date instance
        let datePicker = UIDatePicker()
        
        // set datepicker mode to date to just show date
        datePicker.datePickerMode = UIDatePicker.Mode.date
        
        // whenever datePicker value is changed, datePickerValueChanged function triggered
        datePicker.addTarget(self, action: #selector(EditProfile.datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
        
        // show changed date in text field
        birthdayField.inputView = datePicker
        
        // store birthday to save in Core Data later
        //birthdate = datePicker.date
        
        // Do any additional setup after loading the view, typically from a nib
    }
    
    // inputs current user info as default values in the edit page
    func retrieveCoreData() {
        let fetchUserDataRequest = NSFetchRequest<User>(entityName: "User")
        do {
            let user = try PersistenceService.context.fetch(fetchUserDataRequest)
            
            self.user = user
            
            let userSize = user.count
            let userInfo = user[userSize - 1]
            
            // place all user info into variables for easy access
            let height = userInfo.height
            let weight = userInfo.weight
            let bodyFat = userInfo.bodyFat
            let birthday = userInfo.birthday
            let sex = userInfo.sex
            let heightUnit = userInfo.heightUnit
            let weightUnit = userInfo.weightUnit
            
            // current user info placed into text field
            heightField.text = String(height)
            weightField.text = NSDecimalNumber(decimal: weight! as Decimal).stringValue
            bodyFatField.text = NSDecimalNumber(decimal: bodyFat! as Decimal).stringValue
            
            let formatter = DateFormatter()
            formatter.dateStyle = DateFormatter.Style.medium
            formatter.timeStyle = DateFormatter.Style.none
            birthdayField.text = formatter.string(from: birthday!)
            birthdateRevised = birthday
            
            if sex == "Female" {
                self.sex.selectedSegmentIndex = 0
            } else {
                self.sex.selectedSegmentIndex = 1
            }
            
            if heightUnit == "in" {
                self.heightUnit.selectedSegmentIndex = 0
            } else {
                self.heightUnit.selectedSegmentIndex = 1
            }
            
            if weightUnit == "lbs" {
                self.weightUnit.selectedSegmentIndex = 0
            } else {
                self.weightUnit.selectedSegmentIndex = 1
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func changeProfile(_ sender: Any) {
        let fetchUserDataRequest = NSFetchRequest<User>(entityName: "User")
        do {
            let user = try PersistenceService.context.fetch(fetchUserDataRequest)
            
            self.user = user
            let userSize = user.count
            let userInfo = user[userSize - 1]
            
            // storing data into Core Data only when fields aren't empty
            if heightField.text!.count != 0 && weightField.text!.count != 0
            && bodyFatField.text!.count != 0 && birthdayField.text!.count != 0 {
                // calculating height and storing it in centimeters
                let rawHeight = Int16(heightField.text!)!
                let heightUnitString = heightUnit.titleForSegment(at: heightUnit.selectedSegmentIndex)
                if heightUnitString == "in" {
                    userInfo.height = Int16(Double(rawHeight) * 2.54)
                } else {
                    userInfo.height = rawHeight
                }
                    
                // calculating weight and storing it in kg
                let formatter = NumberFormatter()
                formatter.generatesDecimalNumbers = true
                let rawWeight = formatter.number(from: weightField.text!) as? NSDecimalNumber ?? 0
                let weightUnitString = weightUnit.titleForSegment(at: weightUnit.selectedSegmentIndex)
                if weightUnitString == "lbs" {
                    let divisor = NSDecimalNumber(0.453592)
                    userInfo.weight = rawWeight.multiplying(by: divisor)
                } else {
                  userInfo.weight = rawWeight
                }
                
                // storing the height and weight unit
                userInfo.heightUnit = heightUnitString
                userInfo.weightUnit = weightUnitString

                userInfo.bodyFat = formatter.number(from: bodyFatField.text!) as? NSDecimalNumber ?? 0
                userInfo.sex = sex.titleForSegment(at: sex.selectedSegmentIndex)
                userInfo.birthday = birthdateRevised
                
                PersistenceService.saveContext()
                
                performSegue(withIdentifier: "doneEditing", sender: self)
            // alerts user if fields aren't all filled out
            } else {
                let emptyAlertController = UIAlertController(title:"Detected one or more empty fields", message: "Please fill in all the fields.", preferredStyle: .alert)
                emptyAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
                present(emptyAlertController, animated: true)
                
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            // when touch outside number pad field, number pad disappears
            heightField.resignFirstResponder()
            weightField.resignFirstResponder()
            bodyFatField.resignFirstResponder()
            birthdayField.resignFirstResponder()
            view.endEditing(true)
    }
        
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        // create DateFormatter instance
        let formatter = DateFormatter()
        
        formatter.dateStyle = DateFormatter.Style.medium
        
        // don't show time, only date
        formatter.timeStyle = DateFormatter.Style.none
        
        birthdayField.text = formatter.string(from: sender.date)
        
        birthdateRevised = sender.date
    }
    
}

extension EditProfile: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // when text field is tapped, it is a first responder: accepting events, waiting for user input
        // resignFirstResponder() dismisses action hierarchy: text field disappear from view
        textField.resignFirstResponder()
        return true
    }
}
