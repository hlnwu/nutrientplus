//
//  DestinationViewController.swift
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

class DestinationViewController: UIViewController {
    @IBOutlet weak var foodTableView: UITableView!
    @IBOutlet weak var editText: UITextField!
    
    var userInput : String = ""
    var foodCards: [foodInfo] = []
    var nutrientCards: [nutrientInfo] = []
    let dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        foodTableView.delegate = self
        foodTableView.dataSource = self
    }
    

    
    @IBAction func enterButton(_ sender: UIButton) {
        userInput = String(editText.text!) //unwraps text
        getFoods(userInput: userInput)
        displayFoods()
    }
    
    func getNutrients(foodID: Int) -> (Void){
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
    
    func getFoods(userInput: String) -> (Void){
        dispatchGroup.enter()
        foodCards = []
        
        let parameters = ["generalSearchInput":userInput]
        guard let urlPost = URL(string: "https://api.nal.usda.gov/fdc/v1/search?api_key=LbcbTPKWh9DPSB2aMJnlOyABZKdtFAC9J2iheb0L") else{ return }
        var request = URLRequest(url : urlPost)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            
            do {
                let foodDescription = try JSONDecoder().decode(FoodDescription.self, from: data)
                for items in (foodDescription.foods){
                    let card = foodInfo(foodName: items.description, brandName: items.brandOwner ?? "N/A", foodID: items.fdcId)
                    self.foodCards.append(card)
                    
                }
                self.dispatchGroup.leave()
            } catch let jsonErr {
                print ("Error Serializing Json: ", jsonErr)
            }
        }.resume()
    }
    
    func printNutrients(){
        dispatchGroup.notify(queue: .main){
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
            self.foodTableView.reloadData()
        }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let card = foodCards[indexPath.row]
        let foodID = card.foodID
        getNutrients(foodID: foodID)
        printNutrients()
    }
}
