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
    var nutrWeight: Int64
    var nutrTarget: Int64
    var nutrProgress: Int64

    init(nutrName: String) {
        self.nutrName = nutrName
        nutrWeight = 0
        nutrTarget = 0
        nutrProgress = 0
    }

    init(nutrName: String, nutrWeight: Int64, nutrTarget: Int64, nutrProgress: Int64) {
        self.nutrName = nutrName
        self.nutrWeight = nutrWeight
        self.nutrTarget = nutrTarget
        self.nutrProgress = nutrProgress
    }
}
