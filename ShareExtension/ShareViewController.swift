//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by Valentin on 11/07/2017.
//  Copyright © 2017 Valentin Polo. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices
import Alamofire

class ShareViewController: UIViewController {
    
    override func viewDidLoad() {
        NSKeyedArchiver.setClassName("ApiKey", for: ApiKey.self)
        NSKeyedUnarchiver.setClass(ApiKey.self, forClassName: "ApiKey")
        
        let extensionItem = extensionContext?.inputItems.first as! NSExtensionItem
        let itemProvider = extensionItem.attachments?.first as! NSItemProvider
        let propertyList = String(kUTTypePropertyList)
        
        let apiKey = ApiKey.get()
        
        if (apiKey == nil || !itemProvider.hasItemConformingToTypeIdentifier(propertyList)) {
            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        }
        
        print("SHOULD BE GOOD TO GO NOW!")
        
        itemProvider.loadItem(forTypeIdentifier: propertyList, options: nil, completionHandler: { (item, error) -> Void in
            guard let dictionary = item as? NSDictionary else { return }
            
            OperationQueue.main.addOperation {
                if let results = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary,
                    let urlString = results["URL"] as? String,
                    let titleString = results["title"] as? String
                {
                    Link
                        .init(title: titleString, link: urlString)
                        .send(withApiKey: apiKey!, onSentToApi: {
                            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
                        })
                }
            }
        })
    }
}
