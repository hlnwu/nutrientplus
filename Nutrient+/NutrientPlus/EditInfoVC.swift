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
    var targetValue : Float
}


class EditInfoVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var targetCards: [TargetCard] = []
    var CollectionOfCell = [NutrientTargetCell]()
    
    let macros = ["Energy", "Protein", "Carbs", "Fat"]
    let vitamins = ["B1", "B2", "B3", "B5", "B6", "B12",
                     "B12", "Folate", "Vitamin A", "Vitamin C",
                     "Vitamin D", "Vitamin E", "Vitamin K"]
    let minerals = ["Calcium", "Copper", "Iron", "Magnesium",
                    "Manganese", "Phosphorus", "Potassium",
                    "Selenium", "Sodium", "Zinc"]
    var nutrients = [String: Float]()
    var nutrientTargets = [String: Float]()
    
    @IBOutlet weak var updatedCalories: UITextField!
    var calorieValue = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("***in EditInfoVC***")
        tableView.delegate = self
        tableView.dataSource = self
        targetCards = createNutrientCells()
    }
    
    func createNutrientCells() -> [TargetCard] {
        //create an array of TargetCards
        var tempTargets: [TargetCard] = []
        var card: TargetCard
        //initial settings
//        print("createNutrientCells: Macros")
        for item in macros {
//            print("\(item): \(nutrientTargets[item] ?? 0)")
            card = TargetCard(nutritionLabel: item, targetValue: nutrientTargets[item] ?? 0)
            tempTargets.append(card)
        }
//        print("createNutrientCells: Vitamins")
        for item in vitamins {
//            print("\(item): \(nutrientTargets[item] ?? 0)")
            card = TargetCard(nutritionLabel: item, targetValue: nutrientTargets[item] ?? 0)
            tempTargets.append(card)
        }
//        print("createNutrientCells: Minerals")
        for item in minerals {
//            print("\(item): \(nutrientTargets[item] ?? 0)")
            card = TargetCard(nutritionLabel: item, targetValue: nutrientTargets[item] ?? 0)
            tempTargets.append(card)
        }
        return tempTargets
    }
    
    @IBAction func done(_ sender: Any) {
        self.calorieValue = updatedCalories.text!
//        print("CollectionCell has contents...")
        CollectionOfCell.forEach { cell in
//            print(cell.NutrientName.text!)
//            print(cell.NewNutrientValue.text!)
            if(cell.NewNutrientValue.text != "") {
                nutrientTargets[cell.NutrientName.text!] = Float(cell.NewNutrientValue.text!)
//                print("\(cell.NewNutrientValue.text!) entered so adding to nutrientTargets")
            }
        }
        performSegue(withIdentifier: "editToMain", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ViewController
        vc.calories = self.calorieValue
        nutrientTargets["Energy"] = (calorieValue as NSString).floatValue
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
        cell.configure(text: "", placeholder: "(g)")
        CollectionOfCell.append(cell)
//        print("Appending:", cell.NutrientName.text!)
        return cell
    }
}
