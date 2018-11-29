//
//  ResultsViewController.swift
//  APIC
//
//  Created by Anthony Lei on 11/27/18.
//  Copyright © 2018 APIC. All rights reserved.
//

import Foundation
import UIKit
import PDFKit

class ResultsViewController: UIViewController {
    
    var procedure : String?
    
    override func viewDidLoad() {
        let pdfView = PDFView()
        
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)
        
        pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        guard let path = Bundle.main.url(forResource: "example", withExtension: "pdf") else {return}
        
        if let document = PDFDocument(url: "Desktop/35LPresentation.pdf"){
        {
        
        pdfView.document = document
        }
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
}
