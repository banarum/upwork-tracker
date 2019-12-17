//
//  Auth.swift
//  Upwork Monitor
//
//  Created by Sergei Zorko on 10/09/2019.
//  Copyright © 2019 Banarum. All rights reserved.
//

import Foundation

struct Auth: Codable {
    var oauth_access_token: String
    var oauth_access_token_secret: String
}
