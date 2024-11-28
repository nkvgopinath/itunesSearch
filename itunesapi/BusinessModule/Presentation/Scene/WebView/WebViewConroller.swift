//
//  WebViewConroller.swift
//  itunesapi
//
//  Created by Gopinath Vaiyapuri on 21/11/24.
//

import UIKit
import WebKit

class WebViewConroller: UIViewController {

    @IBOutlet weak var navigationView: NavigationBarView!
    
    @IBOutlet weak var webView: WKWebView!
    
    var weburl:String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = ColorUtils.blackColor
        self.webView.backgroundColor = ColorUtils.blackColor

        if let urlString = weburl {
            if let url = URL(string: urlString) {
                let request = URLRequest(url: url)
                webView.load(request)
            }
        }

        navigationView.titleLabel.text = "Preview Page"
        navigationView.backHandler = {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

extension WebViewConroller: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Started loading")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Finished loading")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("Failed to load: \(error.localizedDescription)")
    }
}
