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

struct defaultsKeys {
    static let heightKey = ""
    static let weightKey = ""
    static let bodyFatKey = ""
}

class Startup: UIViewController {
    
    @IBOutlet weak var heightField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var bodyFatField: UITextField!
    @IBOutlet weak var birthdayField: UITextField!
    
    @IBOutlet weak var Gender: UISegmentedControl!
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let Destvc = segue.destination as! ViewController
        
        
        let myFloat = (heightField.text! as NSString).floatValue
        let weightFloat = (weightField.text! as NSString).floatValue
        Destvc.height=myFloat
        Destvc.weight=weightFloat
        Destvc.tester="changed"
        let title = Gender.titleForSegment(at: Gender.selectedSegmentIndex)
        Destvc.gender=title!
        
        
        
    
    }
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
        
        // Do any additional setup after loading the view, typically from a nib
    }
    
    @IBAction func storeVar(_ sender: Any) {
        // storing user input into local data temporarily
//        let defaults = UserDefaults.standard
//        defaults.set(heightField.text, forKey: defaultsKeys.heightKey)
//        defaults.set(weightField.text, forKey: defaultsKeys.weightKey)
//        defaults.set(bodyFatField.text, forKey: defaultsKeys.bodyFatKey)
//
//        defaults.synchronize()
        
        // storing data into Core Data
        if heightField.text!.count != 0 && weightField.text!.count != 0
            && bodyFatField.text!.count != 0 {
            let user = User(context: PersistenceService.context)
            user.height = Int16(heightField.text!)!
            user.weight = NumberFormatter().number(from: heightField.text!) as? NSDecimalNumber
            user.bodyFat = NumberFormatter().number(from: heightField.text!) as? NSDecimalNumber
            
            PersistenceService.saveContext()
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
