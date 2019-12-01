//
//  EditInfoVC.swift
//  NutrientPlus
//
//  Created by Robert Sato on 10/22/19.
//  Copyright © 2019 hoo. All rights reserved.
//
//  Modified: 11/5/19

import Foundation
import UIKit

class NutrientTargetCell: UITableViewCell {
    @IBOutlet weak var NutrientName: UILabel!
    @IBOutlet weak var NewNutrientValue: UITextField!
    
    public func configure(text: String?, placeholder: String) {
        NewNutrientValue.text = text
        NewNutrientValue.placeholder = placeholder
        NewNutrientValue.accessibilityValue = text
        NewNutrientValue.accessibilityLabel = placeholder
        
    }
}

struct TargetCard {
    var nutritionLabel : String
    var targetValue : Double
}

class EditInfoVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var targetCards: [TargetCard] = []
    var CollectionOfCell = [NutrientTargetCell]()
    
    let macros = ["Energy", "Protein", "Carbs", "Fat"]
    let vitamins = ["B1", "B2", "B3", "B5", "B6", "B12",
                    "Folate", "Vitamin A", "Vitamin C",
                    "Vitamin D", "Vitamin E", "Vitamin K"]
    let minerals = ["Calcium", "Copper", "Iron", "Magnesium",
                    "Manganese", "Phosphorus", "Potassium",
                    "Selenium", "Sodium", "Zinc"]
    var nutrients = [String: Double]()
    var nutrientTargets = [String: Double]()
    
    @IBOutlet weak var updatedCalories: UITextField!
    
    //Database local data
    let nutrDB = SQLiteDatabase.instance
    var storedNutrientData = [NutrientStruct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storedNutrientData = nutrDB.getNutr()
        tableView.delegate = self
        tableView.dataSource = self
        targetCards = createNutrientCells()
        
        }
    
    // creates the table view for user to input custom target values
    func createNutrientCells() -> [TargetCard] {
        var tempTargets: [TargetCard] = []
        var card: TargetCard
        for nutrient in storedNutrientData {
            card = TargetCard(nutritionLabel: nutrient.nutrName, targetValue: nutrient.nutrTarget)
            tempTargets.append(card)
        }
        return tempTargets
    }
    
    // user is finished with inputting custom target values
    @IBAction func done(_ sender: Any) {
        CollectionOfCell.forEach { cell in
            // if no custom value inputted by user, return the original target value
            if(cell.NewNutrientValue.text != "") {
                nutrientTargets[cell.NutrientName.text!] = Double(cell.NewNutrientValue.text!)
                //add it to the db not the dictionary
                nutrDB.updateTarget(iName: cell.NutrientName.text!, iTarget: Double(cell.NewNutrientValue.text!)!)
            }
        }
        performSegue(withIdentifier: "editToMain", sender: self)
    }
    
    // passing the data between this view controller and MainPage
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ViewController
        //Error: some of these values are empty so it is being passed as empty back
        vc.nutrientTargets = self.nutrientTargets
        vc.nutrients = self.nutrients
        vc.targetsEdited = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nutrientTargets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NutrientTargetCell") as! NutrientTargetCell
        let tempTarget = targetCards[indexPath.row]
        cell.NutrientName?.text = tempTarget.nutritionLabel
        //if nutrient type; placeholder = g/mg/cups
        let nutrientOneDecimal = (round(tempTarget.targetValue * 10)) / 10
        cell.configure(text: "", placeholder: "\(nutrientOneDecimal)")
        CollectionOfCell.append(cell)
        return cell
    }
}
