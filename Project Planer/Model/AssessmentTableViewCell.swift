//
//  AssessmentTableViewCell.swift
//  Project Planer
//
//  Created by Dilan Tharidu Sangeeth on 5/15/20.
//  Copyright © 2020 Dilan Tharidu Sangeeth. All rights reserved.
//

import UIKit

class AssessmentTableViewCell: UITableViewCell {
    
    var cellDelegate: AssessmentTableViewCellDelegate?
    var notes: String = "Not Available"
    
    @IBOutlet weak var priorityIcon: UIImageView!
    @IBOutlet weak var assessNameLab: UILabel!
    @IBOutlet weak var dueDateLab: UILabel!
    @IBOutlet weak var marks: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func viewNoteAssess(_ sender: Any) {
        self.cellDelegate?.customCell(cell: self, sender: sender as! UIButton, data: notes)
    }
    
    func commonInit(_ assessmentName: String, taskProgress: CGFloat, marks: Float, dueDate: Date, notes: String) {
        var iconName = "asses1"
        if marks <= 40{
            iconName = "asses1"
        } else if marks >= 41 && marks <= 60 {
            iconName = "asses2"
        } else if marks >= 61 {
            iconName = "asses3"
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        
        priorityIcon.image = UIImage(named: iconName)
        assessNameLab.text = assessmentName
        dueDateLab.text = "Due: \(formatter.string(from: dueDate))"
        self.notes = notes
    }
    
}

protocol AssessmentTableViewCellDelegate {
    func customCell(cell: AssessmentTableViewCell, sender button: UIButton, data: String)
}
