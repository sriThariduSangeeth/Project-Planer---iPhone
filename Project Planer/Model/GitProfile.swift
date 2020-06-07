//
//  GitProfile.swift
//  Project Planer
//
//  Created by Dilan Tharidu Sangeeth on 6/7/20.
//  Copyright © 2020 Dilan Tharidu Sangeeth. All rights reserved.
//

import Foundation

class GitProfile{
    
    let profileName: String
    let profileAvatar : String
    let profileuserName: String
    let profileEmail: String
    let profileCompany :String
    let repoCount : Int
    
    init(name: String, proUrl: String , username: String, email: String , company :String , repoCount : Int) {
        self.profileName = name
        self.profileuserName = username
        self.profileEmail = email
        self.profileCompany = company
        self.profileAvatar = proUrl
        self.repoCount = repoCount
    }
    
    func getProfileName() -> String {
        return profileName
    }
    
    func getProfileUserName() -> String {
          return profileuserName
    }
    func getProfileEmail() -> String {
          return profileEmail
    }
    func getProfileComapny() -> String {
        return profileCompany
    }
    
}
