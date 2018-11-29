//
//  SignUpViewController.swift
//  PeacefulMinds
//
//  Created by Ertheo Siswadi on 11/19/18.
//  Copyright © 2018 Peaceful Minds. All rights reserved.
//


import Foundation
import UIKit
import Firebase

class SignUpViewController:UIViewController, UITextFieldDelegate {
    var insurance_names : [String:String]?
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var iidField: UITextField!
    @IBOutlet weak var ipField: UITextField!
    @IBOutlet weak var zipcodeField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var dismissButton: UIButton!
    
    let apihelper = APIHelper.init()
    var continueButton:RoundedWhiteButton!
    var activityView:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //insurance names - this needs some work... not synced with database
        self.insurance_names = ["Nationwide":"ip_1","State Farm":"ip_2","Allstate":"ip_3"]
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        
        continueButton = RoundedWhiteButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        continueButton.setTitleColor(secondaryColor, for: .normal)
        continueButton.setTitle("Continue", for: .normal)
        continueButton.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.bold)
        continueButton.center = CGPoint(x: view.center.x, y: view.frame.height - continueButton.frame.height - 24)
        continueButton.highlightedColor = UIColor(white: 1.0, alpha: 1.0)
        continueButton.defaultColor = UIColor.white
        continueButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        view.addSubview(continueButton)
        setContinueButton(enabled: false)
        
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityView.color = secondaryColor
        activityView.frame = CGRect(x: 0, y: 0, width: 50.0, height: 50.0)
        activityView.center = continueButton.center
        view.addSubview(activityView)
        
        usernameField.delegate = self
        iidField.delegate = self
        passwordField.delegate = self
        
        usernameField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        iidField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        usernameField.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillAppear), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        usernameField.resignFirstResponder()
        iidField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
    
    @IBAction func handleDismissButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    /**
     Adjusts the center of the **continueButton** above the keyboard.
     - Parameter notification: Contains the keyboardFrame info.
     */
    
    @objc func keyboardWillAppear(notification: NSNotification){
        
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        continueButton.center = CGPoint(x: view.center.x,
                                        y: view.frame.height - keyboardFrame.height - 16.0 - continueButton.frame.height / 2)
        activityView.center = continueButton.center
    }
    
    /**
     Enables the continue button if the **username**, **iid**, and **password** fields are all non-empty.
     
     - Parameter target: The targeted **UITextField**.
     */
    
    @objc func textFieldChanged(_ target:UITextField) {
        let username = usernameField.text
        let iid = iidField.text
        let password = passwordField.text
        let formFilled = username != nil && username != "" && iid != nil && iid != "" && password != nil && password != ""
        setContinueButton(enabled: formFilled)
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Resigns the target textField and assigns the next textField in the form.
        
        switch textField {
        case usernameField:
            usernameField.resignFirstResponder()
            iidField.becomeFirstResponder()
            break
        case iidField:
            iidField.resignFirstResponder()
            passwordField.becomeFirstResponder()
            break
        case passwordField:
            handleSignUp()
            break
        default:
            break
        }
        return true
    }
    
    /**
     Enables or Disables the **continueButton**.
     */
    
    func setContinueButton(enabled:Bool) {
        if enabled {
            continueButton.alpha = 1.0
            continueButton.isEnabled = true
        } else {
            continueButton.alpha = 0.5
            continueButton.isEnabled = false
        }
    }
    
    @objc func handleSignUp() {
        guard let username = usernameField.text else { return }
        guard let iid = iidField.text else { return }
        guard let pass = passwordField.text else { return }
        guard var ip = ipField.text else { return }
        guard let zipcode = zipcodeField.text else { return }
        
        if(ip != "Allstate" && ip != "Nationwide" && ip != "State Farm")
        {
            ip = "ip_2"
        }
        else{
            ip = self.insurance_names![ip]!
        }
        
        print(username, iid, ip, zipcode, pass)
        
        
        setContinueButton(enabled: false)
        continueButton.setTitle("", for: .normal)
        activityView.startAnimating()
        
        self.apihelper.addUser(username: username, password: pass, zipcode: zipcode, iid: iid, ip: ip) { (result) in
            print(result)
        }
        
        self.performSegue(withIdentifier: "toLogin", sender: self)
        
        
        
//        Auth.auth().createUser(withiid: iid, password: pass) {user, error in
//            if error == nil && user != nil {
//                print("User created")
//            }else{
//                print("Error: \(error!.localizedDescription)")
//            }
//        }
    }
    
    
    
}
