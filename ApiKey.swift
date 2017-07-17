//
//  ApiKey.swift
//  fwrdto.me-ios
//
//  Created by Valentin on 12/07/2017.
//  Copyright © 2017 Valentin Polo. All rights reserved.
//

import Foundation
import Alamofire

class ApiKey: NSObject, NSCoding
{
    var uuid: String?
    var email: String
    var preview: Bool?
    var queued: Bool?
    
    override var description: String {
        return "ApiKey:\nUUID: \(String(describing: uuid))\nEmail: \(email)\nPreview: \(String(describing: preview))\nQueued: \(String(describing: queued))"
    }
    
    init(uuid: String?, email: String)
    {
        self.uuid = uuid
        self.email = email
        self.preview = nil
        self.queued = nil
    }
    
    init(uuid: String?, email: String, preview: Bool?, queued: Bool?)
    {
        self.uuid = uuid
        self.email = email
        self.preview = preview
        self.queued = queued
    }
    
    required convenience init(coder aDecoder: NSCoder)
    {
        let uuid = aDecoder.decodeObject(forKey: "uuid") as! String?
        let email = aDecoder.decodeObject(forKey: "email") as! String
        let preview = aDecoder.decodeObject(forKey: "preview") as! Bool?
        let queued = aDecoder.decodeObject(forKey: "queued") as! Bool?
        
        self.init(uuid: uuid, email: email, preview: preview, queued: queued)
    }
    
    func encode(with aCoder: NSCoder)
    {
        aCoder.encode(self.uuid, forKey: "uuid")
        aCoder.encode(self.email, forKey: "email")
        aCoder.encode(self.preview, forKey: "preview")
        aCoder.encode(self.queued, forKey: "queued")
    }
    
    func save()
    {
        let archivedApiKey = NSKeyedArchiver.archivedData(withRootObject: self)
        
        let defaults = UserDefaults(suiteName: Constants.APP.USER_DEFAULTS_SUIT_NAME);
        defaults?.set(archivedApiKey, forKey: Constants.APP.USER_DEFAULTS_KEYS_API_KEY)
        defaults?.synchronize();
    }
    
    func updateEmailAddress(newEmailAddress: String?, onUpdated: @escaping () -> Void, onError: @escaping () -> Void)
    {
        if (newEmailAddress == nil || !Utils.isValidEmail(testStr: newEmailAddress!)) {
            onError()
            return
        }
        
        let parameters = [
            "api-key": self.uuid,
            "email": newEmailAddress
        ]
        
        Alamofire
            .request("\(Constants.URLS.API_ENDPOINT)/update", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON { response in                
                if let rawResult = response.result.value {
                    print("/api/update: \(rawResult)")
                
                    onUpdated()
                } else {
                    onError()
                }
        }
    }
    
    func updateSetting(setting: String, value: Any)
    {
        if (setting == "preview") {
            self.preview = (value as! Bool)
        } else if (setting == "queued") {
            self.queued = (value as! Bool)
        }
        
        print(self)
        
        save()
    }
    
    class func register(emailAddress: String, onRegistered: @escaping () -> Void, onError: @escaping () -> Void) -> ApiKey?
    {
        let parameters = [
            "email": emailAddress,
            "source": "ios"
        ]
        
        print("Contacting \(Constants.URLS.API_ENDPOINT)/register")
        
        Alamofire
            .request("\(Constants.URLS.API_ENDPOINT)/register", method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .responseJSON {
                response in
                    if let rawResult = response.result.value {
                        let jsonApiKey = rawResult as! NSDictionary
                        
                        if (jsonApiKey.value(forKey: "uuid") == nil || jsonApiKey.value(forKey: "email") == nil) {
                            onError()
                            return;
                        }
                        
                        ApiKey(
                            uuid: (jsonApiKey.value(forKey: "uuid")! as! String),
                            email: jsonApiKey.value(forKey: "email")! as! String,
                            preview: true,
                            queued: false
                        ).save()
                        
                        onRegistered()
                    } else {
                        onError()
                }
            }
        
        return nil;
    }
    
    class func get() -> ApiKey?
    {
        let defaults = UserDefaults(suiteName: Constants.APP.USER_DEFAULTS_SUIT_NAME);
        defaults?.synchronize();
        
        if let archivedApiKey = defaults?.value(forKey: Constants.APP.USER_DEFAULTS_KEYS_API_KEY) {
            return NSKeyedUnarchiver.unarchiveObject(with: archivedApiKey as! Data) as? ApiKey
        }
        
        return nil;
    }
    
    class func reset()
    {
        let defaults = UserDefaults(suiteName: Constants.APP.USER_DEFAULTS_SUIT_NAME);
        defaults?.synchronize();
        defaults?.removeObject(forKey: Constants.APP.USER_DEFAULTS_KEYS_API_KEY)
        defaults?.synchronize();
    }
}
