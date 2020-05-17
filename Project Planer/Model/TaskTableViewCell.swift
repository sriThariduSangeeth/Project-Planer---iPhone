//
//  TaskTableViewCell.swift
//  Project Planer
//
//  Created by Dilan Tharidu Sangeeth on 5/15/20.
//  Copyright © 2020 Dilan Tharidu Sangeeth. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    var cellDelegate: TaskTableViewCellDelegate?
    var notes: String = "Not Available"
    
    @IBOutlet weak var taskNumLab: UILabel!
    @IBOutlet weak var taskNameLab: UILabel!
    @IBOutlet weak var dueDateLab: UILabel!
    @IBOutlet weak var dayLeftLab: UILabel!
    @IBOutlet weak var dayRemaingProBar: LinearProgressBar!
    @IBOutlet weak var taskProBar: CircularProgressBar!
    
    let now: Date = Date()
    let colours: Colours = Colours()
    let formatter: Formatter = Formatter()
    let calculations: Calculations = Calculations()
    
    override func awakeFromNib() {
         super.awakeFromNib()
         // Initialization code
     }

     override func setSelected(_ selected: Bool, animated: Bool) {
         super.setSelected(selected, animated: animated)

         // Configure the view for the selected state
     }
    
    
    
    @IBAction func viewTaskNoteClick(_ sender: Any) {
        self.cellDelegate?.viewNotes(cell: self, sender: sender as! UIButton, data: notes)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
    }
    
    
    
    func commonInit(_ taskName: String, taskProgress: CGFloat, startDate: Date, dueDate: Date, notes: String, taskNo: Int) {
        let (daysLeft, hoursLeft, minutesLeft) = calculations.getTimeDiff(now, end: dueDate)
        let remainingDaysPercentage = calculations.getRemainingTimePercentage(startDate, end: dueDate)
        
        taskNameLab.text = taskName
        dueDateLab.text = "Due: \(formatter.formatDate(dueDate))"
        dayLeftLab.text = "\(daysLeft) Days \(hoursLeft) Hours \(minutesLeft) Minutes Remaining"
        
        DispatchQueue.main.async {
            let colours = self.colours.getProgressGradient(Int(taskProgress))
            self.taskProBar.startGradientColor = colours[0]
            self.taskProBar.endGradientColor = colours[1]
            self.taskProBar.progress = taskProgress / 100
        }
        
        DispatchQueue.main.async {
            let colours = self.colours.getProgressGradient(remainingDaysPercentage, negative: true)
            self.dayRemaingProBar.startGradientColor = colours[0]
            self.dayRemaingProBar.endGradientColor = colours[1]
            self.dayRemaingProBar.progress = CGFloat(remainingDaysPercentage) / 100
        }
        
        taskNumLab.text = "Task \(taskNo)"
        self.notes = notes
    }
    
}

protocol TaskTableViewCellDelegate {
    func viewNotes(cell: TaskTableViewCell, sender button: UIButton, data data: String)
}
