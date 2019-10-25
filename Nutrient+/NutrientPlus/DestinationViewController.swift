//
//  DestinationViewController.swift
//  Nutrient+
//
//  Created by Robert Sato on 10/11/19.
//  Copyright © 2019 Robert Sato. All rights reserved.
//

//import Foundation
import UIKit

struct foodInfo {
    var foodName : String
    var brandName : String
}

class FoodCards : UITableViewCell {
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
}

class DestinationViewController: UIViewController {
    @IBOutlet weak var foodTableView: UITableView!
    @IBOutlet weak var editText: UITextField!
    
    var userInput : String = ""
    var foodCards: [foodInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //foodTableView.delegate = self
        //foodTableView.dataSource = self
    }
    
    @IBAction func enterButton(_ sender: UIButton) {
        userInput = String(editText.text!) //unwraps text
        //DO API CALL HERE
        
    }
    
}


extension DestinationViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodCards.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = foodTableView.dequeueReusableCell(withIdentifier: "FoodCards", for: indexPath) as! FoodCards
        let card = foodCards[indexPath.row]
        cell.foodNameLabel?.text = card.foodName
        cell.brandLabel?.text = card.brandName
        return cell
    }
}
