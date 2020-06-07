//
//  HttpAdapterService.swift
//  Project Planer
//
//  Created by Dilan Tharidu Sangeeth on 5/7/20.
//  Copyright © 2020 Dilan Tharidu Sangeeth. All rights reserved.
//

import Foundation

class HttpAdapterService {

    lazy var configaration: URLSessionConfiguration = URLSessionConfiguration.default
    lazy var session: URLSession = URLSession(configuration: self.configaration)
    let url: URL
    
    init(url : URL) {
        self.url = url
    }
    
    typealias JSONDictationryHandler = (([Any]?) -> Void)
    typealias JSONObjectDictationryHandler = (([String : Any]?) -> Void)
    
    func downloanJSONFromURL(_ compltion: @escaping JSONDictationryHandler){
        
        let request = URLRequest(url: self.url)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                if let httpResponse = response as? HTTPURLResponse{
                    switch httpResponse.statusCode {
                    case 200:
                        if let data = data{
                            do {
                                let jsonResponce = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
                                compltion(jsonResponce as? [Any])
                            }catch let error as NSError{
                                print("Error processing data : \(error.localizedDescription)")
                            }
                        }
                    default:
                        print(" HTTP Response Statcode : \(httpResponse.statusCode)")
                    }
                }
            }else {
                print("Error : \(error?.localizedDescription as Optional)")
            }
        }
        dataTask.resume()
    }
    
    
    func downloanJSONObjectFromURL(_ compltion: @escaping JSONObjectDictationryHandler){
        
        let request = URLRequest(url: self.url)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            if error == nil {
                if let httpResponse = response as? HTTPURLResponse{
                    switch httpResponse.statusCode {
                    case 200:
                        if let data = data{
                            do {
                                let jsonResponce = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                                compltion(jsonResponce as? [String:Any])
                            }catch let error as NSError{
                                print("Error processing data : \(error.localizedDescription)")
                            }
                        }
                    default:
                        print(" HTTP Response Statcode : \(httpResponse.statusCode)")
                    }
                }
            }else {
                print("Error : \(error?.localizedDescription)")
            }
        }
        dataTask.resume()
    }
}
