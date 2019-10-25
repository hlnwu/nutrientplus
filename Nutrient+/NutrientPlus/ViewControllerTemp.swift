//
//  ViewControllerTemp.swift
//  Nutrient+
//
//  Created by Huanlei Wu on 10/20/19.
//  Copyright © 2019 Robert Sato. All rights reserved.
//
// Followed "iOS Text Field Tutorial - Accepting User Input" by Code Pro
// local database tutorial: https:// stackoverflow.com/questions/28628225/how-to-save-local-data-in-a-swift-app

import Foundation
import UIKit

struct defaultsKeys {
    static let heightKey = ""
    static let weightKey = ""
    static let bodyFatKey = ""
}

class ViewControllerTemp: UIViewController {
    
    @IBOutlet weak var heightField: UITextField!
    @IBOutlet weak var weightField: UITextField!
    @IBOutlet weak var bodyFatField: UITextField!
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        heightField.delegate = self
        weightField.delegate = self
        bodyFatField.delegate = self
        // Do any additional setup after loading the view, typically from a nib
    }
    
    @IBAction func storeVar(_ sender: Any) {
        // storing user input into local data temporarily
        // once Core Data is added, I'll put these into the CD DB
        let defaults = UserDefaults.standard
        defaults.set(heightField.text, forKey: defaultsKeys.heightKey)
        defaults.set(weightField.text, forKey: defaultsKeys.weightKey)
        defaults.set(bodyFatField.text, forKey: defaultsKeys.bodyFatKey)
    
        defaults.synchronize()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // when touch outside number pad field, number pad disappears
        heightField.resignFirstResponder()
        weightField.resignFirstResponder()
        bodyFatField.resignFirstResponder()
    }
}

extension ViewControllerTemp: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // when text field is tapped, it is a first responder: accepting events, waiting for user input
        // resignFirstResponder() dismisses action hierarchy: text field disappear from view
        textField.resignFirstResponder()
        return true
    }
}
