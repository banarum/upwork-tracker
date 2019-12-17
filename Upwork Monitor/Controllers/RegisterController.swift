//
//  RegisterWebViewController.swift
//  Upwork Monitor
//
//  Created by Sergei Zorko on 03/09/2019.
//  Copyright © 2019 Banarum. All rights reserved.
//

import UIKit
import WebKit

class RegisterController: UIViewController, WKUIDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    
    var requestId = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestId = self.generateRequestId()
        
        let regURL = URL(string:"https://upworkapp.zorko.dev/reg?id=\(requestId)")
        let request = URLRequest(url: regURL!)
        
        // Remove all cache
        URLCache.shared.removeAllCachedResponses()

        // Delete any associated cookies
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
        
        webView.load(request)
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    func generateRequestId() -> String {
        return "\(Int(Date().timeIntervalSince1970))\(Int.random(in: 100..<999))"
    }
    
    func onOauthReceived(verifier:String) {
        APIService.getTokens(id: requestId, verifier: verifier, callback: { (response:Response<Auth>) in
            if response.status == "ok" {
                let defaults = UserDefaults.standard
                defaults.set(response.result!.oauth_access_token, forKey: "oauth_access_token")
                defaults.set(response.result!.oauth_access_token_secret, forKey: "oauth_access_token_secret")
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let dashboardController = storyBoard.instantiateViewController(withIdentifier: "dashboard") as! DashboardController
                self.navigationController?.setViewControllers([dashboardController], animated: false)
            }else{
                print(response.message!)
            }
        })
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            if (Float(webView.estimatedProgress) == 1) {
                self.getWebViewContent(of: webView, to: {content in
                    if let range = content.range(of: "oauth_verifier=") {
                        let substring = content[range.upperBound..<content.endIndex]
                        if let space_index = substring.firstIndex(of: " ") {
                            let oauth_verifier = String(substring[..<space_index])
                            self.onOauthReceived(verifier: oauth_verifier)
                        }else{
                            print("String not present")
                        }
                    }
                    else {
                        print("String not present")
                    }
                })
            }
        }
    }
    
    func getWebViewContent(of webView:WKWebView, to receiver: @escaping (String)->Void) {
        webView.evaluateJavaScript("document.documentElement.outerHTML.toString()",
           completionHandler: { (html: Any?, error: Error?) in
                if (html != nil){
                    receiver(String(describing: html))
                }else{
                    receiver("")
                }
            }
        )
    }
    
}
