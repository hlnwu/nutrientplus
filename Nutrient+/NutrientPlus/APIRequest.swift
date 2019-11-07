//
//  APIRequests.swift
//  NutrientPlus
//
//  Created by Victor Ye on 11/1/19.
//  Copyright © 2019 hoo. All rights reserved.
//

import Foundation
struct APIRequest{
    let API_KEY = "LbcbTPKWh9DPSB2aMJnlOyABZKdtFAC9J2iheb0L"
    static let dispatchGroup = DispatchGroup() //Works sort of like a semaphore

    func getFoods(userInput: String) -> (Void){ //POST request to retrieve json of foods following APIStructs structure.
        APIRequest.dispatchGroup.enter() //mutex.lock
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
                    AddFoods.foodCards.append(card)
                
                }
                APIRequest.dispatchGroup.leave() //mutex.unlock
            } catch let jsonErr {
                print ("Error Serializing Json: ", jsonErr)
            }
        }.resume()
    }
    
    func getNutrients(foodID: Int) -> (Void){ //GET request to retrieve json of nutrients following APIStructs structure
        APIRequest.dispatchGroup.enter()
        AddFoods.nutrientCards = []
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
                    AddFoods.nutrientCards.append(card)
                }
                APIRequest.dispatchGroup.leave()
            } catch let jsonErr {
                print ("Error Serializing Json: ", jsonErr)
            }
        }.resume()
    }
}
