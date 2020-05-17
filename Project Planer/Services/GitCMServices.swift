//
//  GitCMServices.swift
//  Project Planer
//
//  Created by Dilan Tharidu Sangeeth on 5/7/20.
//  Copyright © 2020 Dilan Tharidu Sangeeth. All rights reserved.
//

import Foundation

class GitCMServices {
    
    let gitUserName : String
    let gitBaseURL : URL?
      
    init(UserName :String) {
        self.gitUserName = UserName
        gitBaseURL = URL(string: Constants.GCM_BASE_URL)
    }
    
        func getDefectsList(_ compltion: @escaping ([Defects]?) -> Void){
            
    //        http://localhost:8990/dataservice/git/dtsangeeth/getUserdefectsList
            
            var defectsList = [Defects]()
            
            if let repoURL = URL(string: "\(gitBaseURL!)/\(gitUserName)/\("getUserdefectsList")"){
                
                if CheckInternetConnection.connection(){
                    let httpReqest = HttpAdapterService.init(url: repoURL)
                    httpReqest.downloanJSONFromURL { (jsonResponse) in
                        if let repo = jsonResponse{
                            for cu in repo {
                                
                                let obj = cu as? [String:Any]
                                defectsList += [Defects(repo:  (obj?["created_at"] as? String)!, commit:  (obj?["created_at"] as? String)!, defect:  (obj?["created_at"] as? String)!, className:  (obj?["created_at"] as? String)!)]
                            }
                                          
                            compltion(defectsList)
                        }
                    }
                }
                
            }else{
                print("somthing worng with URL")
                compltion(nil)
            }
        }
}


