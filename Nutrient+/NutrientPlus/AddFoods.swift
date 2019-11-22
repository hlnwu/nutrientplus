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
    let requestObj = APIRequest()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodTableView.delegate = self
        foodTableView.dataSource = self
        searchBar.delegate = self
        
        clearTableView()
    }
    
    func clearTableView(){
        AddFoods.foodCards.removeAll()
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
//            for i in AddFoods.foodCards{
//                print (i.foodName, i.brandName)
//            }
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
        displayServingSizeAlert(fdcID: foodID)
        
        //when food gets
  
    }
    
    func displayServingSizeAlert(fdcID: Int){
        let displayAlertController = UIAlertController(title: "How many servings?", message: nil, preferredStyle: .alert)
        displayAlertController.addTextField(configurationHandler: numberOfServingsHandler)
        displayAlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        displayAlertController.addAction(UIAlertAction(title: "OK", style: .default, handler:{ action in
            let servings = (self.numberOfServings?.text)!
            self.requestObj.getNutrient(foodID: fdcID, numberOfServings: Int(servings) ?? 1)
            APIRequest.dispatchGroup.notify(queue: .main){
                self.performSegue(withIdentifier: "segueToUpdateProgress", sender: self)
            }
        }))
        
        self.present(displayAlertController, animated: true)
    }
    
    func numberOfServingsHandler(servingsTextField: UITextField!){
        numberOfServings = servingsTextField
        numberOfServings?.placeholder = "Number of Servings"
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let mainViewController = segue.destination as! ViewController

        for items in AddFoods.nutrientCards{
            if (mainViewController.nutrients.keys.contains(items.nutrientName)){
                mainViewController.nutrients[items.nutrientName] = mainViewController.nutrients[items.nutrientName]! + Float(items.amount)
                print("WTFFFFFFFF?")
            }
            else {
                mainViewController.nutrients.updateValue(Float(items.amount), forKey: items.nutrientName)
            }
        }
        print (mainViewController.nutrients)
    }
}

//When user presses enter, do POST request with user input
extension AddFoods: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        userInput = String(searchBar.text!) //unwraps text
        requestObj.getFoods(userInput:userInput)
        displayFoods()
        
    }
}

//Outlets that are within the tableview cell.
class FoodCards : UITableViewCell {
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
}
