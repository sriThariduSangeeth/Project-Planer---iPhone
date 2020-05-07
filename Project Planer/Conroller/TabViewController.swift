//
//  TabViewController.swift
//  Project Planer
//
//  Created by Dilan Tharidu Sangeeth on 5/7/20.
//  Copyright © 2020 Dilan Tharidu Sangeeth. All rights reserved.
//

import UIKit


class TabViewController: UITabBarController, UITabBarControllerDelegate {
    
    var userName: String?
    var password: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // instruct UITabBarController subclass to handle its own delegate methods
        self.delegate = self
        
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        if viewController is MyDashBoardContoller {
            print("Dashborad tab")
        } else if viewController is ProjectViewContoller {
            print("Project tab")
        } else if viewController is SettingViewController {
            print("settings tab")
        }
    }
}

