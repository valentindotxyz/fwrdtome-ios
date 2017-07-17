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
    var link: String
    var title: String?
    
    init(link: String, title: String?)
    {
        self.link = link
        self.title = title;
    }
    
    func send(withApiKey: ApiKey, onSentToApi: () -> Void)
    {
        let parameters = [
            "link": link,
            "title": title ?? "NONE",
            "api-key": withApiKey.uuid!,
            "preview": withApiKey.preview! ? "yes" : "no",
            "queued": withApiKey.queued! ? "yes" : "no"
        ]
                
        Alamofire.request("\(Constants.URLS.API_ENDPOINT)/send", method: .get, parameters: parameters).responseJSON { response in
            if let json = response.result.value {
                print("/api/send: \(json)")
            }
        }
        
        onSentToApi()
    }
}
