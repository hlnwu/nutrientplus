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
    var nutrientArray = ["Energy", "Protein", "Carbs", "Fat", "B1", "B2", "B3", "B5", "B6", "B12", "Folate", "Vitamin_A", "Vitamin_C", "Vitamin_D", "Vitamin_E", "Vitamin_K", "Calcium", "Copper", "Iron", "Magnesium", "Manganese", "Phosphorus", "Potassium", "Selenium", "Sodium", "Zinc", "Sugar", "Fiber"]
    
    /*
    let EnergyStruct = NutrientStruct(nutrName: "Energy", nutrWeight: 300, nutrTarget: <#T##Double#>, nutrProgress: <#T##Double#>)
    let ProteinStruct = NutrientStruct(nutrName: "Protein", nutrWeight: <#T##Int#>, nutrTarget: <#T##Double#>, nutrProgress: <#T##Double#>)
    let ProteinStruct = NutrientStruct(nutrName: <#T##String#>, nutrWeight: <#T##Int#>, nutrTarget: <#T##Double#>, nutrProgress: <#T##Double#>)
    let ProteinStruct = NutrientStruct(nutrName: <#T##String#>, nutrWeight: <#T##Int#>, nutrTarget: <#T##Double#>, nutrProgress: <#T##Double#>)
    let ProteinStruct = NutrientStruct(nutrName: <#T##String#>, nutrWeight: <#T##Int#>, nutrTarget: <#T##Double#>, nutrProgress: <#T##Double#>)
    let ProteinStruct = NutrientStruct(nutrName: <#T##String#>, nutrWeight: <#T##Int#>, nutrTarget: <#T##Double#>, nutrProgress: <#T##Double#>)
    let ProteinStruct = NutrientStruct(nutrName: <#T##String#>, nutrWeight: <#T##Int#>, nutrTarget: <#T##Double#>, nutrProgress: <#T##Double#>)
    let ProteinStruct = NutrientStruct(nutrName: <#T##String#>, nutrWeight: <#T##Int#>, nutrTarget: <#T##Double#>, nutrProgress: <#T##Double#>)
    let ProteinStruct = NutrientStruct(nutrName: <#T##String#>, nutrWeight: <#T##Int#>, nutrTarget: <#T##Double#>, nutrProgress: <#T##Double#>)
    let ProteinStruct = NutrientStruct(nutrName: <#T##String#>, nutrWeight: <#T##Int#>, nutrTarget: <#T##Double#>, nutrProgress: <#T##Double#>)
    let ProteinStruct = NutrientStruct(nutrName: <#T##String#>, nutrWeight: <#T##Int#>, nutrTarget: <#T##Double#>, nutrProgress: <#T##Double#>)
    let ProteinStruct = NutrientStruct(nutrName: <#T##String#>, nutrWeight: <#T##Int#>, nutrTarget: <#T##Double#>, nutrProgress: <#T##Double#>)
    let ProteinStruct = NutrientStruct(nutrName: <#T##String#>, nutrWeight: <#T##Int#>, nutrTarget: <#T##Double#>, nutrProgress: <#T##Double#>)
    let ProteinStruct = NutrientStruct(nutrName: <#T##String#>, nutrWeight: <#T##Int#>, nutrTarget: <#T##Double#>, nutrProgress: <#T##Double#>)
    let ProteinStruct = NutrientStruct(nutrName: <#T##String#>, nutrWeight: <#T##Int#>, nutrTarget: <#T##Double#>, nutrProgress: <#T##Double#>)
    let ProteinStruct = NutrientStruct(nutrName: <#T##String#>, nutrWeight: <#T##Int#>, nutrTarget: <#T##Double#>, nutrProgress: <#T##Double#>)
    */
    let EnergyWeight = 300      //KCal
    let ProteinWeight = 600     //G
    let CarbsWeight = 1110      //G
    let FatWeight = 800         //G
    let B1Weight = 6400         //Mg
    let B2Weight = 6500         //Mg
    let B3Weight = 6600         //Mg
    let B5Weight = 6700         //Mg
    let B6Weight = 6800         //Mg
    let B12Weight = 7300        //Ug
    let FolateWeight = 6900
    let Vitamin_AWeight = 7500
    let Vitamin_CWeight = 6300
    let Vitamin_DWeight = 8750
    let Vitamin_EWeight = 7905
    let Vitamin_KWeight = 8800
    let CalciumWeight = 5300
    let CopperWeight = 6000
    let IronWeight = 5400
    let MagnesiumWeight = 5500
    let ManganeseWeight = 6100
    let PhosphorusWeight = 5600
    let PotassiumWeight = 5700
    let SeleniumWeight = 6200
    let SodiumWeight = 5800
    let ZincWeight = 5900
    let SugarWeight = 1510
    let FiberWeight = 1200
    //var weighted: [Int]
    //let nutrientWeight = []
/*
    let table = Table("NutrientsDB")
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
    func printRemainingNutrients(){
        print("PRINTING REMAINING NUTRIENTS")
        //loop through SQLiteDB.getNutr() and then

        for nutrientName in nutrientArray{
            let nutrientRemaining = 10.0
            do{
                let query = "SELECT DISTINCT * FROM Nutrients WHERE " + nutrientName + " <= " + nutrientRemaining + " ORDER BY " + nutrientName + " DESC LIMIT 5"
                let ans = try database.prepare(query)
                
                    //Is not going over more important or finishing goals?
                for row in ans{
                        let Description = row[0]!
                        let fdcID = row[1]!
                        let Energy = row[2]!        //300
                        let Protein = row[3]!       //600
                        let Carbs = row[4]!         //1110
                        let Fat = row[5]!           //800
                        let B1 = row[6]!            //6400
                        let B2 = row[7]!            //6500
                        let B3 = row[8]!            //6600
                        let B5 = row[9]!            //6700
                        let B6 = row[10]!           //6800
                        let B12 = row[11]!          //7300
                        let Folate = row[12]!       //6900
                        let Vitamin_A = row[13]!    //7500
                        let Vitamin_C = row[14]!    //6300
                        let Vitamin_D = row[15]!    //8750
                        let Vitamin_E = row[16]!    //7905
                        let Vitamin_K = row[17]!    //8800
                        let Calcium = row[18]!      //5300
                        let Copper = row[19]!       //6000
                        let Iron = row[20]!         //5400
                        let Magnesium = row[21]!    //5500
                        let Manganese = row[22]!    //6100
                        let Phosphorus = row[23]!   //5600
                        let Potassium = row[24]!    //5700
                        let Selenium = row[25]!     //6200
                        let Sodium = row[26]!       //5800
                        let Zinc = row[27]!         //5900
                        let Sugar = row[28]!        //1510
                        let Fiber = row[29]!        //1200
                    
                        let test = Energy + 100
                        print(test)
                        print(Description, fdcID, Energy, Protein, Carbs, Fat, B1, B2, B3, B5, B6, B12, Folate, Vitamin_A, Vitamin_C, Vitamin_D, Vitamin_E, Vitamin_K, Calcium, Copper, Iron, Magnesium, Manganese, Phosphorus, Potassium, Selenium, Sodium, Zinc, Sugar, Fiber)
                }
            }catch{
                print("FAILED")
            }
            
            
            //print(ans)
            //print("worked")
        }
    }
}
