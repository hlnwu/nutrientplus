//
//  ViewController.swift
//  Nutrient+
//
//  Created by Robert Sato on 10/11/19.
//  Copyright © 2019 Robert Sato. All rights reserved.
//
// image retrieval tutorial: https:// www.youtube.com/watch?v=bF9cEcte0-E&t=623s
// URL retrieval through web scraping: https:// www.youtube.com/watch?v=gscuaUSkxnI

import UIKit
import WebKit
import CoreData

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
    var height: Int16 = 0
    var birthdate: Date = Date()
    var tester: String = "did not change"
    var gender: String = ""
    var user = [User]()
    var length: NSInteger = 0

    
    // variable for displaying image; used in viewDidLoad()
    @IBOutlet weak var recFoodImg: UIImageView!
    
    //for initializing nutrients
    let macros = ["Energy", "Protein", "Carbs", "Fat"]
    let vitamins = ["B1", "B2", "B3", "B5", "B6", "B12",
                     "B12", "Folate", "Vitamin A", "Vitamin C",
                     "Vitamin D", "Vitamin E", "Vitamin K"]
    let minerals = ["Calcium", "Copper", "Iron", "Magnesium",
                    "Manganese", "Phosphorus", "Potassium",
                    "Selenium", "Sodium", "Zinc"]
    //nutrients stores daily nutritional data
    var nutrients = [String: Float]()
    //nutrientTargets stores the daily targets
    var nutrientTargets = [String: Float]()
    var targetsEdited = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        // seems like this may be DELETED in the future
        // but this conditional replaces nutrient targets with a hard-coded in target value
        if !targetsEdited {
            createTargets()
        }
        
        // creates each of the nutrient cards in the table view
        self.cards = self.populate()
        
        // assigns the user's info to the class variable to be used to calculate target goals
        let test: NSFetchRequest<User> = User.fetchRequest()
        do {
            let formatter = NumberFormatter()
            formatter.generatesDecimalNumbers = true
            let user = try PersistenceService.context.fetch(test)
            self.user = user
            length = user.count - 1
            let origWeight = String(describing: user[length].weight)
            var weight = formatter.number(from: origWeight) as? NSDecimalNumber ?? 0
            height = user[length].height
            gender = user[length].sex ?? "male"
            let weightUnitString = user[length].weightUnit
            let heightUnitString = user[length].heightUnit
            
            // convert height to cm
            if heightUnitString == "in" {
                height = Int16(Double(height) * 2.54)
            }
            
            // convert weight to kg
            if weightUnitString == "lbs" {
                let divisor = NSDecimalNumber(0.453592)
                weight = weight.multiplying(by: divisor)
            }
            
            let PersonalNutrientGoals : [String : Float]  = calculate(weight: Float(weight), gender: gender, length: length, birthdate: birthdate )
        } catch {}
        
    }

    // this may be DELETED later since it's hard-coded
    // hard-coded in targets
    func createTargets() {
        for item in macros {
            nutrientTargets[item] = 200
        }
        for item in vitamins {
            nutrientTargets[item] = 10
        }
        for item in minerals {
            nutrientTargets[item] = 5
        }
    }
    
    // creates the table view on the main page
    func populate() -> [Card] {
        
        //create an array of Card
        var tempCards: [Card] = []
        var card: Card
        
        for item in macros {
            //set the card to a macro, look up the value in nutrients dictionary, give random color
            //this is not the right calculation for progress
            card = Card(nutritionLabel: item, progressPercent: (nutrients[item] ?? 0) / (nutrientTargets[item] ?? 200), color: .random())
            tempCards.append(card)
        }

        for item in vitamins {
            //set the card to a vitamin, look up the value in nutrients dictionary, give random color
            card = Card(nutritionLabel: item, progressPercent: ((nutrients[item] ?? 0) / (nutrientTargets[item] ?? 10)), color: .random())
            tempCards.append(card)
        }

        for item in minerals {
            //set the card to a mineral, look up the value in nutrients dictionary, give random color
            card = Card(nutritionLabel: item, progressPercent: ((nutrients[item] ?? 0) / (nutrientTargets[item] ?? 5)), color: .random())
            tempCards.append(card)
        }
        return tempCards
    }
    
    // for sending data over segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is EditInfoVC
        {
            let vc = segue.destination as? EditInfoVC
            vc?.nutrientTargets = self.nutrientTargets
            vc?.nutrients = self.nutrients
        }
    }
    
}

// calculates the target goal given the user's inputted info from Startup
func calculate(weight: Float, gender: String, length: NSInteger, birthdate: Date  ) ->  Dictionary<String, Float> {
    var dictionary: [String : Float] = [:]
    let calendar = Calendar.current
    let birthday = birthdate
    let now = Date()
    let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
    let age = ageComponents.year!
    
    if (gender == "Female") {
        let ans = 0.9 * weight * 24
        let intAns: Int = Int(ans)
        let ans1 = Float(intAns)
        dictionary["Energy"] = ans1
        
        if(age < 3){
            dictionary["B1"] = 0.5
            dictionary["B2"] = 0.5
            dictionary["B5"] = 2
            dictionary["B6"] = 0.5
            dictionary["B6"] = 0.5
            dictionary["B12"] = 0.9
            dictionary["Folate"] = 150
            dictionary["Vitamin A"] = 300
            dictionary["Vitamin C"] = 15
            dictionary["Vitamin E"] = 6
            dictionary["Vitamin K"] = 30
            dictionary["Magnesium"] = 80
        } else if (age <= 8){
            dictionary["B1"] = 0.6
            dictionary["B2"] = 0.6
            dictionary["B5"] = 3
            dictionary["B6"] = 0.6
            dictionary["B12"] = 1.2
            dictionary["Folate"] = 200
            dictionary["Vitamin A"] = 400
            dictionary["Vitamin C"] = 25
            dictionary["Votamin E"] = 7
            dictionary["Vitamin K"] = 55
            dictionary["Magnesium"] = 130
        } else if (age <= 13){
            dictionary["B1"] = 0.9
            dictionary["B2"] = 0.9
            dictionary["B5"] = 4
            dictionary["B6"] = 1.0
            dictionary["B12"] = 1.3
            dictionary["Folate"] = 300
            dictionary["Vitamin A"] = 600
            dictionary["Vitamin C"] = 45
            dictionary["Votamin E"] = 11
            dictionary["Vitamin K"] = 60
            dictionary["Iron"] = 15.1
            dictionary["Magnesium"] = 240
        } else if (age <= 18){
            dictionary["B1"] = 1.0
            dictionary["B2"] = 1.0
            dictionary["B6"] = 1.3
            dictionary["Folate"] = 400
            dictionary["Vitamin A"] = 700
            dictionary["Vitamin C"] = 65
            dictionary["Vitamin K"] = 75
            dictionary["Calcium"] = 1300
            dictionary["Iron"] = 16.3
            dictionary["Magnesium"] = 360
        } else if(age <= 50){
            dictionary["B6"] = 1.3
        } else {
            dictionary["B1"] = 1.1
            dictionary["B5"] = 5
            dictionary["B6"] = 1.7
            dictionary["B12"] = 2.4
            dictionary["Folate"] = 150
            dictionary["Vitamin A"] = 700
            dictionary["Vitamin C"] = 75
            dictionary["Vitamin K"] = 120
            dictionary["Calcium"] = 1200
            dictionary["Iron"] = 20.5
            dictionary["Magnesium"] = 320
        }
        dictionary["B3"] = 14
        dictionary["VItamin E"] = 15
    }
    
    if (gender == "Male") {
        let ans = 1 * weight * 24
        let intAns: Int = Int(ans)
        let ans1 = Float(intAns)
        dictionary["Energy"] = ans1
    
        if(age<3){
            dictionary["B1"] = 0.5
            dictionary["B2"] = 0.5
            dictionary["B5"] = 2
            dictionary["B6"] = 0.5
            dictionary["B12"] = 0.9
            dictionary["Folate"] = 150
            dictionary["Vitamin A"] = 300
            dictionary["Vitamin C"] = 15
            dictionary["Vitamin E"] = 6
            dictionary["Vitamin K"] = 30
            dictionary["Magnesium"] = 80
        } else if (age <= 8) {
            dictionary["B1"] = 0.6
            dictionary["B2"] = 0.6
            dictionary["B5"] = 3
            dictionary["B6"] = 0.6
            dictionary["B12"] = 1.2
            dictionary["Folate"] = 200
            dictionary["Vitamin A"] = 400
            dictionary["Vitamin C"] = 25
            dictionary["Vitamin E"] = 7
            dictionary["Vitamin K"] = 55
            dictionary["Magnesium"] = 130
        } else if (age<=13){
              dictionary["B1"] = 0.9 //mg
              dictionary["B2"] = 0.9 //mg
              dictionary["B5"] = 4   //mg
              dictionary["B6"] = 1.0 //mg
              dictionary["B12"] = 1.8 //mg
              dictionary["Folate"] = 300 //mcg
              dictionary["Vitamin A"] = 600//mcg
              dictionary["Vitamin C"] = 45 //mg
              dictionary["Vitamin E"] = 11 //mg
              dictionary["Vitamin K"] = 60 //mg
              dictionary["Iron"] = 15.1 //mg
              dictionary["Magnesium"] = 240 //mcg
            
        } else if (age <= 18){
            dictionary["B6"] = 1.3
            dictionary["Folate"] = 400
            dictionary["Vitamin C"] = 75
            dictionary["Vitamin K"] = 75
            dictionary["Calcium"] = 1300
            dictionary["Iron"] = 16.3
            dictionary["Magnesium"] = 410
        } else if (age<=50){
            dictionary["B6"] = 1.3
        } else {
            dictionary["B1"]=1.2
            dictionary["B2"]=1.3
            dictionary["B6"]=1.5
            dictionary["B12"]=2.4
            dictionary["Folate"] = 400
            dictionary["Vitamin A"]=900
            dictionary["Vitamin C"] = 90
            dictionary["Vitamin K"] = 120
            dictionary["Calcium"] = 1200
            dictionary["Iron"] = 20.5
            dictionary["Magnesium"] = 420
        }
        dictionary["B3"] = 16
        dictionary["B5"] = 5
        dictionary["Vitamin E"] = 15
        dictionary["Zinc"] = 14
    }
    let proteinIntake: Float = 0.8 * weight
    dictionary["protein"] = proteinIntake
    let carbs: Float = 0.55 * (dictionary["Energy"] ?? 0.0)
    dictionary["carbs"] = carbs
    dictionary["fats"] = 0.275 * (dictionary["Energy"] ?? 0.0)
    dictionary["Vitamin D"] = 600
    dictionary["CoQ10"] = 100
    dictionary["Manganese"] = 5
    dictionary["Potassium"] = 3.5
    dictionary["Phosphorus"] = 700
    //Se in mcg
    dictionary["Selenium"] = 55
    dictionary["Sodium"] = 2300
    dictionary["Zinc"] = 13
    return dictionary
}

// inputs the cards into the table view in ViewController view
extension ViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NutritionCards", for: indexPath) as! NutritionCards
        let card = cards[indexPath.row]
        cell.nutritionTitleLabel?.text = card.nutritionLabel
        cell.nutritionProgressView?.progress = card.progressPercent
        cell.nutritionProgressView?.progressTintColor = card.color
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
