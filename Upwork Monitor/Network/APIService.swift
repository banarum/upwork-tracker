//
//  APIService.swift
//  Upwork Monitor
//
//  Created by Sergei Zorko on 10/09/2019.
//  Copyright © 2019 Banarum. All rights reserved.
//

import Foundation

// Basic Network Service

class APIService {
    
    static var shared: APIService = {
        let instance = APIService()
        return instance
    }()
    
    public static let API_OK                = "ok"
    public static let API_ERROR             = "error"
    
    public static let DOMAIN_URL            = "https://upworkapp.zorko.dev"
    
    public static let INCOME_ENDPOINT       = "/income"
    public static let ME_ENDPOINT           = "/me"
    public static let OAUTH_ENDPOINT        = "/oauth"
    public static let REG_ENDPOINT          = "/reg"
    
    private let ACCESS_TOKEN_FIELD          = "oauth_access_token"
    private let ACCESS_TOKEN_SECRET_FIELD   = "oauth_access_token_secret"
    
    private var accessToken = ""
    private var accessTokenSecret = ""
    
    private init() {}
    
    // Post initialization //////////
    
    public func getIncome(from start_date: String, till end_date: String, provider_id: String, callback: @escaping (Response<Income>) -> Void) {
        let postData = getPostData(args: [
            ACCESS_TOKEN_FIELD: accessToken,
            ACCESS_TOKEN_SECRET_FIELD: accessTokenSecret,
            "provider_id": provider_id,
            "start_date": start_date,
            "end_date": end_date
        ])
        
        makeRequest(postData: postData, url: "\(APIService.DOMAIN_URL + APIService.INCOME_ENDPOINT)", callback: callback)
    }
    
    public func getUser(callback: @escaping (Response<User>) -> Void) {
        let postData = getPostData(args: [
            ACCESS_TOKEN_FIELD: self.accessToken,
            ACCESS_TOKEN_SECRET_FIELD: self.accessTokenSecret
        ])
        
        makeRequest(postData: postData, url: "\(APIService.DOMAIN_URL + APIService.ME_ENDPOINT)", callback: callback)
    }
    
    // Pre initialization //////////
    
    public func getTokens(id: String, verifier: String, callback: @escaping (Response<Auth>) -> Void) {
        let postData = getPostData(args: [
            "id": id,
            "verifier": verifier
        ])
        
        makeRequest(postData: postData, url: "\(APIService.DOMAIN_URL + APIService.OAUTH_ENDPOINT)", callback: callback)
    }
    
    // Core ///////
    
    // Set tokens before starting any oauth queries
    public func setTokens(accessToken: String, accessTokenSecret: String) {
        self.accessToken = accessToken
        self.accessTokenSecret = accessTokenSecret
    }
    
    private func getPostData(args: [String: String]) -> NSMutableData {
        var result = ""
        for key in args.keys {
            let value = args[key]!
            if result != ""{
                result = "\(result)&\(key)=\(value)"
            } else {
                result = "\(key)=\(value)"
            }
        }
        return NSMutableData(data: result.data(using: String.Encoding.utf8)!)
    }
    
    private func makeRequest<T>(postData: NSMutableData, url: String, callback: @escaping (Response<T>) -> Void) {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.httpBody = postData as Data
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            if let httpResponse = response as? HTTPURLResponse {
                if data != nil {
                    do {
                        let decoder = JSONDecoder()
                        //print(String(decoding: data!, as: UTF8.self))
                        let userResponse: Response<T> = try decoder.decode(Response<T>.self, from: data!)
                        DispatchQueue.main.async {
                            callback(userResponse)
                        }
                    } catch {
                        DispatchQueue.main.async {
                            callback(Response<T>(result: nil, status: "error", message: error.localizedDescription))
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        callback(Response<T>(result: nil, status: "error", message: "Server sent \(httpResponse.statusCode) code"))
                    }
                }
            } else {
                DispatchQueue.main.async {
                    callback(Response<T>(result: nil, status: "error", message: "Network error"))
                }
            }
        })
        
        task.resume()
    }
    
}

extension APIService: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
