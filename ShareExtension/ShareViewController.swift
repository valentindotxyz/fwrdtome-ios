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

//    override func isContentValid() -> Bool {
//        // Do validation of contentText and/or NSExtensionContext attachments here
//        return true
//    }
//    
//    override func loadPreviewView() -> UIView! {
//        return nil
//    }
//
//    override func didSelectPost() {
//        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
//    
//        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
//        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
//    }
//
//    override func configurationItems() -> [Any]! {
//        return []
//        
//        if let settings = SLComposeSheetConfigurationItem() {
//            settings.title = "Settings"
//            settings.value = "with preview, to queue"
//            settings.tapHandler = {
//                // on tap
//            }
//            return [settings]
//        }
//    
//        
//        return []
//    }
    
    override func viewDidLoad() {
        let extensionItem = extensionContext?.inputItems.first as! NSExtensionItem
        let itemProvider = extensionItem.attachments?.first as! NSItemProvider
        let propertyList = String(kUTTypePropertyList)
        
//        // Set the Share's title to "Send"
//        self.navigationController?.navigationBar.topItem?.rightBarButtonItem?.title = "Send"
//        
//        // Set the Share's color to fwrdto.me
//        navigationController?.navigationBar.tintColor = .white
//        navigationController?.navigationBar.backgroundColor = UIColor(red:0.39, green:0.46, blue:0.86, alpha:1.00)
//        
        let defaults = UserDefaults.init(suiteName: "group.xyz.valentin.fwrdto-me")
        defaults?.synchronize()
        let apiKey = defaults?.value(forKey: "API_KEY")
        
        print("API Key: \(apiKey)")
        
        if itemProvider.hasItemConformingToTypeIdentifier(propertyList) {
            itemProvider.loadItem(forTypeIdentifier: propertyList, options: nil, completionHandler: { (item, error) -> Void in
                guard let dictionary = item as? NSDictionary else { return }
                OperationQueue.main.addOperation {
                    if let results = dictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary,
                        let urlString = results["URL"] as? String,
                        let titleString = results["title"] as? String
                    {
                        print("URL retrieved: \(urlString)")
                        print("Title retrieved: \(titleString)")
                        
                        print(Constants.API_ENDPOINT)
                        
                        Alamofire.request("https://httpbin.org/get").responseJSON { response in
                            print("Request: \(String(describing: response.request))")   // original url request
                            print("Response: \(String(describing: response.response))") // http url response
                            print("Result: \(response.result)")                         // response serialization result
                            
                            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
                            
                            if let json = response.result.value {
                                print("JSON: \(json)") // serialized json response
                            }
                            
                            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                                print("Data: \(utf8Text)") // original server data as UTF8 string
                            }
                        }
                    }
                }
            })
        } else {
            print("error")
        }
        
        // self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
}
