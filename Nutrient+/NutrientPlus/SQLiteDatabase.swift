//
//  SQLiteDatabase.swift
//  NutrientPlus
//
//  Created by DSCommons on 11/21/19.
//  Copyright © 2019 hoo. All rights reserved.
//

import Foundation
import SQLite

class SQLiteDatabase {
  static let instance = SQLiteDatabase()
  private let db: Connection?
  
  private let nutrTable = Table("nutrTable")
  private let nutrName = Expression<String>("nutrName")
  private let nutrWeight = Expression<Double>("nutrWeight")
  private let nutrTarget = Expression<Double>("nutrTarget")
  private let nutrProgress = Expression<Double>("nutrProgress")
  
  private init() {
    let path = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true
        ).first!

    do {
        db = try Connection("\(path)/NutrientPluwt.sqlite3")
    } catch {
        db = nil
        print ("Unable to open database")
    }

    createTable()
  }

  func createTable() {
    do {
        try db!.run(nutrTable.create(ifNotExists: true) { table in
        table.column(nutrName, primaryKey: true)
        table.column(nutrWeight)
        table.column(nutrTarget)
        table.column(nutrProgress)
        })
    } catch {
        print("Unable to create table")
    }
  }
    
    //INSERT INTO "nutrTable" ("nutrName", "nutrWeight", "nutrTarget", "nutrProgress") VALUES (nutrProgress, iWeight, iWeight, iProgress)
    func addNutr(iName: String, iWeight: Double, iTarget: Double, iProgress: Double) -> Int64? {
        do {
            let insert = nutrTable.insert(nutrName <- iName, nutrWeight <- iWeight, nutrTarget <- iTarget, nutrProgress <- iProgress)
            let id = try db!.run(insert)
            return id
        } catch {
            //print("Insert failed")
            return -1
        }
    }
    
    //SELECT * FROM "nutrTable"
    func getNutr() -> [NutrientStruct] {
        var nutrientArray = [NutrientStruct]()
        do {
            for nutrient in try db!.prepare(self.nutrTable) {
                nutrientArray.append(NutrientStruct(
                nutrName: nutrient[nutrName],
                nutrWeight: nutrient[nutrWeight],
                nutrTarget: nutrient[nutrTarget],
                nutrProgress: nutrient[nutrProgress]))
            }
        } catch {
            print("Select failed")
        }

        return nutrientArray
    }
    
    func getNutrDict() -> Dictionary<String, NutrientStruct> {
        var nutrientArray = [String:NutrientStruct]()
        do {
            for nutrient in try db!.prepare(self.nutrTable) {
                nutrientArray[nutrient[nutrName]] = NutrientStruct(
                    nutrName: nutrient[nutrName],
                    nutrWeight: nutrient[nutrWeight],
                    nutrTarget: nutrient[nutrTarget],
                    nutrProgress: nutrient[nutrProgress])
            }
        } catch {
            print("Select failed")
        }
        
        return nutrientArray
    }
    
    
    
    //function for printing the contents of the nutrTable
    func printNutrTable() {
        var storedNutrientData = [NutrientStruct]()
        storedNutrientData = getNutr()
        for nutrient in storedNutrientData {
            print("Name: \(nutrient.nutrName), Weight: \(nutrient.nutrWeight), Target: \(nutrient.nutrTarget), Progress: \(nutrient.nutrProgress)")
        }
    }
    
    func updateWeight(iName: String, iWeight: Double) -> Bool {
        let nutrient = nutrTable.filter(nutrName == iName)
        do {
            let update = nutrient.update([
                nutrName <- iName,
                nutrWeight <- iWeight
                ])
            if try db!.run(update) > 0 {
                return true
            }
        } catch {
            print("Update failed: \(error)")
        }

        return false
    }
    
    func updateTarget(iName: String, iTarget: Double) {
        let nutrient = nutrTable.filter(nutrName == iName)
        do {
            let update = nutrient.update([
                nutrName <- iName,
                nutrTarget <- iTarget
                ])
            if try db!.run(update) > 0 {
//                return true
            }
        } catch {
            print("Update failed: \(error)")
        }

//        return false
    }
    
    func updateProgress(iName: String, iProgress: Double) -> Bool {
        let nutrient = nutrTable.filter(nutrName == iName)
        do {
            let update = nutrient.update([
                nutrName <- iName,
                nutrProgress <- iProgress
                ])
            if try db!.run(update) > 0 {
                return true
            }
        } catch {
            print("Update failed: \(error)")
        }

        return false
    }
    
    
    func deleteTable() {
        do {
            for nutrient in try db!.prepare(self.nutrTable) {
                if !deleteNutrient(iName: nutrient[nutrName]) {//delete failed
                    print("deleteNutrient\(nutrient[nutrName]) failed")
                }
            }
        }
        catch {
            print("deleteTable() failed")
        }
    }
    
    func deleteNutrient(iName: String) -> Bool {
        do {
            let nutrient = nutrTable.filter(nutrName == iName)
            try db!.run(nutrient.delete())
            return true
        } catch {
            print("Delete failed")
        }
        return false
    }
}
