//
//  BillViewController.swift
//  PeacefulMinds
//
//  Created by Ertheo Siswadi on 11/27/18.
//  Copyright © 2018 Peaceful Minds. All rights reserved.
//

import Foundation
import UIKit
import PDFKit
import WebKit

class BillViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    var myWebView : UIWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        let width = view.frame.width - 16
        myWebView = UIWebView(frame: CGRect(x: 0, y: view.safeAreaInsets.top, width: width, height: CGFloat(Double(width)/8 * 11)))
        myWebView?.center.x = view.center.x
        view.addSubview(myWebView!)
//        let constraint = myWebView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
//        NSLayoutConstraint.activate([constraint])
        
//    NSLayoutConstraint.activate([myWebView.topAnchor.constraintEqualToSystemSpacingBelow(view.safeAreaLayoutGuide.topAnchor, multiplier: 1.0)])
//        print("safearea", view.safeAreaInsets.top)
        
//        webView.frame.size.height = CGFloat((Double(webView.frame.size.width)/8)*11)
//        print("height",webView.frame.size.height,"width", webView.frame.size.width)
//        webView.center = view.center
        
        guard let path = Bundle.main.path(forResource: "sample_bill", ofType: "pdf") else { return }
        let url = URL(fileURLWithPath: path)
        let request = URLRequest(url: url)
        myWebView?.loadRequest(request)
        
        
//        webView.load(request)
        
        
//        if let document = PDFDocument(url: url) {
//            pdfView.document = document
//            pdfView.autoScales = true
//            pdfView.displayMode = .singlePageContinuous
//            pdfView.displayDirection = .vertical
//        }
        
    }
    override func viewDidLayoutSubviews() {
        print("insetssafearea",view.safeAreaInsets.top)
        myWebView?.frame.origin.y = view.safeAreaInsets.top + CGFloat(8)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
