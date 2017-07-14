//
//  AboutAppViewController.swift
//  fwrdto.me-ios
//
//  Created by Valentin on 14/07/2017.
//  Copyright © 2017 Valentin Polo. All rights reserved.
//

import Foundation
import UIKit

class AboutAppViewController: UIViewController
{
    @IBAction func goToFwrdtomesWebsite(_ sender: UIButton)
    {
        UIApplication.shared.open(URL(string: Constants.URLS.FWRDTO_ME_WEBSITE)!, options: [:], completionHandler: nil)
    }
    
    @IBAction func goToValentinPolosWebsite(_ sender: UIButton)
    {
        UIApplication.shared.open(URL(string: Constants.URLS.MAKER_WEBSITE)!, options: [:], completionHandler: nil)
    }
    
    @IBAction func goToSupport(_ sender: UIButton)
    {
        UIApplication.shared.open(URL(string: Constants.URLS.CONTACT_FORM)!, options: [:], completionHandler: nil)
    }
    
    @IBAction func onCloseButtonClicked(_ sender: UIButton)
    {
        dismiss(animated: true, completion: nil)
    }
    
}
