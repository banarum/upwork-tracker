//
//  DBHelper.swift
//  Upwork Monitor
//
//  Created by Sergei Zorko on 17/12/2019.
//  Copyright © 2019 Banarum. All rights reserved.
//

import Foundation

// Database wrapper. This project doesn't require any database at this point
class DBHelper {
    
    static let UPWORK_ACCESS_TOKEN = "oauth_access_token"
    static let UPWORK_ACCESS_SECRET = "oauth_access_token_secret"
    
    static var shared: DBHelper = {
        let instance = DBHelper()
        
        return instance
    }()
    
    private let defaults: UserDefaults
    
    private init() {
        defaults = UserDefaults()
    }
    
    public func saveString(_ value: String, forKey key: String) {
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    public func getString(forKey key: String) -> String? {
        return defaults.string(forKey: key)
    }
    
    public func deleteString(forKey key: String) {
        defaults.removeObject(forKey: key)
    }
}

extension DBHelper: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
