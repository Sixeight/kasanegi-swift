//
//  ViewController.swift
//  kasanegi-swift
//
//  Created by Tomohiro Nishimura on 2015/02/23.
//  Copyright (c) 2015年 Tomohiro Nishimura. All rights reserved.
//

import UIKit
import Social

class ViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet weak var webView: UIWebView!
    
    let URL = NSURL(string: "http://higashi-dance-network.appspot.com/kasanegi/")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.delegate = self;
        openHome()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tapHome(sender: AnyObject) {
        openHome()
    }
    
    @IBAction func tapTweet(sender: AnyObject) {
        let href = self.webView.stringByEvaluatingJavaScriptFromString("document.querySelector('#share-tweet-container > a').href")
        let tweetURL = NSURL(string: href!)
        tweet(tweetURL!)
    }
    
    func openHome() {
        let request = NSURLRequest(URL: URL)
        self.webView.loadRequest(request)
    }
    
    func tweet(tweetURL: NSURL) {
        var params: [String:String] = [:]
        var pairs = tweetURL.query?.componentsSeparatedByString("&")
        if pairs == nil {
            return
        }
        for pair in pairs! {
            let keyValue = pair.componentsSeparatedByString("=")
            params[keyValue[0]] = keyValue[1]
        }
        
        if let text = params["text"] {
            let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            vc.setInitialText(text.stringByRemovingPercentEncoding)
            vc.addURL(URL)
            presentViewController(vc, animated: true, completion: nil)
        }
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if request.URL.host == "twitter.com" && request.URL.query?.rangeOfString("text=") != nil {
            return false
        }
        
        return true
    }
}

