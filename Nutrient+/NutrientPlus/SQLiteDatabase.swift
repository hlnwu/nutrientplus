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
  private let nutrWeight = Expression<Int64>("nutrWeight")
  private let nutrTarget = Expression<Int64>("nutrTarget")
  private let nutrProgress = Expression<Int64>("nutrProgress")
  
  private init() {
    print("calling init on the database")
    let path = NSSearchPathForDirectoriesInDomains(
        .documentDirectory, .userDomainMask, true
        ).first!

    do {
        db = try Connection("\(path)/Nutrients.sqlite3")
    } catch {
        db = nil
        print ("Unable to open database")
    }

    createTable()
  }

  func createTable() {
    print("calling createTable")
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
    func printStuff() {
        print("Hi! I am a function in SQLiteDatabase.swift!")
    }
    
    func addNutr(iName: String, iWeight: Int64, iTarget: Int64, iProgress: Int64) -> Int64? {
        do {
            let insert = nutrTable.insert(nutrName <- iName, nutrWeight <- iWeight, nutrTarget <- iTarget, nutrProgress <- iProgress)
            let id = try db!.run(insert)

            return id
        } catch {
            print("Insert failed")
            return -1
        }
    }
}
