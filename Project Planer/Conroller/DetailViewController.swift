//
//  DetailViewController.swift
//  Project Planer
//
//  Created by Dilan Tharidu Sangeeth on 5/15/20.
//  Copyright © 2020 Dilan Tharidu Sangeeth. All rights reserved.
//

import UIKit
import CoreData
import EventKit

class DetailViewController: UIViewController, NSFetchedResultsControllerDelegate,  UIPopoverPresentationControllerDelegate , UITableViewDelegate, UITableViewDataSource {
   
    
    @IBOutlet weak var taskTable: UITableView!
    @IBOutlet weak var assessmentProgressBar: CircularProgressBar!
    @IBOutlet weak var dayProgressBar: CircularProgressBar!
    @IBOutlet weak var assessmentNameLab: UILabel!
    @IBOutlet weak var dueDateLab: UILabel!
    @IBOutlet weak var priorityLab: UILabel!
    @IBOutlet weak var assessmentDetailView: UIView!
    @IBOutlet weak var addTaskBut: UIBarButtonItem!
    @IBOutlet weak var editTaskBut: UIBarButtonItem!
    @IBOutlet weak var deleteTaskBut: UIBarButtonItem!
    @IBOutlet weak var ModuleNameLab: UILabel!
    
    var selectedAssessment: Assessment? {
        didSet {
//            // Update the view.
//            configureView()
        }
    }

    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return 1
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = taskTable.dequeueReusableCell(withIdentifier: "tCell", for: indexPath) as! TaskTableViewCell
        
        cell.taskNumLab.text = "task 1"
        cell.taskNameLab.text = "test task 1"
        cell.dueDateLab.text = "2020/05/16"
        cell.dayLeftLab.text = "10 days"
        
        
        cell.isUserInteractionEnabled = false
        cell.contentView.backgroundColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.00)
        cell.contentView.layer.cornerRadius = 10.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.00).cgColor
        cell.contentView.layer.masksToBounds = false

        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
       
}
