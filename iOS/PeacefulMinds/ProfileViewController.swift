//
//  ProfileViewController.swift
//  PeacefulMinds
//
//  Created by Ertheo Siswadi on 11/28/18.
//  Copyright © 2018 Peaceful Minds. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    var insurance_names : [String:String]?
    var activityView:UIActivityIndicatorView!
    let apihelper = APIHelper.init()
    var username : String?
    var user : [String:Any]?
    @IBOutlet weak var deductibleLabel: UILabel!
    @IBOutlet weak var iidLabel: UILabel!
    @IBOutlet weak var zipLabel: UILabel!
    @IBOutlet weak var ipLabel: UILabel!
    @IBOutlet weak var hiLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pieChart: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        
        //insurance names - this needs some work... not synced with database
        self.insurance_names = ["ip_1": "Cigna","ip_2": "Aetna","ip_3": "Blueshield"]
        
        hiLabel.textColor = UIColor.white
        nameLabel.textColor = UIColor.white
        ipLabel.textColor = UIColor.white
        iidLabel.textColor = UIColor.white
        zipLabel.textColor = UIColor.white
        
        nameLabel.text = String((self.username?.prefix(1).uppercased())!) + String((self.username?.lowercased().dropFirst())!)
        
        //hide while loading for userinfo
        deductibleLabel.isHidden = true
        ipLabel.isHidden = true
        iidLabel.isHidden = true
        zipLabel.isHidden = true
        pieChart.isHidden = true
        
        //create the activity view
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityView.color = secondaryColor
        activityView.frame = CGRect(x: 0, y: 0, width: 500.0, height: 500.0)
        activityView.center = view.center
        
        view.addSubview(activityView)
        activityView.startAnimating()
        DispatchQueue.global(qos: .background).async{
            self.apihelper.getUser(username: self.username!) { (data) in
                self.user = data;
                DispatchQueue.main.async {
                    self.activityView.stopAnimating()
                    let ip_name = self.insurance_names![self.user?["insurance_provider"] as! String]
                    self.ipLabel.text = ip_name
                    
                    self.iidLabel.text = self.user?["insurance_id"] as! String
                    self.zipLabel.text = String(self.user?["zipcode"] as! Int)
                    self.deductibleLabel.text = "$\(String(self.user?["deductible"] as! Int))"
                    
                    //show it back again
                    self.deductibleLabel.isHidden = false
                    self.ipLabel.isHidden = false
                    self.iidLabel.isHidden = false
                    self.zipLabel.isHidden = false
                    self.pieChart.isHidden = false
                }
            }
        }
        
        
    }
}
