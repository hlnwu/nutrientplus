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

struct FoodDescription: Decodable{
    let foods: [Foods]
}

struct Foods: Decodable{
    let fdcId: Int
    let description: String
    let brandOwner: String?
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
    let description: String
    let foodNutrients: [NutrientsArray]
    
    //These parameters are to grab the servingSize
    let servingSize: Double?
    let servingSizeUnit: String?
    let householdServingFullText: String?
    
    let foodPortions: [FoodPortions]
}

struct NutrientsArray: Decodable{
    let nutrient: Nutrients
    let amount: Double?
}

struct Nutrients: Decodable{
    let name: String
    let unitName: String
}

struct FoodPortions: Decodable{
    let measureUnit: MeasureUnit
    let gramWeight: Double?
    let portionDescription: String?
    let amount: Double?
    let modifier: String?
}

struct MeasureUnit: Decodable{
    let name: String
}

struct nutrientInfo{
    var amount: Double
    var unitName: String
    var nutrientName: String
    
}

