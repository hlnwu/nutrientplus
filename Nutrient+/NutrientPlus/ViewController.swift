//
//  ViewController.swift
//  Nutrient+
//
//  Created by Robert Sato on 10/11/19.
//  Copyright © 2019 Robert Sato. All rights reserved.
//

import UIKit
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
    var height: Float=0.0
    var weight: Float=0.0
    var calories = "2000"
    var birthdate : Date = Date()
    var tester :String="did not change"
    var gender : String = ""
    var user=[User]()
    var length : NSInteger = 0
    
    // for transfering data
    @IBOutlet weak var transferDataLabel: UILabel!
    
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
        print("***in ViewController.swift***")
        transferDataLabel.text = calories
        tableView.delegate = self
        tableView.dataSource = self
        if !targetsEdited {//if nutrient targets werent edited in EditInfoVC
            print("Reseting nutrients and creating targets; targetsEdited = false")
            //reset nutrient progress and create the target goals
            resetNutrients()
            createTargets()
        }
        print("Printing Nutrients")
        print(nutrients)
        print("Printing Nutrient Targets:")
        print(nutrientTargets)
        cards = populate()
        let test: NSFetchRequest<User>  = User.fetchRequest()
        do{
            let  user=try PersistenceService.context.fetch(test)
            self.user=user
            if (user.count == 0){
                length = 0
            }
            else {
                length=user.count-1
            }
            print(user.count);
            //print(user[length].weight!);
            weight=user[length].weight?.floatValue ?? 0
            height=Float(user[length].height);
            gender=user[length].sex ?? "male"
            //birthdate=user[length].birthday!
        }catch{}
        
        let recommendations1 = recommend1()
        print("Recommendations1:")
        print(recommendations1)
        
    }
    
    func recommend1() -> [String: Float] {
        var missing_percentage = [String: Float]()
        for item in macros {
            missing_percentage[item] = nutrients[item]!/nutrientTargets[item]!
        }
        for item in vitamins {
            missing_percentage[item] = nutrients[item]!/nutrientTargets[item]!
        }
        for item in minerals {
            missing_percentage[item] = nutrients[item]!/nutrientTargets[item]!
        }
        return missing_percentage
    }
    
    func resetNutrients() {
        for item in macros {
            //initializing to non zero value for testing
            nutrients[item] = 100
        }
        for item in vitamins {
            nutrients[item] = 3
        }
        for item in minerals {
            nutrients[item] = 1
        }
    }
    
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
    
    func printTargets() {
        print("Macros")
        for item in macros {
            print("nutrientTargets[\(item)]: \(nutrientTargets[item] ?? -1)")
        }
        print("Vitamins")
        for item in vitamins {
            print("nutrientTargets[\(item)]: \(nutrientTargets[item] ?? -1)")
        }
        print("Minerals")
        for item in minerals {
            print("nutrientTargets[\(item)]: \(nutrientTargets[item] ?? -1)")
        }
    }
    
    func populate() -> [Card] {
        
        //create an array of Card
        var tempCards: [Card] = []
        
        
        var card: Card
        print("Populate: Macros")
        for item in macros {
//            print("nutrients[\(item)]: \(nutrients[item] ?? 0)")
//            print("nutrientTargets[\(item)]: \(nutrientTargets[item] ?? 0)")
            //set the card to a macro, look up the value in nutrients dictionary, give random color
            //this is not the right calculation for progress
            card = Card(nutritionLabel: item, progressPercent: (nutrients[item] ?? 0) / (nutrientTargets["Energy"] ?? 2000), color: .random())
            tempCards.append(card)
        }
        print("Populate: Vitamins")
        for item in vitamins {
//            print("nutrients[\(item)]: \(nutrients[item] ?? 0)")
//            print("nutrientTargets[\(item)]: \(nutrientTargets[item] ?? 0)")
            //set the card to a vitamin, look up the value in nutrients dictionary, give random color
            card = Card(nutritionLabel: item, progressPercent: ((nutrients[item] ?? 0) / (nutrientTargets[item] ?? 10)), color: .random())
            tempCards.append(card)
        }
        print("Populate: Minerals")
        for item in minerals {
//            print("nutrients[\(item)]: \(nutrients[item] ?? 0)")
//            print("nutrientTargets[\(item)]: \(nutrientTargets[item] ?? 0)")
            //set the card to a mineral, look up the value in nutrients dictionary, give random color
            card = Card(nutritionLabel: item, progressPercent: ((nutrients[item] ?? 0) / (nutrientTargets[item] ?? 5)), color: .random())
            tempCards.append(card)
        }
        return tempCards
    }
    
    //for sending data over segues
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

func calculate(weight : Float,gender : String,length : NSInteger  )->Dictionary<String,Float>{
    var dictionary: [String:Float]=[:]
    print(gender)
    if(gender=="Female"){
        
        let ans=0.9*weight*24
        let intAns:Int = Int(ans)
        let ans1=Float(intAns)
        dictionary["Energy"] = ans1
        
        
        
    }
    else{
        let ans=1*weight*24
        let intAns:Int = Int(ans)
               let ans1=Float(intAns)
               dictionary["Energy"] = ans1
        
        
    }
    let proteinIntake : Float = 0.8*weight
    dictionary["protein"] = proteinIntake
    let carbs : Float = 0.55*(dictionary["Energy"] ?? 0.0)
    dictionary["carbs"] = carbs
    dictionary["fats"] = 0.275*(dictionary["Energy"] ?? 0.0)

           
          
    
    
    
    
    return dictionary
}


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
