//
//  APIHelper.swift
//  PeacefulMinds
//
//  Created by Ertheo Siswadi on 11/27/18.
//  Copyright © 2018 Peaceful Minds. All rights reserved.
//

import Foundation

class APIHelper {
    init() {
        
    }
    
    func getRequest(username:String, procedure: String, completeHandler: @escaping (_ profile: [[String:Any]]) -> ())
    {
        let uri = "https://peaceful-minds.herokuapp.com/\(username)/\(procedure)";
        let endpoint:String = uri
        print("debug - get - url \(endpoint)")
        let url = URL(string: endpoint)
        let urlRequest = URLRequest(url: url!)
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        var toReturn:[[String:Any]] = [[:]]
        
        let task = session.dataTask(with: urlRequest, completionHandler: {(data, response, error) -> Void in
            
            guard let responseData = data else {
                print("Error: did not receive data")
                //send emptystring to callback func completeHandler
                completeHandler([[:]])
                return
            }
            
            do
            {
                guard let json_obj = try JSONSerialization.jsonObject(with: responseData, options: [])as? [[String: Any]]
                    else{
                        completeHandler([[:]])
                        return
                }
                
                print("data fetched is: ", json_obj)
                toReturn = json_obj
                
                completeHandler(toReturn)
                DispatchQueue.main.async {
                }
            }
            catch
            {
                print("error jsonserial")
                completeHandler([[:]])
                return
            }
        })
        
        task.resume()
    }
    func addUser(username:String, password:String, zipcode:String, iid:String, ip:String, completeHandler: @escaping (_ profile: String) -> ())
    {
        let uri = "https://peaceful-minds.herokuapp.com/add_user/\(username)/\(password)/\(zipcode)/\(iid)/\(ip)"
        let endpoint:String = uri
        print("debug - get - url \(endpoint)")
        let url = URL(string: endpoint)
        let urlRequest = URLRequest(url: url!)
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        var toReturn:String = ""
        
        let task = session.dataTask(with: urlRequest, completionHandler: {(data, response, error) -> Void in
            
            guard let responseData = data else {
                print("Error: did not receive data")
                //send emptystring to callback func completeHandler
                completeHandler("")
                return
            }
            
            do
            {
                if let returnData = String(data: responseData, encoding: .utf8) {
                    completeHandler(returnData)
                } else {
                    completeHandler("")
                }
                DispatchQueue.main.async {
                }
            }
            catch
            {
                print("error jsonserial")
                completeHandler("")
                return
            }
        })
        
        task.resume()
    }
    
}

