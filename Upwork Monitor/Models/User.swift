//
//  User.swift
//  Upwork Monitor
//
//  Created by Sergei Zorko on 10/09/2019.
//  Copyright © 2019 Banarum. All rights reserved.
//

import Foundation

struct User: Codable {
    let status: String
    let portrait_100_img: String
    let email: String
    let profile_key: String
    let id: String
    let first_name: String
    let last_name: String
    let reference: String
}
