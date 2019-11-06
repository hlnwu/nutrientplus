//
//  UserInfo.swift
//  NutrientPlus
//
//  Created by hoo on 10/29/19.
//  Copyright © 2019 hoo. All rights reserved.
//
// currently not used
// simply reference for fetching data from Core Data

import Foundation
import UIKit
import CoreData

class UserInfo: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var user = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        
        do {
            let user = try PersistenceService.context.fetch(fetchRequest)
            for item in user {
                print(item.value(forKey: "sex") ?? 0)
            }
//            self.user = user
//            self.tableView.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}
