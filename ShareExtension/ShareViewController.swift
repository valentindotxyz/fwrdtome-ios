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
        
        let apiKey = ApiKey.get()
        
        if (apiKey == nil) {
            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        }
        
        if let item = extensionContext?.inputItems.first as? NSExtensionItem {
            if let attachments = item.attachments as? [NSItemProvider] {
                for attachment: NSItemProvider in attachments {
                    if attachment.hasItemConformingToTypeIdentifier("public.url") {
                        attachment.loadItem(forTypeIdentifier: "public.url", options: nil, completionHandler: { (url, error) in
                            if let link = url as? NSURL {
                                Link(link: link.absoluteString!, title: nil).send(withApiKey: apiKey!, onSentToApi: {
                                    self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
                                })
                            }
                        })
                    } else if (attachment.hasItemConformingToTypeIdentifier(String(kUTTypePropertyList))) {
                        attachment.loadItem(forTypeIdentifier: String(kUTTypePropertyList), options: nil, completionHandler: { (item, error) -> Void in
                            guard let dictionary = item as? NSDictionary else { return }
                            
                            if let results = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary,
                                let link = results["URL"] as? String,
                                let title = results["title"] as? String
                            {
                                Link(link: link, title: title).send(withApiKey: apiKey!, onSentToApi: {
                                    self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
                                })
                            }
                        })
                    }
                }
            }
        }        
    }
}
