//
//  ViewController.swift
//  fwrdto.me-ios
//
//  Created by Valentin on 11/07/2017.
//  Copyright © 2017 Valentin Polo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults(suiteName: "group.xyz.valentin.fwrdto-me");
        defaults?.set("FAKE-API-KEY-HERE", forKey: "API_KEY");
        defaults?.synchronize();        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

