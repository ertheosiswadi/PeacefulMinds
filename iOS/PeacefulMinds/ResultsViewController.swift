//
//  ResultsViewController.swift
//  PeacefulMinds
//
//  Created by Ertheo Siswadi on 11/27/18.
//  Copyright © 2018 Peaceful Minds. All rights reserved.
//

import Foundation
import UIKit

class ResultsViewController: UIViewController {

    @IBOutlet weak var tableScrollView: UIScrollView!
    
    var activityView:UIActivityIndicatorView!
    
    var username : String?
    var procedure : String?
    var procedure_names : [String:String]?
    
    var part_2 : [String:Any] = [:]
    var s_array : Array<[String:Any]> = []
    var data : [[String:Any]] = []
    let apihelper = APIHelper.init()
    
    let h_name_height = 80;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if let received_username = username {
            print(received_username)
        }
        
        let procedure_names = ["Angioplasty":"procedure_1","Gastrectomy":"procedure_2","Fundoplication":"procedure_3"]
        
        //create the activity view
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityView.color = secondaryColor
        activityView.frame = CGRect(x: 0, y: 0, width: 500.0, height: 500.0)
        activityView.center = view.center
        
        view.addSubview(activityView)
        activityView.startAnimating()
        DispatchQueue.global(qos: .background).async{
            self.apihelper.getHospitalsInArea(username: self.username!, procedure: procedure_names[self.procedure!]!){ (result) in
                
                print(result[0])
                
                DispatchQueue.main.async {
                    self.activityView.stopAnimating()
                    var n_hospitals = result.count;
                    let spacing = 20;
                    let tb_height = 550;
                    for i in 0...result.count-1
                    {
                        self.add_hospital(hospital_json: result[i], n_ExistingHospitals: i)
                    }
                    self.tableScrollView.contentSize = CGSize(width: Int(self.tableScrollView.frame.size.width), height: 20 + n_hospitals * (tb_height + spacing))
                }
            }
        }
        
        let get_data = "[{\"part1\":[{\"price\":200,\"name\":\"s2\",\"i_adj\":120,\"post_adj\":80},{\"price\":300,\"name\":\"s3\",\"i_adj\":72,\"post_adj\":228},{\"name\":\"s5\",\"price\":250,\"i_adj\":125,\"post_adj\":125}],\"part_2\":{\"total_post_adj\":433,\"deductible\":52,\"insurance_coverage\":\"50%\",\"isDeductibleLessThan\":true,\"total_owe\":242.5,\"isInNetwork\":true}},{\"part1\":[{\"price\":200,\"name\":\"s2\",\"i_adj\":120,\"post_adj\":80},{\"price\":300,\"name\":\"s3\",\"i_adj\":72,\"post_adj\":228},{\"name\":\"s5\",\"price\":250,\"i_adj\":125,\"post_adj\":125}],\"part_2\":{\"total_post_adj\":434,\"deductible\":52,\"insurance_coverage\":\"50%\",\"isDeductibleLessThan\":true,\"total_owe\":242.5,\"isInNetwork\":true}}]".data(using: .utf8)!;
        do {
            let jsonArray = try JSONSerialization.jsonObject(with: get_data, options : .allowFragments) as? [[String:Any]]
            print(jsonArray)
            data = jsonArray!
//            let services_array = (jsonArray!["part1"] as! Array<[String:Any]>)
//            let part_2_dict = jsonArray!["part_2"] as! [String:Any]
//            part_2 = part_2_dict
//            print("part2", part_2)
//            s_array = services_array;
//            let s1 = services_array[0]
        } catch let error as NSError {
            print(error)
        }
        
        print(s_array)
        
        tableScrollView.backgroundColor = UIColor.clear;
        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        
        var ypos : CGFloat = 20;
        var scrollViewHeight : CGFloat = 0;
        var n_hospitals = data.count;
        let spacing = 50;
        let tb_height = 500;
//        add_hospital(hospital_json: data[0], n_ExistingHospitals: 0)
//        add_hospital(hospital_json: data[1], n_ExistingHospitals: 1)
//        tableScrollView.contentSize = CGSize(width: Int(tableScrollView.frame.size.width), height: 20 + n_hospitals * (tb_height + spacing))
        

    }
    func add_hospital(hospital_json:[String:Any], n_ExistingHospitals:Int)
    {
        let p1_array = (hospital_json["part1"] as! Array<[String:Any]>)
        let p2_dict = hospital_json["part_2"] as! [String:Any]
        
        
        let tb_width = 350;
        let tb_height = 550;
        
        let topmost_margin = 20;
        let spacing = 20;
        let ypos = topmost_margin + n_ExistingHospitals * (tb_height + spacing);
        let myTableView = UIView(frame: CGRect(x: 0, y: ypos, width: tb_width, height: tb_height))
        myTableView.center.x = self.view.center.x;
        myTableView.backgroundColor = UIColor.clear
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector (self.goToBill(_:)))
        myTableView.addGestureRecognizer(gesture)
        
        var j = 0;
        for i in p1_array
        {
            var row_array = ["a"]
            row_array.removeAll()
            row_array.append("\(i["name"] as! String)")
            row_array.append("$\(String(Int(i["price"] as! Double)))")
            row_array.append("$\(String(Int(i["i_adj"] as! Double)))")
            row_array.append("$\(String(Int(i["post_adj"] as! Double)))")
            addRow_2(content: row_array, nExistingRows: j, table: myTableView)
            j+=1;
        }
        var name = hospital_json["name"] as! String
//        if(name.count > 17)
//        {
//            name = String(name.prefix(17))
//        }
        add_hname(name: name, table: myTableView)//add_hname(name: "Hospital_\(n_ExistingHospitals)", table: myTableView)
        //add_theaders(table: myTableView)
        add_part2_2(table: myTableView, n_ExistingRows: p1_array.count, p2: p2_dict)
        tableScrollView.addSubview(myTableView)
    }
    func add_part2_2(table:UIView, n_ExistingRows:Int, p2:[String:Any])
    {
        let title = h_name_height
        let t_content = n_ExistingRows * (100 + 5)
        let space = 5
        var ypos = title + t_content + space
        
        let lb_width = 350;
        let lb_height = 120;
        let container = UIView(frame: CGRect(x: 0, y: ypos, width: lb_width, height: lb_height))
        
        container.roundCorners_v2(cornerRadius: 30.0)
        container.backgroundColor = UIColor.white
        
        
        var xpos = 145-20;
        ypos = 10
        let label_total = UILabel(frame: CGRect(x: xpos, y: ypos, width: 120, height: 20))
        label_total.text = "Total"
        label_total.textAlignment = .right
        label_total.font = UIFont(name: "Montserrat-Regular", size: 12)
        label_total.textColor = secondaryColor
        let label_total_val = UILabel(frame: CGRect(x: xpos + 120 + 15, y: ypos, width: 120, height: 20))
        let tot_val = Double(p2["total_post_adj"]! as! Double)
        label_total_val.text = "$\(String(format: "%.2f", tot_val))"
        label_total_val.font = UIFont(name: "Montserrat-Regular", size: 12)
        label_total_val.textColor = secondaryColor
        
        ypos = ypos + 20 + 1
        let label_coverage = UILabel(frame: CGRect(x: xpos, y: ypos, width: 120, height: 20))
        label_coverage.text = "Coverage"
        label_coverage.textAlignment = .right
        label_coverage.font = UIFont(name: "Montserrat-Regular", size: 12)
        label_coverage.textColor = secondaryColor
        let label_coverage_val = UILabel(frame: CGRect(x: xpos + 120 + 15, y: ypos, width: 120, height: 20))
        label_coverage_val.text = "\(p2["insurance_coverage"]!)"
        label_coverage_val.font = UIFont(name: "Montserrat-Regular", size: 12)
        label_coverage_val.textColor = secondaryColor
        
        ypos = ypos + 20 + 1
        let label_deductible = UILabel(frame: CGRect(x: xpos, y: ypos, width: 120, height: 20))
        label_deductible.text = "Deductible"
        label_deductible.textAlignment = .right
        label_deductible.font = UIFont(name: "Montserrat-Regular", size: 12)
        label_deductible.textColor = secondaryColor
        let label_deductible_val = UILabel(frame: CGRect(x: xpos + 120 + 15, y: ypos, width: 120, height: 20))
        label_deductible_val.text = "$\(p2["deductible"]!)"
        label_deductible_val.font = UIFont(name: "Montserrat-Regular", size: 12)
        label_deductible_val.textColor = secondaryColor
        
        ypos = ypos + 20
        let label_totalowe = UILabel(frame: CGRect(x: xpos, y: ypos, width: 120, height: 30))
        label_totalowe.text = "Total Owe"
        label_totalowe.textAlignment = .right
        label_totalowe.font = UIFont(name: "Montserrat-SemiBold", size: 17)
        label_totalowe.textColor = secondaryColor
        let label_totalowe_val = UILabel(frame: CGRect(x: xpos + 120 + 15, y: ypos, width: 120, height: 30))
        let tot_owe_val = Double(p2["total_owe"]! as! Double)
        label_totalowe_val.text = "$\(String(format: "%.2f", tot_owe_val))"
        label_totalowe_val.font = UIFont(name: "Montserrat-SemiBold", size: 17)
        label_totalowe_val.textColor = secondaryColor
        
        container.addSubview(label_total)
        container.addSubview(label_coverage)
        container.addSubview(label_deductible)
        container.addSubview(label_totalowe)
        
        container.addSubview(label_total_val)
        container.addSubview(label_coverage_val)
        container.addSubview(label_deductible_val)
        container.addSubview(label_totalowe_val)
        
        
        table.addSubview(container)
    }
    func add_part2(table:UIView, n_ExistingRows:Int, p2:[String:Any])
    {
        let title = h_name_height
        let t_headers = 40
        let t_content = 50*n_ExistingRows
        var ypos = CGFloat(title + t_headers + t_content)
        let first_col = ["Total", "Coverage", "Deductible", "Total Owe"]
        let second_col = ["total_post_adj","insurance_coverage","deductible","total_owe"]
        
        
        
        var row_width = 350;
        var row_height = 50;
        var lb_width = row_width/5
        var lb_height = row_height
        for i in 0...3
        {
            var row = UIView(frame: CGRect(x: 0, y: 0, width: row_width, height: row_height))
            row.frame.origin.y = ypos;
            row.backgroundColor = UIColor.purple;
            
            var label_3 = UIView(frame: CGRect(x: lb_width*2, y: 0, width: lb_width*2, height: lb_height))
            label_3.backgroundColor = UIColor.white
            let l3_in = UILabel(frame: CGRect(x: 15, y: 2, width: lb_width*2-15, height: lb_height-2))
            l3_in.text = first_col[i]
            label_3.addSubview(l3_in)
            
            var label_4 = UIView(frame: CGRect(x: lb_width * 4, y: 0, width: lb_width, height: lb_height))
            label_4.backgroundColor = UIColor.white
            let l4_in = UILabel(frame: CGRect(x: 5, y: 2, width: lb_width-5, height: lb_height-2))
            if(i == 1)
            {
                l4_in.text = p2[second_col[i]] as! String
            }
            else {
                l4_in.text = "$\(String(Int(p2[second_col[i]] as! Double)))"
            }
            label_4.addSubview(l4_in)
            
            row.addSubview(label_3)
            row.addSubview(label_4)
            table.addSubview(row)
            
            ypos += 50
        }
        
//        var label_4 = UIView(frame: CGRect(x: lb_width * 3, y: 0, width: lb_width, height: lb_height))
//        label_4.backgroundColor = UIColor.yellow
//        let l4_in = UILabel(frame: CGRect(x: 5, y: 2, width: lb_width-5, height: lb_height-2))
//        l4_in.text = content[3]
//        label_4.addSubview(l4_in)
//
//
//        row.addSubview(label_4)
        
        
    }
    func add_hname(name: String, table:UIView)
    {
        let lb_width = 350;
        let lb_height = h_name_height;
        let container = UIView(frame: CGRect(x: 0, y: 0, width: lb_width, height: h_name_height))
        let title_1 = UILabel(frame: CGRect(x: 20, y: 10, width: lb_width-10, height: lb_height-10))
//        let title_2 = UILabel(frame: CGRect(x: 20, y: lb_height-10, width: lb_width-10, height: lb_height-10))
        
        container.roundCorners_v1(cornerRadius: 30.0)
        container.backgroundColor = UIColor.white
        
        var name_0 = name
        var name_1 = ""
        
        //split the name
        if(name.count > 17)
        {
            name_0 = String(name.prefix(18))
            name_1 = "-\(String(name.suffix(name.count - 18)))"
        }
        
        title_1.text = name_0;
        title_1.font = UIFont.boldSystemFont(ofSize: 50.0)
        title_1.font = UIFont(name: "Montserrat-SemiBold", size: 30)
        title_1.textColor = primaryColor
        
//        title_2.text = name_1;
//        title_2.font = UIFont.boldSystemFont(ofSize: 50.0)
//        title_2.font = UIFont(name: "Montserrat-SemiBold", size: 30)
//        title_2.textColor = primaryColor
        
        table.addSubview(container)
        container.addSubview(title_1)
        //container.addSubview(title_2)
    }
    func add_theaders(table:UIView)
    {
        var row_width = 350;
        var row_height = 40;
        var space = 10;
        var row = UIView(frame: CGRect(x: 0, y: 0, width: row_width, height: row_height))
        let h_name = h_name_height;
        let table_headers = 40;
        let ypos = CGFloat(80);
        row.frame.origin.y = ypos;
        row.backgroundColor = UIColor.purple;
        
        let lb_width = (row_width)/5
        let l1_width = row_width*2/5
        let lb_height = 40
        var label_1 = UIView(frame: CGRect(x: 0, y: 0, width: l1_width, height: lb_height))
        label_1.backgroundColor = UIColor.red
        label_1.layer.borderColor = UIColor.black.cgColor
        label_1.layer.borderWidth = 1.0;
        let l1_in = UILabel(frame: CGRect(x: 5, y: 2, width: l1_width-5, height: lb_height-2))
        l1_in.text = "Description"
        label_1.addSubview(l1_in)
        
        
        var label_2 = UIView(frame: CGRect(x: lb_width * 2, y: 0, width: lb_width, height: lb_height))
        label_2.backgroundColor = UIColor.green
        let l2_in = UILabel(frame: CGRect(x: 5, y: 2, width: lb_width-5, height: lb_height-2))
        l2_in.text = "Cost"
        label_2.addSubview(l2_in)
        
        
        
        var label_3 = UIView(frame: CGRect(x: lb_width * 3, y: 0, width: lb_width, height: lb_height))
        label_3.backgroundColor = UIColor.blue
        let l3_in = UILabel(frame: CGRect(x: 5, y: 2, width: lb_width-5, height: lb_height-2))
        l3_in.text = "Insurance\n Adjustment"
        l3_in.numberOfLines = 0;
        label_3.addSubview(l3_in)
        
        
        var label_4 = UIView(frame: CGRect(x: lb_width * 4, y: 0, width: lb_width, height: lb_height))
        label_4.backgroundColor = UIColor.yellow
        let l4_in = UILabel(frame: CGRect(x: 5, y: 2, width: lb_width-5, height: lb_height-2))
        l4_in.text = "Post Adjustment"
        label_4.addSubview(l4_in)
        
        row.addSubview(label_1)
        row.addSubview(label_2)
        row.addSubview(label_3)
        row.addSubview(label_4)
        
        table.addSubview(row);
    }
    func addRow_2(content:Array<String>, nExistingRows:Int, table:UIView)
    {
        var row_width = 350;
        var row_height = 100;
        
        var space = 5;
        let h_name = h_name_height;
        let ypos = nExistingRows * (row_height + space) + h_name + space;
        
        var row = UIView(frame: CGRect(x: 0, y: ypos, width: row_width, height: row_height))
        row.backgroundColor = UIColor.white
        
        //add name of service
        let ypos_0 = 15;
        var label_name = UILabel(frame: CGRect(x: 20, y: 15, width: 300, height: 30))
        label_name.text = content[0]
        label_name.font = UIFont(name: "Montserrat-SemiBold", size: 20)
        label_name.textColor = primaryColor
        
        let ypos_1 = ypos_0 + 30 + 10;
        var label_cost_val = UILabel(frame: CGRect(x: 20, y: ypos_1, width: 70, height: 15))
        label_cost_val.text = content[1]
        label_cost_val.font = UIFont(name: "Montserrat-SemiBold", size: 13)
        label_cost_val.textColor = primaryColor
        
        var xpos = row_width/2-15-10
        var label_adj_val = UILabel(frame: CGRect(x: xpos, y: ypos_1, width: 70, height: 15))
        label_adj_val.text = content[2]
        label_adj_val.font = UIFont(name: "Montserrat-SemiBold", size: 13)
        label_adj_val.textColor = primaryColor
        
        xpos = row_width-15-70
        var label_post_val = UILabel(frame: CGRect(x: xpos, y: ypos_1, width: 70, height: 15))
        label_post_val.text = content[3]
        label_post_val.font = UIFont(name: "Montserrat-SemiBold", size: 13)
        label_post_val.textColor = primaryColor
        
        xpos = 100
        var label_minus = UILabel(frame: CGRect(x: xpos, y: ypos_1, width: 20, height: 15))
        label_minus.text = "-"
        label_minus.font = UIFont(name: "Montserrat-SemiBold", size: 13)
        label_minus.textColor = primaryColor
        
        xpos = ((row_width/2-15-10) + (row_width-15-70))/2 + 15
        var label_equal = UILabel(frame: CGRect(x: xpos, y: ypos_1, width: 10, height: 15))
        label_equal.text = "="
        label_equal.font = UIFont(name: "Montserrat-SemiBold", size: 13)
        label_equal.textColor = primaryColor
        
        //dibawahnya lagi
        let ypos_2 = ypos_1 + 15 + 1
        xpos = 20 + 10
        var label_cost = UILabel(frame: CGRect(x: xpos, y: ypos_2, width: 90, height: 15))
        label_cost.text = "Cost"
        label_cost.font = UIFont(name: "Montserrat-Regular", size: 8)
        label_cost.textColor = primaryColor
        
        xpos = row_width/2-15-10 + 3
        var label_insurance = UILabel(frame: CGRect(x: xpos, y: ypos_2, width: 90, height: 15))
        label_insurance.text = "Adjustment"
        label_insurance.font = UIFont(name: "Montserrat-Regular", size: 8)
        label_insurance.textColor = primaryColor
        
        xpos = row_width-15-70 + 13
        var label_post = UILabel(frame: CGRect(x: xpos, y: ypos_2, width: 90, height: 15))
        label_post.text = "Post-Adj"
        label_post.font = UIFont(name: "Montserrat-Regular", size: 8)
        label_post.textColor = primaryColor
        
        
        row.addSubview(label_name)
        row.addSubview(label_cost_val)
        row.addSubview(label_adj_val)
        row.addSubview(label_post_val)
        row.addSubview(label_minus)
        row.addSubview(label_equal)
        row.addSubview(label_cost)
        row.addSubview(label_insurance)
        row.addSubview(label_post)
        table.addSubview(row)
        
    }
    func addRow(content:Array<String>, nExistingRows:Int, table:UIView)
    {
        var row_width = 350;
        var row_height = 50;
        var space = 10;
        var row = UIView(frame: CGRect(x: 0, y: 0, width: row_width, height: row_height))
        let h_name = h_name_height;
        let table_headers = 40;
        let ypos = CGFloat(nExistingRows * (50) + h_name + table_headers);
        row.frame.origin.y = ypos;
        row.backgroundColor = UIColor.purple;
        
        let lb_width = (row_width)/5
        let l1_width = (row_width*2)/5
        let lb_height = 50
        var label_1 = UIView(frame: CGRect(x: 0, y: 0, width: l1_width, height: lb_height))
        label_1.backgroundColor = UIColor.red
        let l1_in = UILabel(frame: CGRect(x: 5, y: 2, width: l1_width-5, height: lb_height-2))
        l1_in.text = content[0]
        l1_in.font = UIFont.systemFont(ofSize: 12)
        label_1.addSubview(l1_in)
        
        
        var label_2 = UIView(frame: CGRect(x: lb_width * 2, y: 0, width: lb_width, height: lb_height))
        label_2.backgroundColor = UIColor.green
        let l2_in = UILabel(frame: CGRect(x: 5, y: 2, width: lb_width-5, height: lb_height-2))
        l2_in.text = content[1]
        label_2.addSubview(l2_in)
        
        
        var label_3 = UIView(frame: CGRect(x: lb_width * 3, y: 0, width: lb_width, height: lb_height))
        label_3.backgroundColor = UIColor.blue
        let l3_in = UILabel(frame: CGRect(x: 5, y: 2, width: lb_width-5, height: lb_height-2))
        l3_in.text = content[2]
        label_3.addSubview(l3_in)
        
        
        var label_4 = UIView(frame: CGRect(x: lb_width * 4, y: 0, width: lb_width, height: lb_height))
        label_4.backgroundColor = UIColor.yellow
        let l4_in = UILabel(frame: CGRect(x: 5, y: 2, width: lb_width-5, height: lb_height-2))
        l4_in.text = content[3]
        label_4.addSubview(l4_in)

        row.addSubview(label_1)
        row.addSubview(label_2)
        row.addSubview(label_3)
        row.addSubview(label_4)
        
        table.addSubview(row);
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func goToBill(_ sender:UITapGestureRecognizer){
        // do other task
        self.performSegue(withIdentifier: "toBill", sender: self)
    }
}


