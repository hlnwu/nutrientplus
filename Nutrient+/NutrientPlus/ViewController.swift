//
//  ViewController.swift
//  Nutrient+
//
//  Created by Robert Sato on 10/11/19.
//  Copyright © 2019 Robert Sato. All rights reserved.
//
// image retrieval tutorial: https:// www.youtube.com/watch?v=bF9cEcte0-E&t=623s

import UIKit
import CoreData
import SQLite

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
    var birthdate : Date = Date()
    var tester :String="did not change"
    var gender : String = ""
    var user=[User]()
    var length : NSInteger = 0

    
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
    //nutrients stores daily nutritional data
    var nutrients = [String: Float]()
    //nutrientTargets stores the daily targets
    var nutrientTargets = [String: Float]()
    var targetsEdited = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        // Do any additional setup after loading the view.
        
        self.displayRecFoodImg()
        
        //print("***in ViewController.swift***")

        tableView.delegate = self
        tableView.dataSource = self
        
        if !targetsEdited {//if nutrient targets werent edited in EditInfoVC
            //print("Reseting nutrients and creating targets;targetsEdited = false")
            //reset nutrient progress and create the target goals
            //resetNutrients()
            createTargets()
        }
//        print("Printing Nutrients")
//        print(nutrients)
//        print("Printing Nutrient Targets:")
//        print(nutrientTargets)
        self.cards = self.populate()
        let test: NSFetchRequest<User>  = User.fetchRequest()
        do{
            let  user=try PersistenceService.context.fetch(test)
            self.user=user
            length=user.count-1
//            print(length);
            //print(user[length].weight!);
            weight=user[length].weight?.floatValue ?? 0
            height=Float(user[length].height);
            gender=user[length].sex ?? "male"
            //birthdate=user[length].birthday!
        }catch{}

        //let recommendations1 = recommend1()
//        print("Recommendations1:")
        //print(recommendations1)
        //not sure if this is necessary
        //tableView.reloadData()
        
    }
    
    func displayRecFoodImg() {
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
                    let fileName = fileNameArray[fileNameArraySize - 1]
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
    
    func populate() -> [Card] {
        
        //create an array of Card
        var tempCards: [Card] = []
        
        var card: Card
//        print("Populate: Macros")
//        print("HEEERRREEE: ", nutrients)
        for item in macros {
            //set the card to a macro, look up the value in nutrients dictionary, give random color
            //this is not the right calculation for progress
            card = Card(nutritionLabel: item, progressPercent: (nutrients[item] ?? 0) / (nutrientTargets[item] ?? 200), color: .random())
            tempCards.append(card)
        }
//        print("Populate: Vitamins")
        for item in vitamins {
            //set the card to a vitamin, look up the value in nutrients dictionary, give random color
            card = Card(nutritionLabel: item, progressPercent: ((nutrients[item] ?? 0) / (nutrientTargets[item] ?? 10)), color: .random())
            tempCards.append(card)
        }
//        print("Populate: Minerals")
        for item in minerals {
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
func calculate(weight : Float,gender : String,length : NSInteger, birthdate : Date  )->Dictionary<String,Float>{
    var dictionary: [String:Float]=[:]
    print(gender)
    let calendar = Calendar.current
             let birthday = birthdate
             let now = Date()
             let ageComponents = calendar.dateComponents([.year], from: birthday, to: now)
             let age = ageComponents.year!
    if(gender=="Female"){
        let ans=0.9*weight*24
        let intAns:Int = Int(ans)
        let ans1=Float(intAns)
        dictionary["Energy"] = ans1
          if(age<3){
              dictionary["B1"]=0.5
              dictionary["B2"]=0.5
              dictionary["B5"]=2
              dictionary["B6"]=0.5
              dictionary["B6"]=0.5
              dictionary["B12"]=0.9
              dictionary["Folate"] = 150
              dictionary["Vitamin A"] = 300
              dictionary["Vitamin C"] = 15
              dictionary["Vitamin E"] = 6
              dictionary["Vitamin K"] = 30
              dictionary["Magnesium"] = 80
                
          }
          else if (age<=8){
              dictionary["B1"]=0.6
              dictionary["B2"]=0.6
              dictionary["B5"]=3
              dictionary["B6"]=0.6
              dictionary["B12"]=1.2
              dictionary["Folate"] = 200
              dictionary["Vitamin A"]=400
              dictionary["Vitamin C"] = 25
              dictionary["Votamin E"] = 7
              dictionary["Vitamin K"] = 55
              dictionary["Magnesium"] = 130
          }
          else if (age<=13){
            dictionary["B1"] = 0.9
            dictionary["B2"] = 0.9
            dictionary["B5"] = 4
            dictionary["B6"] = 1.0
            dictionary["B12"]=1.3
            dictionary["Folate"] = 300
            dictionary["Vitamin A"]=600
            dictionary["Vitamin C"] = 45
            dictionary["Votamin E"] = 11
            dictionary["Vitamin K"] = 60
            dictionary["Iron"] = 15.1
            dictionary["Magnesium"] = 240
            

          }
          else if (age<=18){
            dictionary["B1"]=1.0
            dictionary["B2"]=1.0
            //dictionary["B5"]=5
            dictionary["B6"]=1.3
            dictionary["Folate"] = 400
            dictionary["Vitamin A"]=700
            dictionary["Vitamin C"] = 65
            dictionary["Vitamin K"] = 75
            dictionary["Calcium"] = 1300
            dictionary["Iron"] = 16.3
            dictionary["Magnesium"] = 360
            
            }
          else if(age<=50){
            dictionary["B6"]=1.3
             
          }
          else{
            dictionary["B1"]=1.1
            dictionary["B5"]=5
            dictionary["B6"]=1.7
            dictionary["B12"]=2.4
            dictionary["Folate"] = 150
            dictionary["Vitamin A"]=700
            dictionary["Vitamin C"] = 75
            dictionary["Vitamin K"] = 120
            dictionary["Calcium"] = 1200
            dictionary["Iron"] = 20.5
            dictionary["Magnesium"] = 320
        }
        dictionary["B3"]=14
        dictionary["VItamin E"] = 15
    }
    if(gender=="Male"){
        print("else this is it")
        let ans=1*weight*24
        let intAns:Int = Int(ans)
               let ans1=Float(intAns)
               dictionary["Energy"] = ans1
        if(age<3){
                    dictionary["B1"]=0.5
                    dictionary["B2"]=0.5
                    dictionary["B5"] = 2
                    dictionary["B6"] = 0.5
                    dictionary["B12"] = 0.9
                    dictionary["Folate"] = 150
                    dictionary["Vitamin A"]=300
                    dictionary["Vitamin C"] = 15
                    dictionary["Vitamin E"] = 6
                    dictionary["Vitamin K"] = 30
                    dictionary["Magnesium"] = 80
                }
                else if (age<=8){
                    dictionary["B1"]=0.6
                    dictionary["B2"]=0.6
                    dictionary["B5"]=3
                    dictionary["B6"]=0.6
                    dictionary["B12"]=1.2
                    dictionary["Folate"] = 200
                    dictionary["Vitamin A"]=400
                    dictionary["Vitamin C"] = 25
                    dictionary["Vitamin E"] = 7
                    dictionary["Vitamin K"] = 55
                    dictionary["Magnesium"] = 130
                    
                   
                }
                else if (age<=13){
                  dictionary["B1"]=0.9 //mg
                  dictionary["B2"]=0.9 //mg
                  dictionary["B5"]=4   //mg
                  dictionary["B6"]=1.0 //mg
                  dictionary["B12"]=1.8 //mg
                  dictionary["Folate"] = 300 //mcg
                  dictionary["Vitamin A"]=600//mcg
                  dictionary["Vitamin C"] = 45 //mg
                  dictionary["Vitamin E"] = 11 //mg
                  dictionary["Vitamin K"] = 60 //mg
                  dictionary["Iron"] = 15.1 //mg
                  dictionary["Magnesium"] = 240 //mcg
                
                }
        else if(age<=18){
            dictionary["B6"]=1.3
            dictionary["Folate"] = 400
            dictionary["Vitamin C"] = 75
            //dictionary["Vitamin A"]=700
            dictionary["Vitamin K"] = 75
            dictionary["Calcium"] = 1300
            dictionary["Iron"] = 16.3
            dictionary["Magnesium"] = 410
        }
        else if (age<=50){
            dictionary["B6"]=1.3
        }
        else{
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
        dictionary["B3"]=16
        dictionary["B5"]=5
        dictionary["Vitamin E"] = 15
        dictionary["Zinc"] = 14
        
        
    }
    let proteinIntake : Float = 0.8*weight
    dictionary["protein"] = proteinIntake
    let carbs : Float = 0.55*(dictionary["Energy"] ?? 0.0)
    dictionary["carbs"] = carbs
    dictionary["fats"] = 0.275*(dictionary["Energy"] ?? 0.0)
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
