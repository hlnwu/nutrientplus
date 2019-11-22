//
//  ViewControllerTemp.swift
//  Nutrient+
//
//  Created by Huanlei Wu on 10/20/19.
//  Copyright © 2019 Robert Sato. All rights reserved.
//
// Followed "iOS Text Field Tutorial - Accepting User Input" by Code Pro
// local database tutorial: https:// stackoverflow.com/questions/28628225/how-to-save-local-data-in-a-swift-app
//
// For birthday date user input tutorial:
// https: //www.youtube.com/watch?v=kML_2TkWEsk

import Foundation
import UIKit

//struct defaultsKeys {
//    static let heightKey = ""
//    static let weightKey = ""
//    static let bodyFatKey = ""
//}

class Startup: UIViewController {
    
    @IBOutlet weak var heightField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var bodyFatField: UITextField!
    @IBOutlet weak var birthdayField: UITextField!
    @IBOutlet weak var Gender: UISegmentedControl!
    @IBOutlet weak var heightUnit: UISegmentedControl!
    @IBOutlet weak var weightUnit: UISegmentedControl!
    
    var birthdate: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting the height, weight, and body fat fields to themselves to be able to manipulate variable
        heightField.delegate = self
        weightField.delegate = self
        bodyFatField.delegate = self
        
        // creating instance of date instance
        let datePicker = UIDatePicker()
        
        // set datepicker mode to date to just show date
        datePicker.datePickerMode = UIDatePicker.Mode.date
        
        // whenever datePicker value is changed, datePickerValueChanged function triggered
        datePicker.addTarget(self, action: #selector(Startup.datePickerValueChanged(sender:)), for: UIControl.Event.valueChanged)
        
        // show changed date in text field
        birthdayField.inputView = datePicker
        
        // store birthday to save in Core Data later
        birthdate = datePicker.date
        
        // Do any additional setup after loading the view, typically from a nib
    }
    
    @IBAction func storeVar(_ sender: Any) {
        // storing data into Core Data only when fields aren't empty
        if heightField.text!.count != 0 && weightField.text!.count != 0
            && bodyFatField.text!.count != 0 && birthdate != nil {
            // creating a user instance
            let user = User(context: PersistenceService.context)
            
            // calculating height and storing it in centimeters
            let rawHeight = Int16(heightField.text!)!
            print("height is",rawHeight)
            let heightUnitString = heightUnit.titleForSegment(at: heightUnit.selectedSegmentIndex)
            if heightUnitString == "in" {
                user.height = Int16(Double(rawHeight) * 2.54)
            } else {
                user.height = rawHeight
            }
                
            // calculating weight and storing it in kg
            let formatter = NumberFormatter()
            formatter.generatesDecimalNumbers = true
            let rawWeight = formatter.number(from: weightField.text!) as? NSDecimalNumber ?? 0
            //print("weight is: ", rawWeight)
            let weightUnitString = weightUnit.titleForSegment(at: weightUnit.selectedSegmentIndex)
            if weightUnitString == "lbs" {
                let divisor = NSDecimalNumber(0.453592)
                user.weight = rawWeight.multiplying(by: divisor)
                print("weight is : ",user.weight!)
            } else {
                user.weight = rawWeight
                print("weight is dnv : ",user.weight!)
            }
            
            // storing the height and weight unit
            user.heightUnit = heightUnitString
            user.weightUnit = weightUnitString

            user.bodyFat = formatter.number(from: bodyFatField.text!) as? NSDecimalNumber ?? 0
            user.sex = Gender.titleForSegment(at: Gender.selectedSegmentIndex)
            user.birthday = birthdate
            
            // sets userInfoExists to true so startup page doesn't display again
            UserDefaults.standard.set(true, forKey: "userInfoExists")
            
            PersistenceService.saveContext()
            
            performSegue(withIdentifier: "fieldsComplete", sender: self)
        // alerts user if fields aren't all filled out
        } else {
            let emptyAlertController = UIAlertController(title:"Detected one or more empty fields", message: "Please fill in all the fields.", preferredStyle: .alert)
            emptyAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
            present(emptyAlertController, animated: true)
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
    }
    
}

extension Startup: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // when text field is tapped, it is a first responder: accepting events, waiting for user input
        // resignFirstResponder() dismisses action hierarchy: text field disappear from view
        textField.resignFirstResponder()
        return true
    }
}
