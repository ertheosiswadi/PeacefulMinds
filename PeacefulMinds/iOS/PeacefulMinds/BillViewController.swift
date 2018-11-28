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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        
        guard let path = Bundle.main.path(forResource: "sample_bill", ofType: "pdf") else { return }
        let url = URL(fileURLWithPath: path)
        let request = URLRequest(url: url)
        
        webView.load(request)
        
        
//        if let document = PDFDocument(url: url) {
//            pdfView.document = document
//            pdfView.autoScales = true
//            pdfView.displayMode = .singlePageContinuous
//            pdfView.displayDirection = .vertical
//        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
