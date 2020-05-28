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
    @IBOutlet weak var celenderPin: UIImageView!
    
    
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
    
    func commonInit(_ assessmentName: String, taskProgress: CGFloat, marksVal: Float, dueDate: Date, notes: String , value: Float , addCalender: Bool) {
        var iconName = "asse1"
        if marksVal <= 40{
            iconName = "asse1"
        } else if marksVal >= 41 && marksVal <= 60 {
            iconName = "asse2"
        } else if marksVal >= 61 {
            iconName = "asse3"
        }
        
        if addCalender {
            celenderPin.isHidden = false
        }else{
            celenderPin.isHidden = true
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        
        priorityIcon.image = UIImage(named: iconName)
        assessNameLab.text = assessmentName
        dueDateLab.text = "Due: \(formatter.string(from: dueDate))"
        marks.text = "\(NSString(format: "%.2f", marksVal) as String) %"
        self.notes = notes
    }
    
}

protocol AssessmentTableViewCellDelegate {
    func customCell(cell: AssessmentTableViewCell, sender button: UIButton, data: String)
}
