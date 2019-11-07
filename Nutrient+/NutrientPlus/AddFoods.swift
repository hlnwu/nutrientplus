//
//  AddFoods.swift
//  Nutrient+
//
//  Created by Robert Sato on 10/11/19.
//  Copyright © 2019 Robert Sato. All rights reserved.
//

//import Foundation

//Tutorial for semaphores and dispatchGroup: youtube.com/watch?v=6rJN_ECd1XM
import UIKit

class FoodCards : UITableViewCell {
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
}

class AddFoods: UIViewController {
    @IBOutlet weak var foodTableView: UITableView!
    @IBOutlet weak var editText: UITextField!
    
    var userInput : String = ""
    static var foodCards: [foodInfo] = []
    static var nutrientCards: [nutrientInfo] = []
    let requestObj = APIRequest()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodTableView.delegate = self
        foodTableView.dataSource = self

    }

    @IBAction func enterButton(_ sender: UIButton) { //When user presses enter, do POST request with user input
        userInput = String(editText.text!) //unwraps text
        requestObj.getFoods(userInput:userInput)
        displayFoods()
    }
    
    func printNutrients(){
        APIRequest.dispatchGroup.notify(queue: .main){ //BLOCK until mutex is freed.
            for i in AddFoods.nutrientCards{
                print (i.amount, i.unitName, i.nutrientName)
            }
        }
    }
    
    func displayFoods(){
        APIRequest.dispatchGroup.notify(queue: .main){
            for i in AddFoods.foodCards{
                print (i.foodName, i.brandName)
            }
            self.foodTableView.reloadData() //Update tableview
        }
    }
}

//Extension functions to make tableView recycle cells.
extension AddFoods: UITableViewDataSource, UITableViewDelegate{
    //Number of rows in tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AddFoods.foodCards.count
    }
    
    //The following function iterates the tableView and sets each cell.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = foodTableView.dequeueReusableCell(withIdentifier: "FoodCards", for: indexPath) as! FoodCards
        let card = AddFoods.foodCards[indexPath.row]
        cell.foodNameLabel?.text = card.foodName
        cell.brandLabel?.text = card.brandName
        return cell
    }
    
    //The following function checks if a cell has been tapped.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let card = AddFoods.foodCards[indexPath.row] //Retrieve card of cell that was tapped.
        let foodID = card.foodID            //Get the foodID of the tapped cell.
        requestObj.getNutrients(foodID: foodID)        //Do GET Request with the foodID to get nutrients
        printNutrients()
    }
}
