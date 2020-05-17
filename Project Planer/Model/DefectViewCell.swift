//
//  DefectViewCell.swift
//  Project Planer
//
//  Created by Dilan Tharidu Sangeeth on 5/11/20.
//  Copyright © 2020 Dilan Tharidu Sangeeth. All rights reserved.
//

import UIKit

class DefectViewCell: UITableViewCell {
    @IBOutlet weak var repo: UILabel!
    
    @IBOutlet weak var commitM: UILabel!
    
    @IBOutlet weak var defect: UILabel!

    @IBOutlet weak var className: UILabel!
    
    override func layoutSubviews() {
             super.layoutSubviews()
             contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
         }
}
