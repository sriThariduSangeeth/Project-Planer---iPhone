//
//  ProjectViewCell.swift
//  Project Planer
//
//  Created by Dilan Tharidu Sangeeth on 6/8/20.
//  Copyright © 2020 Dilan Tharidu Sangeeth. All rights reserved.
//

import UIKit

class ProjectViewCell: UITableViewCell{
    
    @IBOutlet weak var repoName: UILabel!
    
    @IBOutlet weak var repoDate: UILabel!
    
    @IBOutlet weak var taskCount: UILabel!
    
    override func layoutSubviews() {
             super.layoutSubviews()
             contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
         }
}
