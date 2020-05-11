//
//  Defects.swift
//  Project Planer
//
//  Created by Dilan Tharidu Sangeeth on 5/11/20.
//  Copyright © 2020 Dilan Tharidu Sangeeth. All rights reserved.
//

import Foundation

class Defects{
    
    let repo: String
    let commit: String
    let defect: String
    
    init(repo: String, commit: String, defect: String) {
        self.repo = repo
        self.commit = commit
        self.defect = defect
    }
    
    func getRepoName() -> String {
        return repo
    }
    
    func getCommitMessage() -> String {
          return commit
      }
    func getdefect() -> String {
          return defect
      }
    
}
