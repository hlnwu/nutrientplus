//
//  RecFoodImgAPI.swift
//  NutrientPlus
//
//  Created by DSCommons on 11/16/19.
//  Copyright © 2019 hoo. All rights reserved.
//

import Foundation

let googImgBaseURL = "https://www.google.com/search?tbm=isch&q="
let recFood = "banana"

let recFoodURL = URL(string: googImgBaseURL + recFood)!

let task = URLSession.shared.dataTask(with: recFoodURL) { (data, resp, error) in
    guard let data = data else {
        print("data was nil")
        return
    }
    
    guard let htmlString = String(data: data, encoding: String.Encoding.utf8) else {
        print("canot cast data into string")
        return
    }
    
    print(htmlString)
}
