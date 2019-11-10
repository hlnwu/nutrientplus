//
//  ViewController.swift
//  Nutrient+
//
//  Created by Robert Sato on 10/11/19.
//  Copyright © 2019 Robert Sato. All rights reserved.
//
// image retrieval tutorial: https:// www.youtube.com/watch?v=bF9cEcte0-E&t=623s

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
    var height: Float = 0.0
    var weight: Float = 0.0
    var calories = "2000"
    var tester: String = "did not change"
    var gender: String = ""
    
    // variable for displaying image; used in viewDidLoad()
    @IBOutlet weak var recFoodImg: UIImageView!
    
    // for transfering data
    
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
        tableView.delegate = self
        tableView.dataSource = self
        cards = populate()
//        print("height is equal to ----------> ", height)
//        print("weight is equal to ----------> ", weight)
//        print("gender is equal to ----------> ", gender)
//        let ans=calculate(weight: weight, gender: gender)
//        print(ans)
        
        // grab an image from the Internet
        let URLString: String = "https://images-na.ssl-images-amazon.com/images/I/91iX-arSDcL._SL1500_.jpg"
        let recFoodURL = URL(string: URLString)
        // create session that opens browser in background
        let createWebSession = URLSession.shared.dataTask(with: recFoodURL!) { (data, response, error) in
            if (error != nil) {
                print("ERROR")
            // saving file to local storage
            } else {
                var directory: String?
                let availablePaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                
                // found a place to save file
                // saving file to given directory path
                if availablePaths.count > 0 {
                    directory = availablePaths[0]
                    // splits URL by '/' and save all strings in an array
                    let fileNameArray = URLString.components(separatedBy: "/")
                    // find the size of the array
                    let fileNameArraySize = fileNameArray.count
                    // the string after last '/' will be the file name
                    let fileName = fileNameArray[fileNameArraySize]
                    let savePath = directory! + fileName
                    // step where file is saved
                    FileManager.default.createFile(atPath: savePath, contents: data, attributes: nil)
                    // loading in data from saved path
                    DispatchQueue.main.async {
                        self.recFoodImg.image = UIImage(named: savePath)
                    }
                }
            }
        }
        
        createWebSession.resume()
        
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
        // print("Macros")
        for item in macros {
            //print("\(item): \(nutrients[item] ?? 0)")
            //set the card to a macro, look up the value in nutrients dictionary, give random color
            //this is not the right calculation for progress
            card = Card(nutritionLabel: item, progressPercent: (nutrients[item] ?? 0) / (nutrients["Energy"] ?? 2000), color: .random())
            tempCards.append(card)
        }
        // print("Vitamins")
        for item in vitamins {
            // print("\(item): \(nutrients[item] ?? 0)")
            //set the card to a vitamin, look up the value in nutrients dictionary, give random color
            card = Card(nutritionLabel: item, progressPercent: (nutrients[item] ?? Float(arc4random()) / Float(UINT32_MAX)), color: .random())
            tempCards.append(card)
        }
        //print("Minerals")
        for item in minerals {
            // print("\(item): \(nutrients[item] ?? 0)")
            //set the card to a mineral, look up the value in nutrients dictionary, give random color
            card = Card(nutritionLabel: item, progressPercent: (nutrients[item] ?? Float(arc4random()) / Float(UINT32_MAX)), color: .random())
            tempCards.append(card)
        }
        
        return tempCards
        
    }
    
}
func calculate(weight : Float,gender : String  )->NSInteger{
    if(gender=="Female"){
        let ans=0.9*weight*24
        let intAns:Int = Int(ans)
        return intAns
    }
    else{
        let ans=1*weight*24
        let intAns:Int = Int(ans)
        return intAns
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
