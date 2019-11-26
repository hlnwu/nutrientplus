//
//  NutrientDB.swift
//  NutrientPlus
//
//  Created by DSCommons on 11/16/19.
//  Copyright © 2019 hoo. All rights reserved.
//


import Foundation
import UIKit
import SQLite

class NutrientDB{
    static let instance = NutrientDB()
    
    var database: Connection!
    
    let table = Table("NutrientsDB")
    
    let Description = Expression<String>("Description")
    let fdcId = Expression<Int>("fdcId")
    let Energy = Expression<Float>("Energy")
    let Protein = Expression<Float>("Protein")
    let Carbs = Expression<Float>("Carbs")
    let Fat = Expression<Float>("Fat")
    let B1 = Expression<Float>("B1")
    let B2 = Expression<Float>("B2")
    let B3 = Expression<Float>("B3")
    let B5 = Expression<Float>("B5")
    let B6 = Expression<Float>("B6")
    let B12 = Expression<Float>("B12")
    let Folate = Expression<Float>("Folate")
    let Vitamin_A = Expression<Float>("Vitamin A")
    let Vitamin_C = Expression<Float>("Vitamin C")
    let Vitamin_D = Expression<Float>("Vitamin D")
    let Vitamin_E = Expression<Float>("Vitamin E")
    let Vitamin_K = Expression<Float>("Vitamin K")
    let Calcium = Expression<Float>("Calcium")
    let Copper = Expression<Float>("Copper")
    let Iron = Expression<Float>("Iron")
    let Magnesium = Expression<Float>("Magnesium")
    let Manganese = Expression<Float>("Manganese")
    let Phosphorus = Expression<Float>("Phosphorus")
    let Potassium = Expression<Float>("Potassium")
    let Selenium = Expression<Float>("Selenium")
    let Sodium = Expression<Float>("Sodium")
    let Zinc = Expression<Float>("Zinc")
    let Sugar = Expression<Float>("Sugar")
    let Fiber = Expression<Float>("Fiber")
    
    let path = Bundle.main.path(forResource: "NutrientDB", ofType: "sqlite3")!
    
    func test(){
        do {
            database = try Connection(path, readonly: true)
            print("Worked")
            //try db.key("")
        } catch {
            print(error)
        }
    }

    //MVP function
    func printRemainingNutrients(nutrientNeeded: String, amountNeeded: Float){
        print("PRINTING REMAINING NUTRIENTS")
        //loop through SQLiteDB.getNutr() and then
        do{
            //let query = table.select(Description).filter(Protein > 10.0).limit(5, offset: 1)
            let query = "SELECT * FROM Nutrients WHERE " + nutrientNeeded + " >= " + String(amountNeeded) + " LIMIT 5"
            let ans = try database.prepare(query)
            for row in ans{
                print(row)
            }
            print(ans)
            print("worked")
        } catch{
            print("FAILED")
        }
    }
}
