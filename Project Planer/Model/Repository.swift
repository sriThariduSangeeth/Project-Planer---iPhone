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
    
    

    init(id : Int , name : String) {
        self.repoId = id
        self.repoName = name
    }
    
    
    func getRepoId() -> Int {
        return self.repoId
    }
    
    func getRepoName() -> String {
        return self.repoName
    }
}
