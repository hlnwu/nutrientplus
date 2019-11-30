//
//  NutrientStruct.swift
//  NutrientPlus
//
//  Created by DSCommons on 11/22/19.
//  Copyright © 2019 hoo. All rights reserved.
//
import Foundation

class NutrientStruct {
    var nutrName: String
    var nutrWeight: Int
    var nutrTarget: Double
    var nutrProgress: Double
    
/*
    init(nutrName: String, nutrWeight: Int) {
        self.nutrName = nutrName
        self.nutrWeight = nutrWeight
        nutrTarget = 0
        nutrProgress = 0
    }
*/
    init(nutrName: String, nutrWeight: Int, nutrTarget: Double, nutrProgress: Double) {
        self.nutrName = nutrName
        self.nutrWeight = nutrWeight
        self.nutrTarget = nutrTarget
        self.nutrProgress = nutrProgress
    }
}
