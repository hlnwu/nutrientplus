//
//  User+CoreDataProperties.swift
//  NutrientPlus
//
//  Created by hoo on 10/24/19.
//  Copyright © 2019 hoo. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var height: Int16
    @NSManaged public var weight: NSDecimalNumber?
    @NSManaged public var bodyFat: NSDecimalNumber?
    @NSManaged public var sex: String?
    @NSManaged public var birthday: Date?
}
