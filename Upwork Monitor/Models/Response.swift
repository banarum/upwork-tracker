//
//  Response.swift
//  Upwork Monitor
//
//  Created by Sergei Zorko on 10/09/2019.
//  Copyright © 2019 Banarum. All rights reserved.
//

import Foundation

struct Response<T : Codable> : Codable {
    let result: T?
    let status: String
    let message: String?
}
