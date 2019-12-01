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

    //var nutrientArray = [NutrientStruct]()
  /*
    lazy var ProteinStruct = NutrientStruct(nutrName: "Protein", nutrWeight: 600, nutrTarget: 60.0, nutrProgress: 48.0)
    lazy var CarbsStruct = NutrientStruct(nutrName: "Carbs", nutrWeight: 1110, nutrTarget: 300.0, nutrProgress: 240.0)
    lazy var FatStruct = NutrientStruct(nutrName: "Fat", nutrWeight: 800, nutrTarget: 60.0, nutrProgress: 48.0)
    lazy var B1Struct = NutrientStruct(nutrName: "B1", nutrWeight: 6400, nutrTarget: 1.2, nutrProgress: 0.96)
    lazy var B2Struct = NutrientStruct(nutrName: "B2", nutrWeight: 6500, nutrTarget: 1.3, nutrProgress: 1.04)
    lazy var B3Struct = NutrientStruct(nutrName: "B3", nutrWeight: 6600, nutrTarget: 25.0, nutrProgress: 20.0)
    lazy var B5Struct = NutrientStruct(nutrName: "B5", nutrWeight: 6700, nutrTarget: 7.0, nutrProgress: 5.6)
    lazy var B6Struct = NutrientStruct(nutrName: "B6", nutrWeight: 6800, nutrTarget: 1.3, nutrProgress: 1.04)
    lazy var B12Struct = NutrientStruct(nutrName: "B12", nutrWeight: 7300, nutrTarget: 2.4, nutrProgress: 1.92)
    lazy var FolateStruct = NutrientStruct(nutrName: "Folate", nutrWeight: 6900, nutrTarget: 400.0, nutrProgress: 320.0)
    lazy var VitaminAStruct = NutrientStruct(nutrName: "Vitamin_A", nutrWeight: 7500, nutrTarget: 75.0, nutrProgress: 60.0)
    lazy var VitaminCStruct = NutrientStruct(nutrName: "Vitamin_C", nutrWeight: 6300, nutrTarget: 85.0, nutrProgress: 67.0)
    lazy var VitaminDStruct = NutrientStruct(nutrName: "Vitamin_D", nutrWeight: 8750, nutrTarget: 800.0, nutrProgress: 640.0)
    lazy var VitaminEStruct = NutrientStruct(nutrName: "Vitamin_E", nutrWeight: 7905, nutrTarget: 46.0, nutrProgress: 36.8)
    lazy var VitaminKStruct = NutrientStruct(nutrName: "Vitamin_K", nutrWeight: 8800, nutrTarget: 120.0, nutrProgress: 96.0)
    lazy var CalciumStruct = NutrientStruct(nutrName: "Calcium", nutrWeight: 5300, nutrTarget: 1100.0, nutrProgress: 880.0)
    lazy var CopperStruct = NutrientStruct(nutrName: "Copper", nutrWeight: 6000, nutrTarget: 1.2, nutrProgress: 0.96)
    lazy var IronStruct = NutrientStruct(nutrName: "Iron", nutrWeight: 5400, nutrTarget: 15.0, nutrProgress: 12.0)
    lazy var MagnesiumStruct = NutrientStruct(nutrName: "Magnesium", nutrWeight: 5500, nutrTarget: 400.0, nutrProgress: 320.0)
    lazy var ManganeseStruct = NutrientStruct(nutrName: "Manganese", nutrWeight: 6100, nutrTarget: 2.3, nutrProgress: 1.84)
    lazy var PhosphorusStruct = NutrientStruct(nutrName: "Phosphorus", nutrWeight: 5600, nutrTarget: 1000.0, nutrProgress: 800.0)
    lazy var PotassiumStruct = NutrientStruct(nutrName: "Potassium", nutrWeight: 5700, nutrTarget: 4500.0, nutrProgress: 3600.0)
    lazy var SeleniumStruct = NutrientStruct(nutrName: "Selenium", nutrWeight: 6200, nutrTarget: 400.0, nutrProgress: 320.0)
    lazy var SodiumStruct = NutrientStruct(nutrName: "Sodium", nutrWeight: 5800, nutrTarget: 2300.0, nutrProgress: 1840.0)
    lazy var ZincStruct = NutrientStruct(nutrName: "Zinc", nutrWeight: 5900, nutrTarget: 11.0, nutrProgress: 8.8)
    lazy var SugarStruct = NutrientStruct(nutrName: "Sugar", nutrWeight: 1510, nutrTarget: 37.5, nutrProgress: 30.0)
    lazy var FiberStruct = NutrientStruct(nutrName: "Fiber", nutrWeight: 1200, nutrTarget: 25.0, nutrProgress: 20.0)

    var nutrientArray = [ProteinStruct, CarbsStruct, FatStruct, B1Struct, B2Struct, B3Struct, B5Struct, B6Struct, B12Struct, FolateStruct, VitaminAStruct, VitaminCStruct, VitaminDStruct, VitaminEStruct, VitaminKStruct, CalciumStruct, CopperStruct, IronStruct, MagnesiumStruct, ManganeseStruct, PhosphorusStruct, PotassiumStruct, SeleniumStruct, SodiumStruct, ZincStruct, SugarStruct, FiberStruct]
 */


    var nutrientArray = ["Protein", "Carbs", "Fat", "B1", "B2", "B3", "B5", "B6", "B12", "Folate", "Vitamin A", "Vitamin C", "Vitamin D", "Vitamin E", "Vitamin K", "Calcium", "Copper", "Iron", "Magnesium", "Manganese", "Phosphorus", "Potassium", "Selenium", "Sodium", "Zinc", "Sugar", "Fiber"]
    
    var weightArray = [600, 1110, 800, 6400, 6500, 6600, 6700, 6800, 7300, 6900, 7500, 6300, 8750, 7905, 8800, 5300, 6000, 5400, 5500, 6100, 5600, 5700, 6200, 5800, 5900, 1510, 120]
   /*
    //let EnergyWeight = 300      //KCal
    let ProteinWeight = 600     //G
    let CarbsWeight = 1110      //G
    let FatWeight = 800         //G
    let B1Weight = 6400         //Mg
    let B2Weight = 6500         //Mg
    let B3Weight = 6600         //Mg
    let B5Weight = 6700         //Mg
    let B6Weight = 6800         //Mg
    let B12Weight = 7300        //Ug
    let FolateWeight = 6900     //Ug
    let Vitamin_AWeight = 7500  //IU
    let Vitamin_CWeight = 6300  //MG
    let Vitamin_DWeight = 8750  //IU
    let Vitamin_EWeight = 7905  //MG
    let Vitamin_KWeight = 8800  //UG
    let CalciumWeight = 5300    //Mg
    let CopperWeight = 6000     //Mg
    let IronWeight = 5400       //Mg
    let MagnesiumWeight = 5500  //Mg
    let ManganeseWeight = 6100  //Mg
    let PhosphorusWeight = 5600 //Mg
    let PotassiumWeight = 5700  //Mg
    let SeleniumWeight = 6200   //Ug
    let SodiumWeight = 5800     //Mg
    let ZincWeight = 5900       //Mg
    let SugarWeight = 1510      //G
    let FiberWeight = 1200      //G
    */
    
    

    //var weighted: [Int]
    //let nutrientWeight = []

    let path = Bundle.main.path(forResource: "proteinDB", ofType: "sqlite3")!
    
    private init(){
        do {
            database = try Connection(path, readonly: true)
            
            print("Worked")
        } catch {
            print(error)
        }
    }

    
    //MVP function
    func printRemainingNutrients(){
        var maxPower:Double = 0.0
        var maxFdcID:Int64 = 0
        print("PRINTING REMAINING NUTRIENTS")
        //loop through SQLiteDB.getNutr() and then

        for nutrientName in nutrientArray{
            //let nutrientRemaining = 10.0
            do{
                let query = "SELECT DISTINCT * FROM proteinV2 WHERE '" + nutrientName + "' >= 10 ORDER BY '" + nutrientName + "' DESC LIMIT 5"
                let ans = try database.prepare(query)
                
                //Is not going over more important or finishing goals?
                for row in ans{
                    var totalPower = 0.0
                    for i in 5...31 {
                        //let nutrCasted:Double = row[i]! as
                        totalPower = totalPower + (row[i]! as! Double) * Double(weightArray[i-5])
                    }
                    print(totalPower, row[0]! as! String)
                    if (totalPower > maxPower){
                        maxPower = totalPower
                        maxFdcID = row[1]! as! Int64
                        print ("New Max: ", row[0]! as! String, maxPower)
                    }
                    //print(row[0]! as! String, totalPower)

                    /*
                    let Description:String = row[0]! as! String
                    let fdcID:Int64 = row[1]! as! Int64
                    let servingSize:Double = row[2]! as! Double
                    let servingSizeFullText:String = row[3]! as! String
                    let Energy:Double = row[4]! as! Double        //300
                    let Protein:Double = row[5]! as! Double       //600
                    let Carbs:Double = row[6]! as! Double        //1110
                    let Fat:Double = row[7]! as! Double          //800
                    let B1:Double = row[8]! as! Double           //6400
                    let B2:Double = row[9]! as! Double           //6500
                    let B3:Double = row[10]! as! Double           //6600
                    let B5:Double = row[11]! as! Double           //6700
                    let B6:Double = row[12]! as! Double          //6800
                    let B12:Double = row[13]! as! Double         //7300
                    let Folate:Double = row[14]! as! Double     //6900
                    let Vitamin_A:Double = row[15]! as! Double   //7500
                    let Vitamin_C:Double = row[16]! as! Double   //6300
                    let Vitamin_D:Double = row[17]! as! Double   //8750
                    let Vitamin_E:Double = row[18]! as! Double   //7905
                    let Vitamin_K:Double = row[19]! as! Double   //8800
                    let Calcium:Double = row[20]! as! Double     //5300
                    let Copper:Double = row[21]! as! Double      //6000
                    let Iron:Double = row[22]! as! Double        //5400
                    let Magnesium:Double = row[23]! as! Double    //5500
                    let Manganese:Double = row[24]! as! Double   //6100
                    let Phosphorus:Double = row[25]! as! Double  //5600
                    let Potassium:Double = row[26]! as! Double   //5700
                    let Selenium:Double = row[27]! as! Double    //6200
                    let Sodium:Double = row[28]! as! Double       //5800
                    let Zinc:Double = row[29]! as! Double         //5900
                    let Sugar:Double = row[30]! as! Double        //1510
                    let Fiber:Double = row[31]! as! Double        //1200
                    
                    //print(Description, fdcID, servingSize, servingSizeFullText, Energy, Protein, Carbs, Fat, B1, B2, B3, B5, B6, B12, Folate, Vitamin_A, Vitamin_C, Vitamin_D, Vitamin_E, Vitamin_K, Calcium, Copper, Iron, Magnesium, Manganese, Phosphorus, Potassium, Selenium, Sodium, Zinc, Sugar, Fiber)
                    
                    for item in nutrientArray{
                        print(item)
                    }*/
                    
                    
                }
                //print(ans)

            }catch{
                print("FAILED")
            }
        }
    }
}
