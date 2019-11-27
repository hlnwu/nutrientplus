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
    var weightedFoods = [String: Int]()
    
    let table = Table("NutrientsDB")
    /*
    let Description = Expression<String>("Description")
    let fdcId = Expression<Int>("fdcId")
    let Energy = Expression<Double>("Energy")
    let Protein = Expression<Double>("Protein")
    let Carbs = Expression<Double>("Carbs")
    let Fat = Expression<Double>("Fat")
    let B1 = Expression<Double>("B1")
    let B2 = Expression<Double>("B2")
    let B3 = Expression<Double>("B3")
    let B5 = Expression<Double>("B5")
    let B6 = Expression<Double>("B6")
    let B12 = Expression<Double>("B12")
    let Folate = Expression<Double>("Folate")
    let Vitamin_A = Expression<Double>("Vitamin A")
    let Vitamin_C = Expression<Double>("Vitamin C")
    let Vitamin_D = Expression<Double>("Vitamin D")
    let Vitamin_E = Expression<Double>("Vitamin E")
    let Vitamin_K = Expression<Double>("Vitamin K")
    let Calcium = Expression<Double>("Calcium")
    let Copper = Expression<Double>("Copper")
    let Iron = Expression<Double>("Iron")
    let Magnesium = Expression<Double>("Magnesium")
    let Manganese = Expression<Double>("Manganese")
    let Phosphorus = Expression<Double>("Phosphorus")
    let Potassium = Expression<Double>("Potassium")
    let Selenium = Expression<Double>("Selenium")
    let Sodium = Expression<Double>("Sodium")
    let Zinc = Expression<Double>("Zinc")
    let Sugar = Expression<Double>("Sugar")
    let Fiber = Expression<Double>("Fiber")
    */
    let path = Bundle.main.path(forResource: "NutrientDB", ofType: "sqlite3")!
    
    private init(){
        do {
            database = try Connection(path, readonly: true)
            
            //print(table.filter(1))
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

            let query = "SELECT DISTINCT * FROM Nutrients WHERE " + nutrientNeeded + " >= " + String(amountNeeded) + " ORDER BY " + nutrientNeeded + " DESC LIMIT 5"
            let ans = try database.prepare(query)
            //let test = try ans.scalar() as! String
            for row in ans{
                let Description = row[0]!
                let Energy = row[2]!
                let Protein = row[3]!
                let Carbs = row[4]!
                let Fat = row[5]!
                let B1 = row[6]!
                let B2 = row[7]!
                let B3 = row[8]!
                let B5 = row[9]!
                let B6 = row[10]!
                let B12 = row[11]!
                let Folate = row[12]!
                let Vitamin_A = row[13]!
                let Vitamin_C = row[14]!
                let Vitamin_D = row[15]!
                let Vitamin_E = row[16]!
                let Vitamin_K = row[17]!
                let Calcium = row[18]!
                let Copper = row[19]!
                let Iron = row[20]!
                let Magnesium = row[21]!
                let Manganese = row[22]!
                let Phosphorus = row[23]!
                let Potassium = row[24]!
                let Selenium = row[25]!
                let Sodium = row[26]!
                let Zinc = row[27]!
                let Sugar = row[28]!
                let Fiber = row[29]!
                
                print(Description, Energy, Protein, Carbs, Fat, B1, B2, B3, B5, B6, B12, Folate, Vitamin_A, Vitamin_C, Vitamin_D, Vitamin_E, Vitamin_K, Calcium, Copper, Iron, Magnesium, Manganese, Phosphorus, Potassium, Selenium, Sodium, Zinc, Sugar, Fiber)
                
                //nutrientDB
            }
            
            
            print(ans)
            //print("worked")
        } catch{
            print("FAILED")
        }
    }
}
