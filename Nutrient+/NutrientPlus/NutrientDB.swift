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

    let nutrDB = SQLiteDatabase.instance
    var nutrientArray = ["Protein", "Carbs", "Fat", "B1", "B2", "B3", "B5", "B6", "B12", "Folate", "VitaminA", "VitaminC", "VitaminD", "VitaminE", "VitaminK", "Calcium", "Copper", "Iron", "Magnesium", "Manganese", "Phosphorus", "Potassium", "Selenium", "Sodium", "Zinc"]
    
    var weightArray = [600, 1110, 800, 6400, 6500, 6600, 6700, 6800, 7300, 6900, 7500, 6300, 8750, 7905, 8800, 5300, 6000, 5400, 5500, 6100, 5600, 5700, 6200, 5800, 5900]


    var nutrDict = [String:NutrientStruct]()

    let path = Bundle.main.path(forResource: "allNutrientsDB", ofType: "sqlite3")!
    
    private init(){
        do {
            database = try Connection(path, readonly: true)
        } catch {
            print(error)
        }
    }
    
    
    
    
    //MVP function
    func printRemainingNutrients() -> [String]{
        var maxPower:Double = 0.0
        var returnArray:[String] = []
        nutrDict = nutrDB.getNutrDict()
        outer: for nutrientName in nutrientArray{
            do{
                if nutrDict[nutrientName]!.nutrProgress >= 1.1 * nutrDict[nutrientName]!.nutrTarget{
                    continue
                }
                
                //Fraction of max nutrients that we want to eat.
                let nutrientPercentNeeded = nutrDict[nutrientName]!.nutrTarget * 1.25 - nutrDict[nutrientName]!.nutrProgress
                let query = "SELECT DISTINCT * FROM allNutrients WHERE " + String(nutrientName) + " <= " + String(nutrientPercentNeeded) + " ORDER BY " + String(nutrientName) + " DESC LIMIT 10"
                let ans = try database.prepare(query)
                
                
                for row in ans{
                    
                    //totalPower is total score if were to consume food.
                    var totalPower = 0.0
                    
                    
                    
                    //Loops through the different columns of query results
                    //Ignore 0-8 because they are macros/misc.
                    for columnNutrientInDB in 8...29 {
                        
                        //Theorectical fraction of nutrient progress
                        var percentCompleted = (row[columnNutrientInDB]! as? Double ?? Double(row[columnNutrientInDB]! as! Int64) + nutrDict[nutrientArray[columnNutrientInDB-5]]!.nutrProgress)/nutrDict[nutrientArray[columnNutrientInDB-5]]!.nutrTarget
                        
                        if percentCompleted > 1.25{
                            continue outer
                        }
                        
                        //If nutrient progress is more than 110%, ignore nutrient
                        if percentCompleted > 1.0 {
                            percentCompleted = 1.0
                        }
                        //Algorithm to compute totalPower
                        totalPower = totalPower + (percentCompleted * (1.0 / Double(weightArray[columnNutrientInDB - 5])))
                    }
                    
                    //Keeps track of new maxes throughout loop and saves its data in a String array.
                    if (totalPower > maxPower) {
                        maxPower = totalPower
                        
                        returnArray.removeAll()
                        returnArray.append(row[0]! as! String)
                        returnArray.append(String(row[2]! as? Double ?? Double(row[2]! as! Int64)))
                        returnArray.append(row[3]! as! String)
                        for j in 4...29 {
                                returnArray.append(String(row[j]! as? Double ?? Double(row[j]! as! Int64)))
                        }
                    }
                }

            }catch{
                print("FAILED")
            }
        }
        return returnArray

    }
}
