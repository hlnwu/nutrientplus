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
    var foodCards: [foodInfo] = []
    var nutrientCards: [nutrientInfo] = []
    let dispatchGroup = DispatchGroup() //Works sort of like a semaphore
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodTableView.delegate = self
        foodTableView.dataSource = self
    }

    
    @IBAction func enterButton(_ sender: UIButton) { //When user presses enter, do POST request with user input
        userInput = String(editText.text!) //unwraps text
        getFoods(userInput: userInput)
        displayFoods()
    }
    
    func getFoods(userInput: String) -> (Void){ //POST request to retrieve json of foods following APIStructs structure.
        dispatchGroup.enter() //mutex.lock
        foodCards = [] //Makes sure tableView is clear
        
        //The following are the specifications for the POST request.
        let parameters = ["generalSearchInput":userInput]
        guard let urlPost = URL(string: "https://api.nal.usda.gov/fdc/v1/search?api_key=LbcbTPKWh9DPSB2aMJnlOyABZKdtFAC9J2iheb0L") else{ return }
        var request = URLRequest(url : urlPost)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return }
        request.httpBody = httpBody
        
        //The following is the URLSession or background service in which the API call happens.
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in //Do API call with specified request, and get data else fail.
            guard let data = data else { return }
            
            do {
                //JSONDecoder "translates" the data to follow the APIStructs structure, and sets this to foodDescription.
                let foodDescription = try JSONDecoder().decode(FoodDescription.self, from: data)
                
                //Loop through the "foods" array, and retrieve, store, and save as a card: the foodname, brandname, and foodID.
                for items in (foodDescription.foods){
                    let card = foodInfo(foodName: items.description, brandName: items.brandOwner ?? "N/A", foodID: items.fdcId)
                    self.foodCards.append(card)
                    
                }
                self.dispatchGroup.leave() //mutex.unlock
            } catch let jsonErr {
                print ("Error Serializing Json: ", jsonErr)
            }
        }.resume()
    }
    
    func getNutrients(foodID: Int) -> (Void){ //GET request to retrieve json of nutrients following APIStructs structure
        dispatchGroup.enter()
        nutrientCards = []
        let foodIDString = String(foodID)
        guard let urlGet = URL(string: "https://api.nal.usda.gov/fdc/v1/" + foodIDString + "?api_key=LbcbTPKWh9DPSB2aMJnlOyABZKdtFAC9J2iheb0L") else{ return }
        print (urlGet)
        let session = URLSession.shared
        session.dataTask(with: urlGet) {(data, response, error) in
            guard let data = data else { return }
            do {
                let nutrientDescription = try JSONDecoder().decode(NutrientDescription.self, from: data)
                for items in (nutrientDescription.foodNutrients){
                    let amount = items.amount
                    let unitName = items.nutrient.unitName
                    let nutrientName = items.nutrient.name
                    let card = nutrientInfo(amount: amount, unitName: unitName, nutrientName: nutrientName)
                    //print(card)
                    self.nutrientCards.append(card)
                }
                self.dispatchGroup.leave()
            } catch let jsonErr {
                print ("Error Serializing Json: ", jsonErr)
            }
            }.resume()
    }
    
    func printNutrients(){
        dispatchGroup.notify(queue: .main){ //BLOCK until mutex is freed.
            for i in self.nutrientCards{
                print (i.amount, i.unitName, i.nutrientName)
            }
        }
    }
    
    func displayFoods(){
        dispatchGroup.notify(queue: .main){
            for i in self.foodCards{
                print (i.foodName, i.brandName)
            }
            self.foodTableView.reloadData() //Update tablview
        }
    }
}

//Extension functions to make tableView recycle cells.
extension AddFoods: UITableViewDataSource, UITableViewDelegate{
    //Number of rows in tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodCards.count
    }
    
    //The following function iterates the tableView and sets each cell.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = foodTableView.dequeueReusableCell(withIdentifier: "FoodCards", for: indexPath) as! FoodCards
        let card = foodCards[indexPath.row]
        cell.foodNameLabel?.text = card.foodName
        cell.brandLabel?.text = card.brandName
        return cell
    }
    
    //The following function checks if a cell has been tapped.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let card = foodCards[indexPath.row] //Retrieve card of cell that was tapped.
        let foodID = card.foodID            //Get the foodID of the tapped cell.
        getNutrients(foodID: foodID)        //Do GET Request with the foodID to get nutrients
        printNutrients()
    }
}
