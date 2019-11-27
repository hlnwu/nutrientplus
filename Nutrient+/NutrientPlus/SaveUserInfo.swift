//
//  SaveUserInfo.swift
//  NutrientPlus
//
//  Created by DSCommons on 11/26/19.
//  Copyright © 2019 hoo. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SaveUserInfo {
    func saveUserInfo(heightField: UITextField, weightField: UITextField, bodyFatField: UITextField, sex: UISegmentedControl, birthdayField: UITextField, heightUnit: UISegmentedControl, weightUnit: UISegmentedControl, userInfo: User, birthdate: Date, vc: UIViewController, segueIdentifier: String) {
        // storing data into Core Data only when fields aren't empty
        if heightField.text!.count != 0 && weightField.text!.count != 0
        && bodyFatField.text!.count != 0 && birthdayField.text!.count != 0 {
            // calculating height and storing it in centimeters
            let height = Int16(heightField.text!)!
            let heightUnitString = heightUnit.titleForSegment(at: heightUnit.selectedSegmentIndex)
            userInfo.height = height
                
            // calculating weight and storing it in kg
            let formatter = NumberFormatter()
            formatter.generatesDecimalNumbers = true
            let weight = formatter.number(from: weightField.text!) as? NSDecimalNumber ?? 0
            let weightUnitString = weightUnit.titleForSegment(at: weightUnit.selectedSegmentIndex)
            userInfo.weight = weight
            
            // storing the height and weight unit
            userInfo.heightUnit = heightUnitString
            userInfo.weightUnit = weightUnitString

            userInfo.bodyFat = formatter.number(from: bodyFatField.text!) as? NSDecimalNumber ?? 0
            userInfo.sex = sex.titleForSegment(at: sex.selectedSegmentIndex)
            userInfo.birthday = birthdate
            
            PersistenceService.saveContext()
            
            vc.performSegue(withIdentifier: segueIdentifier, sender: self)
        // alerts user if fields aren't all filled out
        } else {
            let emptyAlertController = UIAlertController(title:"Detected one or more empty fields", message: "Please fill in all the fields.", preferredStyle: .alert)
            emptyAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
            vc.present(emptyAlertController, animated: true)
            
        }
    }
}
