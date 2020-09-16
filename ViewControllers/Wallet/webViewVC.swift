//
//  webViewVC.swift
//  TiCKTOC-Driver
//
//  Created by Excelent iMac on 02/12/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import WebKit

class webViewVC: BaseViewController, WKNavigationDelegate {

    var strURL = String()
    
    var headerName = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UtilityClass.showACProgressHUD()
//        setNavBarWithBack(Title: headerName, IsNeedRightButton: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        if headerName != "" {
//            headerView?.lblTitle.text = headerName
//        }
        
        let url = strURL
        
        let requestURL = URL(string: url)
        let request = URLRequest(url: requestURL! as URL)
        webView.load(request)
        
    }
    

    
    // MARK: - Outlet
    
    @IBOutlet weak var webView: WKWebView!
    
    
    // WKview Delegates
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UtilityClass.hideACProgressHUD()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        UtilityClass.hideACProgressHUD()
        //Show alert
    }
    

}
