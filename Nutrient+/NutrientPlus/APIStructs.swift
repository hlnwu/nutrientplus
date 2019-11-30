//
//  Foods.swift
//  NutrientPlus
//
//  Created by Victor Ye on 10/31/19.
//  Copyright © 2019 hoo. All rights reserved.
//

import Foundation

//---------------------------------------Foods-------------------------------------
//Structure for json from doing getFoods

//The commented-out parameters in these structures are possible to be retrieved.
//But we have found no use for them (as of now).
struct FoodDescription: Decodable{
    //let foodSearchCriteria: Criteria
    //let totalHits: Int
    //let currentPage: Int
    //let totalPages: Int
    let foods: [Foods]
}

/*struct Criteria: Decodable{
 let generalSearchInput: String?
 let pageNumber: Int?
 let requireAllWords: Bool?
 }*/

struct Foods: Decodable{
    let fdcId: Int
    let description: String
    //let dataType: String?
    //let gtinUpc: String?
    //let ndbNumber: String?
    //let foodCode: String?
    //let publishedData: String?
    let brandOwner: String?
    //let ingredients: String?
    //let allHighlightFields: String?
    let score: Double?
}

struct foodInfo{
    var foodName : String
    var brandName : String
    var foodID : Int
}

//---------------------------------Nutrients----------------------------------------
//structure for json when doing getNutrients

struct NutrientDescription : Decodable{
    let foodClass: String
    let description: String
    let foodNutrients: [NutrientsArray]
    
    //These parameters are to grab the servingSize
    let servingSize: Double?
    let servingSizeUnit: String?
    let householdServingFullText: String?
}

struct NutrientsArray: Decodable{
    let type: String
    let id: Int
    let nutrient: Nutrients
    let amount: Double
}

struct Nutrients: Decodable{
    let id: Int
    let number: String
    let name: String
    let rank: Int
    let unitName: String
}

struct nutrientInfo{
    var amount: Double
    var unitName: String
    var nutrientName: String
    
}

