//
//  ViewController.swift
//  fwrdto.me-ios
//
//  Created by Valentin on 11/07/2017.
//  Copyright © 2017 Valentin Polo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var previewLabel: UILabel!
    @IBOutlet weak var previewSwitch: UISwitch!
    @IBOutlet weak var queuedLabel: UILabel!
    @IBOutlet weak var queuedSwitch: UISwitch!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        ApiKey.reset()
        
        refreshUI()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func registerButton(_ sender: Any)
    {
        registerButton.isEnabled = false;
        registerButton.setTitle("In progress...", for: UIControlState.normal)
        
        let apiKey = ApiKey.register(emailAddress: "john-\(arc4random_uniform(10000))@doe.net", onRegistered: {
            self.registerButton.setTitle("Registered!", for: UIControlState.normal)
            self.refreshUI()
        }, onError: {
            self.registerButton.isEnabled = true;
            self.registerButton.setTitle("Register", for: UIControlState.normal)
        })
    }
    
    @IBAction func toggleWebsitePreview(_ sender: UISwitch)
    {
        print("toggleWebsitePreview \(sender.isOn)")
        
        ApiKey.get()?.updateSetting(setting: "preview", value: sender.isOn)
    }
    
    @IBAction func toggleShouldQueue(_ sender: UISwitch)
    {
        print("toggleShouldQueue \(sender.isOn)")
        
        ApiKey.get()?.updateSetting(setting: "queued", value: sender.isOn)
    }
    
    func refreshUI()
    {
        let apiKey = ApiKey.get()
        
        let elementsToHide = [
            previewLabel, previewSwitch, queuedLabel, queuedSwitch
        ] as [UIView]
        
        for element in elementsToHide {
            element.isHidden = apiKey == nil
        }
        
        if let shouldPreview = apiKey?.preview {
            previewSwitch.setOn(shouldPreview, animated: true)
        }
        
        if let shouldQueue = apiKey?.queued {
            queuedSwitch.setOn(shouldQueue, animated: true)
        }
    }
    
}

