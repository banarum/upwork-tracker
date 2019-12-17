//
//  APIService.swift
//  Upwork Monitor
//
//  Created by Sergei Zorko on 10/09/2019.
//  Copyright © 2019 Banarum. All rights reserved.
//

import Foundation

class APIService {
    
    static func getIncome(access_token:String, access_token_secret:String, from start_date:String, till end_date:String, provider_id:String, callback: @escaping (Response<Income>) -> Void){
        let postData = getPostData(args: [
            "oauth_access_token":access_token,
            "oauth_access_token_secret":access_token_secret,
            "provider_id":provider_id,
            "start_date":start_date,
            "end_date":end_date
        ])
        
        makeRequest(postData: postData, url: "https://upworkapp.zorko.dev/income", callback: callback)
    }
    
    static func getTokens(id:String, verifier:String, callback: @escaping (Response<Auth>) -> Void){
        let postData = getPostData(args: [
            "id":id,
            "verifier":verifier
        ])
        
        makeRequest(postData: postData, url: "https://upworkapp.zorko.dev/oauth", callback: callback)
    }
    
    static func getUser(access_token:String, access_token_secret:String, callback: @escaping (Response<User>) -> Void){
        let postData = getPostData(args: [
            "oauth_access_token":access_token,
            "oauth_access_token_secret":access_token_secret
        ])
        
        makeRequest(postData: postData, url: "https://upworkapp.zorko.dev/me", callback: callback)
    }
    
    static func getPostData(args:[String:String]) -> NSMutableData{
        var result = ""
        for key in args.keys {
            let value = args[key]!
            if result != ""{
                result = "\(result)&\(key)=\(value)"
            }else{
                result = "\(key)=\(value)"
            }
        }
        return NSMutableData(data: result.data(using: String.Encoding.utf8)!)
    }
    
    static func makeRequest<T>(postData:NSMutableData, url:String, callback: @escaping (Response<T>) -> Void){
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
                        let userResponse:Response<T> = try decoder.decode(Response<T>.self, from: data!)
                        DispatchQueue.main.async {
                            callback(userResponse)
                        }
                    } catch {
                        DispatchQueue.main.async {
                            callback(Response<T>(result: nil, status: "error", message: error.localizedDescription))
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        callback(Response<T>(result: nil, status: "error", message: "Server sent \(httpResponse.statusCode) code"))
                    }
                }
            }else{
                DispatchQueue.main.async {
                    callback(Response<T>(result: nil, status: "error", message: "Network error"))
                }
            }
        })
        
        task.resume()
    }
}
