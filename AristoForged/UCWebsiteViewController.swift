//
//  UCWebsiteViewController.swift
//  UrbanCam
//
//  Created by Anjaneyulu Battula on 7/6/16.
//  Copyright © 2016 Impure Inc. All rights reserved.
//

import UIKit

class UCWebsiteViewController: UIViewController, UIWebViewDelegate {
    
    var websiteURLString =  String()
    var navTitle: String!
    @IBOutlet weak var webView: UIWebView!
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
          self.navigationController?.navigationBar.titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue: UIColor.white])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = navTitle
        webView.delegate = self
        let strWebsite : String
        
        if websiteURLString.lowercased().hasPrefix("http") || websiteURLString.lowercased().hasPrefix("https")
        {
            strWebsite = websiteURLString
        }
        else
        {
            strWebsite = "http://\(websiteURLString)"
        }
        
        print(strWebsite)
        
        webView.loadRequest(NSURLRequest(url: NSURL(string: strWebsite)! as URL) as URLRequest)

    }
    
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get {
            return [.landscapeRight, .landscapeLeft]
        }
    }
    
    open override var shouldAutorotate: Bool {
        get {
            return true
        }
    }

    //MARK:Button Actions
    @IBAction func navBarBackButtonTapped(_ sender: AnyObject)
    {
        self.dismiss(animated: true, completion: nil)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
