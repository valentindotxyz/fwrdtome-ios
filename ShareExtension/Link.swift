//
//  Link.swift
//  fwrdto.me-ios
//
//  Created by Valentin on 11/07/2017.
//  Copyright © 2017 Valentin Polo. All rights reserved.
//

import Foundation
import Alamofire

class Link {
    var title: String
    var link: String
    
    init(title: String, link: String)
    {
        self.title = title
        self.link = link
    }
    
    func send(withApiKey: ApiKey, onSentToApi: () -> Void)
    {
        let parameters = [
            "link": link,
            "title": title,
            "api-key": withApiKey.uuid!,
            "preview": withApiKey.preview! ? "yes" : "no",
            "queued": withApiKey.queued! ? "yes" : "no"
        ]
                
        Alamofire.request("\(Constants.URLS.API_ENDPOINT)/send", method: .get, parameters: parameters).responseJSON { response in
            print(response)
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                print("JSON: \(json)") // serialized json response
            }
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                print("Data: \(utf8Text)") // original server data as UTF8 string
            }
        }
        
        onSentToApi()
    }
}
