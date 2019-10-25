//
//  EditInfoVC.swift
//  NutrientPlus
//
//  Created by Robert Sato on 10/22/19.
//  Copyright © 2019 hoo. All rights reserved.
//

import Foundation
import UIKit

class EditInfoVC: UIViewController {
    
    
    @IBOutlet weak var updatedCalories: UITextField!
    var calorieValue = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func done(_ sender: Any) {
        self.calorieValue = updatedCalories.text!
        performSegue(withIdentifier: "editToMain", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ViewController
        vc.calories = self.calorieValue
    }
}
