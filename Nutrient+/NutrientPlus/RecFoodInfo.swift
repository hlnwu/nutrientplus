//
//  RecFoodInfo.swift
//  NutrientPlus
//
//  Created by hoo on 11/5/19.
//  Copyright © 2019 hoo. All rights reserved.
//
// https:// www.youtube.com/watch?v=DmWv-JtQH4Q&t=708s

import UIKit

class RecFoodInfo: UIViewController {
    @IBOutlet weak var foodInfoTextView: UITextView!
    @IBOutlet weak var recFoodNameLabel: UILabel!
    @IBOutlet weak var servingSizeLabel: UILabel!
    var recFoodArrayInfo: [String] = []
    var nutrientNames: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // printing out information of recommended food
        recFoodNameLabel.text = recFoodArrayInfo[0]
        servingSizeLabel.text = recFoodArrayInfo[2] + " (" + recFoodArrayInfo[1] + "g)"
        
        var textViewString: String = ""
        
        // loop through recommended food data to print each nutrient data on a new line
        for foodDataIdx in 3...(recFoodArrayInfo.count - 1) {
            if recFoodArrayInfo[foodDataIdx] != "0.0" {
                textViewString = textViewString + nutrientNames[foodDataIdx - 3] + ": " + recFoodArrayInfo[foodDataIdx] + "\n"
            }
        }
        foodInfoTextView.text = textViewString
        // Do any additional setup after loading the view.
    }
    
    // used when user exits out of popup
    @IBAction func dismissPopup(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
