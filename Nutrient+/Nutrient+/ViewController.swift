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
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        cards = populate()
        // Do any additional setup after loading the view.
    }

    func populate() -> [Card] {
        var tempCards: [Card] = []
        let card1 =     Card(nutritionLabel: "Calories",        progressPercent: 0.100, color: .random())
        let card2 =     Card(nutritionLabel: "Saturated Fat",   progressPercent: 0.200, color: .random())
        let card4 =     Card(nutritionLabel: "Cholestrol",      progressPercent: 0.350, color: .random())
        let card5 =     Card(nutritionLabel: "Sodium",          progressPercent: 0.550, color: .random())
        let card6 =     Card(nutritionLabel: "Dietary Fiber",   progressPercent: 0.750, color: .random())
        let card7 =     Card(nutritionLabel: "Sugar",           progressPercent: 0.600, color: .random())
        let card8 =     Card(nutritionLabel: "Protein",         progressPercent: 0.250, color: .random())
        let card9 =     Card(nutritionLabel: "Vitamin A",       progressPercent: 0.900, color: .random())
        let card10 =    Card(nutritionLabel: "Vitamin B",       progressPercent: 1.000, color: .random())
        let card11 =    Card(nutritionLabel: "Vitamin C",       progressPercent: 0.400, color: .random())
        let card12 =    Card(nutritionLabel: "Vitamin D",       progressPercent: 0.300, color: .random())
        let card13 =    Card(nutritionLabel: "Potassium",       progressPercent: 0.850, color: .random())
        let card14 =    Card(nutritionLabel: "Thiamin",         progressPercent: 0.600, color: .random())
        let card15 =    Card(nutritionLabel: "Phosphorus",      progressPercent: 0.200, color: .random())
        let card16 =    Card(nutritionLabel: "Magnesium",       progressPercent: 0.150, color: .random())
        let card17 =    Card(nutritionLabel: "Copper",          progressPercent: 0.050, color: .random())
        let card18 =    Card(nutritionLabel: "Calcium",         progressPercent: 0.950, color: .random())
        let card19 =    Card(nutritionLabel: "Iron",            progressPercent: 0.100, color: .random())
        
        tempCards.append(card1)
        tempCards.append(card2)
        tempCards.append(card4)
        tempCards.append(card5)
        tempCards.append(card6)
        tempCards.append(card7)
        tempCards.append(card8)
        tempCards.append(card9)
        tempCards.append(card10)
        tempCards.append(card11)
        tempCards.append(card12)
        tempCards.append(card13)
        tempCards.append(card14)
        tempCards.append(card15)
        tempCards.append(card16)
        tempCards.append(card17)
        tempCards.append(card18)
        tempCards.append(card19)
        
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
