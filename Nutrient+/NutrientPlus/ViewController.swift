//
//  ViewController.swift
//  Nutrient+
//
//  Created by Robert Sato on 10/11/19.
//  Copyright © 2019 Robert Sato. All rights reserved.
//

import UIKit

struct Card {
    var nutritionLabel : String
    var progressPercent : Float
    var color : UIColor
}

class NutritionCards: UITableViewCell {
    @IBOutlet weak var nutritionProgressView: UIProgressView!
    @IBOutlet weak var nutritionTitleLabel: UILabel!
}

class ViewController: UIViewController {	
    @IBOutlet weak var tableView: UITableView!
    var cards: [Card] = []
    
    // for transfering data
    var calories = "2000"
    @IBOutlet weak var transferDataLabel: UILabel!
    
    //for initializing nutrients
    let macros = ["Energy", "Protein", "Carbs", "Fat"]
    let vitamins = ["B1", "B2", "B3", "B5", "B6", "B12",
                     "B12", "Folate", "Vitamin A", "Vitamin C",
                     "Vitamin D", "Vitamin E", "Vitamin K"]
    let minerals = ["Calcium", "Copper", "Iron", "Magnesium",
                    "Manganese", "Phosphorus", "Potassium",
                    "Selenium", "Sodium", "Zinc"]
    var nutrients = [String: Float]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transferDataLabel.text = calories
        tableView.delegate = self
        tableView.dataSource = self
        cards = populate()
        // Do any additional setup after loading the view.
    }
    
    func populate() -> [Card] {
        
        //create an array of Card
        var tempCards: [Card] = []
        //create a dictionary of nutrient name to value
        var nutrients = [String: Float]()
        //initial settings
        nutrients["Energy"] = (calories as NSString).floatValue
        nutrients["Protein"] = 200
        nutrients["Carbs"] = 20
        nutrients["Fat"] = 200
        
        var card: Card
        print("Macros")
        for item in macros {
            print("\(item): \(nutrients[item] ?? 0)")
            //set the card to a macro, look up the value in nutrients dictionary, give random color
            //this is not the right calculation for progress
            card = Card(nutritionLabel: item, progressPercent: (nutrients[item] ?? 0) / (nutrients["Energy"] ?? 2000), color: .random())
            tempCards.append(card)
        }
        print("Vitamins")
        for item in vitamins {
            print("\(item): \(nutrients[item] ?? 0)")
            //set the card to a vitamin, look up the value in nutrients dictionary, give random color
            card = Card(nutritionLabel: item, progressPercent: (nutrients[item] ?? Float(arc4random()) / Float(UINT32_MAX)), color: .random())
            tempCards.append(card)
        }
        print("Minerals")
        for item in minerals {
            print("\(item): \(nutrients[item] ?? 0)")
            //set the card to a mineral, look up the value in nutrients dictionary, give random color
            card = Card(nutritionLabel: item, progressPercent: (nutrients[item] ?? Float(arc4random()) / Float(UINT32_MAX)), color: .random())
            tempCards.append(card)
        }
        
        return tempCards
        
    }
    
}


extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NutritionCards", for: indexPath) as! NutritionCards
        let card = cards[indexPath.row]
        cell.nutritionTitleLabel?.text = card.nutritionLabel
        cell.nutritionProgressView.progress = card.progressPercent
        cell.nutritionProgressView.progressTintColor = card.color
        return cell
    }
}

// Random Color Generator
// Source: stackoverflow.com/questions/29779128/how-to-make-a-random-color-with-swift
extension CGFloat{
    static func random() -> CGFloat {
        return CGFloat (arc4random())/CGFloat(UInt32.max)
    }
}
extension UIColor{
    static func random() -> UIColor{
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}
