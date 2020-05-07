//
//  GitHubServices.swift
//  Project Planer
//
//  Created by Dilan Tharidu Sangeeth on 5/7/20.
//  Copyright © 2020 Dilan Tharidu Sangeeth. All rights reserved.
//

import Foundation

class GitHubServices{
    
    let gitUserName : String
    let gitBaseURL : URL?
    
    init(UserName :String) {
        
        self.gitUserName = UserName
        gitBaseURL = URL(string: Constants.GIT_BASE_URL)
    }
    
    func getReposList(_ compltion: @escaping ([Repository]?) -> Void){
        
//        https://api.github.com/users/sriThariduSangeeth/repos
        
        var repoList = [Repository]()
        
        if let repoURL = URL(string: "\(gitBaseURL!)/\("users")/\(gitUserName)/\("repos")"){
            
            if CheckInternetConnection.connection(){
                let httpReqest = HttpAdapterService.init(url: repoURL)
                httpReqest.downloanJSONFromURL { (jsonResponse) in
                    if let repo = jsonResponse{
                        for cu in repo {
                            
                            let obj = cu as? [String:Any]
                            repoList += [Repository(id: (obj?["id"] as? Int)! , name: (obj?["name"] as? String)!)]
                        }
                                      
                        compltion(repoList)
                    }
                }
            }
            
        }else{
            print("somthing worng with URL")
            compltion(nil)
        }
    }
    
}
