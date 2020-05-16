//
//  TaskTableViewCell.swift
//  Project Planer
//
//  Created by Dilan Tharidu Sangeeth on 5/15/20.
//  Copyright © 2020 Dilan Tharidu Sangeeth. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var taskNumLab: UILabel!
    @IBOutlet weak var taskNameLab: UILabel!
    @IBOutlet weak var dueDateLab: UILabel!
    @IBOutlet weak var dayLeftLab: UILabel!
    @IBOutlet weak var dayRemaingProBar: LinearProgressBar!
    @IBOutlet weak var taskProBar: CircularProgressBar!
    
    
    
    
    
    @IBAction func viewTaskNoteClick(_ sender: Any) {
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    }
    
}
