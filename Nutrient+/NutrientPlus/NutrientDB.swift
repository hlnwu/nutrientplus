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
    
    var database: Connection!
    
    let table = Table("Nutrients")
    
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
    

    do {
        //let pathURL = Bundle.main.url(forResource: "NutrientDB", ofType: "sqlite3")!
        //let dbPath = dbUrl.path
        //let db = try! Connection(dbPath)
        
        let path = Bundle.main.path(forResource: "NutrientDB", ofType: "sqlite3")!
        let database = try Connection(path, readonly: true)
        self.database = database
    } catch {
        print(error)
    }
    
    func listNutrients(){
        print("LISTING NUTRIENTS")
        
        for item in try database.prepare("Nutrients"){
            print("Description: \(item)[Description], fdcId: \(item)[fdcId]")
        }
        /*do {
            let test = try self.database.prepare(self.table)
            print(test)
        } catch{
            print(error)
        }
        */
    }

}
