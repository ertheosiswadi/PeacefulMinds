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

class BillViewController: UIViewController, UIDocumentInteractionControllerDelegate {
    
    var myWebView : UIWebView?
    var dlButton : UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        let width = view.frame.width - 16
        myWebView = UIWebView(frame: CGRect(x: 0, y: view.safeAreaInsets.top, width: width, height: CGFloat(Double(width)/8 * 11)))
        myWebView?.center.x = view.center.x
        view.addSubview(myWebView!)
        
        guard let path = Bundle.main.path(forResource: "sample_bill", ofType: "pdf") else { return }
        let url = URL(fileURLWithPath: path)
        let request = URLRequest(url: url)
        myWebView?.loadRequest(request)
        
        //download button
        dlButton = UIButton(frame: CGRect(x: 0, y: 0, width: 130, height: 40))
        dlButton?.setTitle("Download", for: .normal)
        dlButton?.backgroundColor = UIColor.white
        dlButton?.setTitleColor(primaryColor, for: .normal)
        dlButton?.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        view.addSubview(self.dlButton!)
        
    }
    @objc func buttonAction(sender: UIButton!) {
        guard let url = Bundle.main.url(forResource: "sample_bill", withExtension: "pdf") else { return }
        let controller = UIDocumentInteractionController(url: url)
        controller.delegate = self
        controller.presentPreview(animated: true)
    }
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    override func viewDidLayoutSubviews() {
        print("insetssafearea",view.frame.maxY)
        myWebView?.frame.origin.y = view.safeAreaInsets.top + CGFloat(8)
        dlButton?.frame.origin.y = view.frame.maxY-view.safeAreaInsets.bottom - (dlButton?.frame.height)! * 2
        dlButton?.frame.origin.x = view.frame.maxX - (dlButton?.frame.height)! - (dlButton?.frame.width)!
    }
}
