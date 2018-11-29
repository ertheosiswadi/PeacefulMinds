//
//  SecondViewController.swift
//  APIC
//
//  Created by Anthony Lei on 11/26/18.
//  Copyright © 2018 APIC. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var searchButton: UIButton!
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ResultsViewController{
            let navVC = segue.destination as? ResultsViewController
            navVC?.procedure = searchBar.text
        }
        
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
 
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

