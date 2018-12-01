//
//  SearchViewController.swift
//  PeacefulMinds
//
//  Created by Ertheo Siswadi on 11/28/18.
//  Copyright © 2018 Peaceful Minds. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController: UIViewController {
    
    var username : String?
    var procedure : String?
    
    @IBOutlet weak var searchField: UITextField!{
        didSet {
            let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 20.0, height: 2.0))
            searchField.leftView = leftView
            searchField.leftViewMode = .always
            searchField.font = UIFont(name: "Montserrat-Regular", size: 20)
        }
    }
    @IBOutlet weak var searchButton: UIButton!
    @IBAction func searchAction(_ sender: Any) {
        self.procedure = searchField.text
        self.performSegue(withIdentifier: "toResults", sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("search username-> " , self.username!)
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        searchField.roundCorners_v3(cornerRadius: 15)
        searchButton.backgroundColor = UIColor.white
        
        searchButton.roundCorners_v4(cornerRadius: 15)
       
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ResultsViewController
        {
            let resViewController = segue.destination as! ResultsViewController
            
            resViewController.username = self.username!
            resViewController.procedure = self.procedure!
        }
    }
}
extension UIView {
    func roundCorners_v1(cornerRadius: Double) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    func roundCorners_v2(cornerRadius: Double) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    func roundCorners_v3(cornerRadius: Double) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
    }
    func roundCorners_v4(cornerRadius: Double) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
    }
}
