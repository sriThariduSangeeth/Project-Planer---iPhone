//
//  Repository.swift
//  Project Planer
//
//  Created by Dilan Tharidu Sangeeth on 5/7/20.
//  Copyright © 2020 Dilan Tharidu Sangeeth. All rights reserved.
//

import Foundation
class Repository{
    
    let repoId: Int
    let repoName: String
    let repoDate : String
    
    

    init(id : Int , name : String , date:String) {
        self.repoId = id
        self.repoName = name
        self.repoDate = date
    }
    
    
    func getRepoId() -> Int {
        return self.repoId
    }
    
    func getRepoName() -> String {
        return self.repoName
    }
    
    func getRepoDate() -> String {
        return self.repoDate
    }
}
