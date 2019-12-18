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
    
    var observation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // generate unique request id
        requestId = self.generateRequestId()
        
        let regURL = URL(string: "\(APIService.DOMAIN_URL + APIService.REG_ENDPOINT)?id=\(requestId)")
        let request = URLRequest(url: regURL!)
        
        // Remove all cache
        URLCache.shared.removeAllCachedResponses()

        // Delete any associated cookies
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
        
        // Load webview with observer attached
        webView.load(request)
        
        // When loading completed, check if 'verifier' String present. If so, proceed to getting client oauth tokens
        observation = webView.observe(\WKWebView.estimatedProgress, options: [.new]) { (webView, _) in
            if Float(webView.estimatedProgress) == 1 {
                self.getWebViewContent(of: webView, to: {content in
                    
                    // Get String after 'oauth_verifier='
                    if let range = content.range(of: "oauth_verifier=") {
                        let substring = content[range.upperBound..<content.endIndex]
                        
                        // Get String before ' '
                        if let space_index = substring.firstIndex(of: " ") {
                            
                            // '...oauth_verifier=<target> '
                            
                            let oauth_verifier = String(substring[..<space_index])
                            
                            // Proceed with getting client oauth tokens
                            self.onOauthReceived(verifier: oauth_verifier)
                        } else {
                            print("String not present")
                        }
                    } else {
                        print("String not present")
                    }
                })
            }
        }
        
        checkAssertions()
    }
    
    func generateRequestId() -> String {
        return "\(Int(Date().timeIntervalSince1970))\(Int.random(in: 100..<999))"
    }
    
    func onOauthReceived(verifier: String) {
        APIService.shared.getTokens(id: requestId, verifier: verifier, callback: { (response: Response<Auth>) in
            if response.status == APIService.API_OK {
                
                let accessToken = response.result!.oauth_access_token
                let accessTokenSecret = response.result!.oauth_access_token_secret
                
                // Save tokens to local storage for farther use
                DBHelper.shared.saveString(accessToken, forKey: DBHelper.UPWORK_ACCESS_TOKEN)
                DBHelper.shared.saveString(accessTokenSecret, forKey: DBHelper.UPWORK_ACCESS_SECRET)
                
                // Setup network Service
                APIService.shared.setTokens(accessToken: accessToken, accessTokenSecret: accessTokenSecret)
                
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let dashboardController = storyBoard.instantiateViewController(withIdentifier: "dashboard") as! DashboardController
                self.navigationController?.setViewControllers([dashboardController], animated: false)
                
            } else {
                print(response.message!)
            }
        })
    }
    
    // Perform JS query to receive WebView content
    func getWebViewContent(of webView: WKWebView, to receiver: @escaping (String) -> Void) {
        webView.evaluateJavaScript("document.documentElement.outerHTML.toString()",
           completionHandler: { (html: Any?, _: Error?) in
                if html != nil {
                    receiver(String(describing: html))
                } else {
                    receiver("")
                }
            }
        )
    }
    
    func checkAssertions() {
        assert(webView != nil)
    }
    
    deinit {
        self.observation = nil
    }
    
}
