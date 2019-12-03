//
//  AddFoods.swift
//  Nutrient+
//
//  Created by Robert Sato on 10/11/19.
//  Copyright © 2019 Robert Sato. All rights reserved.
//

//import Foundation

//Tutorial for semaphores and dispatchGroup: youtube.com/watch?v=6rJN_ECd1XM
//forums.developer.apple.com/thread/110319

import UIKit

class AddFoods: UIViewController {
    @IBOutlet weak var foodTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var numberOfServings: UITextField?
    var userInput : String = ""
    static var foodCards: [foodInfo] = []
    static var nutrientCards: [nutrientInfo] = []
    static var currentFoodServing: String = ""
    let requestObj = APIRequest()
    let nutrDB = SQLiteDatabase.instance
    lazy var nutrDict = nutrDB.getNutrDict()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodTableView.delegate = self
        foodTableView.dataSource = self
        searchBar.delegate = self
        
        clearTableView()
    }
    
    func clearTableView(){
        AddFoods.foodCards.removeAll()
        AddFoods.nutrientCards.removeAll()
        foodTableView.reloadData()
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
        let card = AddFoods.foodCards[indexPath.row]
        let foodID = card.foodID
        displayServingSizeAlert(fdcID: foodID)
        
        tableView.deselectRow(at: indexPath, animated: true);
    }
    
    //The following function displays an alert prompting for user to enter number of servings
    func displayServingSizeAlert(fdcID: Int){
        self.requestObj.getNutrient(foodID: fdcID)
        APIRequest.dispatchGroup.notify(queue: .main){
            //Setup alert controller components.
            let displayAlertController = UIAlertController(title: "How many servings?\nServing Size: " + AddFoods.currentFoodServing, message: nil, preferredStyle: .alert)
            //Setup alert's textfield
            displayAlertController.addTextField(configurationHandler: self.numberOfServingsHandler)
            //Setup alert's cancel button
            displayAlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ action in
                AddFoods.nutrientCards.removeAll()
                AddFoods.currentFoodServing = ""
            }))
            //Alert's OK button takes the number of servings and performs segue.
            displayAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler:{ action in
                self.performSegue(withIdentifier: "segueToUpdateProgress", sender: self)
                
            }))
            self.present(displayAlertController, animated: true)
        }
    }
    
    //Handler function to retrieve data when OK is pressed
    func numberOfServingsHandler(servingsTextField: UITextField!){
        numberOfServings = servingsTextField
        numberOfServings?.placeholder = "Number of Servings"
    }
    
    //Prepare function updates nutrient progress in main VC
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mainViewController = segue.destination as! ViewController
        let numberServings = (self.numberOfServings?.text)!
        print("NumberServings: ", numberServings)

        for items in AddFoods.nutrientCards{
            let currentNutrientAmount = Double(items.amount) * Double(numberServings)!
            let updatedValue = nutrDict[items.nutrientName]!.nutrProgress + currentNutrientAmount
            nutrDB.updateProgress(iName: items.nutrientName, iProgress: updatedValue)
            //print(items.nutrientName, " HAS UPDATED: ", updatedValue)
        }
    }
}

//When user presses enter, do POST request with user input to get list of Foods
extension AddFoods: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        clearTableView()
        userInput = String(searchBar.text!) //unwraps text
        requestObj.getFoods(userInput:userInput)
        APIRequest.dispatchGroup.notify(queue: .main){
            self.displayFoods()
        }
    }
}

//Outlets that are within the tableview cell.
class FoodCards : UITableViewCell {
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
}
