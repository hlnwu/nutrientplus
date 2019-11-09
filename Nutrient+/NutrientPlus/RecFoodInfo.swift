//
//  RecFoodInfo.swift
//  NutrientPlus
//
//  Created by hoo on 11/5/19.
//  Copyright © 2019 hoo. All rights reserved.
//
// https:// www.youtube.com/watch?v=DmWv-JtQH4Q&t=708s

import UIKit

class RecFoodInfo: UIViewController {

    // used when user ate recommended food
    @IBOutlet weak var ateRecFood: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismissPopup(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
