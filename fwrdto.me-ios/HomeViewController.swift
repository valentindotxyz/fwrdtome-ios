//
//  ViewController.swift
//  fwrdto.me-ios
//
//  Created by Valentin on 11/07/2017.
//  Copyright © 2017 Valentin Polo. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var previewLabel: UILabel!
    @IBOutlet weak var previewSwitch: UISwitch!
    @IBOutlet weak var queuedLabel: UILabel!
    @IBOutlet weak var queuedSwitch: UISwitch!
    @IBOutlet weak var optionsLabel: UILabel!
    @IBOutlet weak var chooseHourButton: UIButton!
    @IBOutlet weak var emailInput: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
                
        emailInput.delegate = self
        
        ApiKey.reset()
        
        refreshUI()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }


    @IBAction func registerButton(_ sender: Any)
    {
        register()
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        register()
        
        return true
    }
    
    func displayAlert(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func register()
    {
        emailInput.resignFirstResponder()
        
        if (!emailInput.hasText || !Utils.isValidEmail(testStr: emailInput.text!)) {
            displayAlert(title: "Invalid email address", message: "Please provide a valid email address so we can send you your links!")
            return;
        }
        
        // If an API key is available, update the email address (no register)...
        if let existingApiKey = ApiKey.get() {
            existingApiKey.updateEmailAddress(newEmailAddress: emailInput.text, onUpdated: {
                self.displayAlert(title: "Email address updated!", message: "You should start receiving your links to the new email address provided.")
            }, onError: {
                self.displayAlert(title: "Error", message: "We could not update your email address, please try again.")
            })
            
            return
        }
        
        
        registerButton.isEnabled = false;
        registerButton.setTitle("Register in progress...", for: UIControlState.normal)
        
        ApiKey.register(emailAddress: emailInput.text!, onRegistered: {
            self.displayAlert(title: "Registered successfully!", message: "You can now close the app and start using use the fwrdto.me extension.")
            self.refreshUI()
        }, onError: {
            self.registerButton.isEnabled = true;
            self.registerButton.setTitle("Register", for: UIControlState.normal)
        })
    }
    
    func refreshUI()
    {
        let apiKey = ApiKey.get()
        
        let elementsToHide = [
            optionsLabel, previewLabel, previewSwitch, queuedLabel, queuedSwitch, chooseHourButton
        ] as [UIView]
        
        for element in elementsToHide {
            element.isHidden = apiKey == nil
        }
        
        if let emailAddress = apiKey?.email {
            emailInput.text = emailAddress
            registerButton.setTitle("Update email address", for: .normal)
            registerButton.isEnabled = true;
        }
        
        if let shouldPreview = apiKey?.preview {
            previewSwitch.setOn(shouldPreview, animated: true)
        }
        
        if let shouldQueue = apiKey?.queued {
            queuedSwitch.setOn(shouldQueue, animated: true)
        }
    }
    
}

