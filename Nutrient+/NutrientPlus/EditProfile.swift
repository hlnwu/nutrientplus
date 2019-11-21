//
//  EditProfile.swift
//  NutrientPlus
//
//  Created by hoo on 11/21/19.
//  Copyright © 2019 hoo. All rights reserved.
//

import Foundation
import UIKit

class EditProfile: UIViewController {
    
    @IBOutlet weak var heightField: UITextField!
    @IBOutlet weak var weightFIeld: UITextField!
    @IBOutlet weak var bodyFatField: UITextField!
    @IBOutlet weak var birthdayField: UITextField!
    @IBOutlet weak var sex: UISegmentedControl!
    @IBOutlet weak var heightUnit: UISegmentedControl!
    @IBOutlet weak var weightUnit: UISegmentedControl!
    
    // populate fields with previous user info
//    override func viewWillAppear() {
//        super.viewWillAppear(animated)
//    }
    
    // update user info with (newly?) inputted info
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
