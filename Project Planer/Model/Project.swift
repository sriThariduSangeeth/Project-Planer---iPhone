//
//  Project.swift
//  Project Planer
//
//  Created by Dilan Tharidu Sangeeth on 5/8/20.
//  Copyright © 2020 Dilan Tharidu Sangeeth. All rights reserved.
//

import Foundation

class Project{
    
    let name: String
    let date: String
    let count: String
    
    init(name: String, date: String, count: String) {
        self.name = name
        self.date = date
        self.count = count
    }
    
    func getRepoName() -> String {
        return name
    }
    
    func getRepoDate() -> String {
          return date
      }
    func getTaskCount() -> String {
          return count
      }
    
}
