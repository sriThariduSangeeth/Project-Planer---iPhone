//
//  TaskAddViewController.swift
//  Project Planer
//
//  Created by Dilan Tharidu Sangeeth on 5/16/20.
//  Copyright © 2020 Dilan Tharidu Sangeeth. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import UserNotifications


class TaskAddViewController: UITableViewController, UIPopoverPresentationControllerDelegate, UITextViewDelegate, UNUserNotificationCenterDelegate {
    
    var tasks: [NSManagedObject] = []
    let dateFormatter : DateFormatter = DateFormatter()
    var dueDatePickerVisible = false
    var startDatePickerVisible = false
    var taskProgressVisible = false
    
    var selectedAssessment: Assessment?
    var editingMode: Bool = false
    let now = Date()

    let formatter: Formatter = Formatter()
    let setNotify:SetNotificationCelender = SetNotificationCelender()
    let notificationCenter = UNUserNotificationCenter.current()
    
    @IBOutlet weak var addToCelender: UISwitch!
    @IBOutlet weak var taskNameLab: UITextField!
    @IBOutlet weak var taskNoteView: UITextView!
    @IBOutlet weak var taskStartDateLab: UILabel!
    @IBOutlet weak var taskStartDatePicker: UIDatePicker!
    @IBOutlet weak var taskEndDateLab: UILabel!
    @IBOutlet weak var taskEndDatePicker: UIDatePicker!
    @IBOutlet weak var taskProgressLab: UILabel!
    @IBOutlet weak var taskProgressSliderLab: UILabel!
    @IBOutlet weak var taskProgressSlider: UISlider!
    @IBOutlet weak var cancelTaskBut: UIBarButtonItem!
    @IBOutlet weak var saveTaskBut: UIBarButtonItem!
    
    var editingTask: Task? {
        didSet {
            // Update the view.
            editingMode = true
            configureView()
        }
    }
    
    // Dismiss Popover
    func dismissAddTaskPopOver() {
        dismiss(animated: true, completion: nil)
    popoverPresentationController?.delegate?.popoverPresentationControllerDidDismissPopover?(popoverPresentationController!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure User Notification Center
        notificationCenter.delegate = self
        
        // set end date picker maximum date to project end date
        taskEndDatePicker.maximumDate = selectedAssessment!.dueDate as Date
        
        if !editingMode {
            // Set start date to current
            taskStartDatePicker.minimumDate = now
            taskStartDateLab.text = formatter.formatDate(now)
            
            // Set end date to one minute ahead of current time
            var time = Date()
            time.addTimeInterval(TimeInterval(60.00))
            taskEndDateLab.text = formatter.formatDate(time)
            taskEndDatePicker.minimumDate = time
            
            // Settings the placeholder for notes UITextView
            taskNoteView.delegate = self
            taskNoteView.text = "Notes"
            taskNoteView.textColor = UIColor.darkGray
            
            // Setting the initial task progress
            taskProgressSlider.value = 0
            taskProgressLab.text = "0 %"
            taskProgressSliderLab.text = "0 % Completed"
        }
        
        configureView()
        // Disable add button
        toggleAddButtonEnability()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    func configureView(){
        
        if editingMode {
            self.navigationItem.title = "Edit Task"
            self.navigationItem.rightBarButtonItem?.title = "Edit"
        }
        if let task = editingTask {
            if let textField = taskNameLab {
                textField.text = task.name
            }
            if let textView = taskNoteView {
                textView.text = task.notes
            }
            if let label = taskStartDateLab {
                label.text = formatter.formatDate(task.startDate as Date)
            }
            if let datePicker = taskStartDatePicker {
                datePicker.date = task.startDate as Date
            }
            if let label = taskEndDateLab {
                label.text = formatter.formatDate(task.dueDate as Date)
            }
            if let datePicker = taskEndDatePicker {
                datePicker.date = task.dueDate as Date
            }
            if let uiSwitch = addToCelender {
                uiSwitch.setOn(task.addNotification, animated: true)
            }
            if let label = taskProgressSliderLab {
                label.text = "\(Int(task.progress))% Completed"
            }
            if let label = taskProgressLab {
                label.text = "\(Int(task.progress))%"
            }
            if let slider = taskProgressSlider {
                slider.value = task.progress
            }
        }
        
    }
    
    // Handles the add button enable state
    func toggleAddButtonEnability() {
        if validate() {
            saveTaskBut.isEnabled = true;
        } else {
            saveTaskBut.isEnabled = false;
        }
    }
    
    // Check if the required fields are empty or not
    func validate() -> Bool {
        if !(taskNameLab.text?.isEmpty)! && !(taskNoteView.text == "Notes") && !(taskNoteView.text?.isEmpty)! {
            return true
        }
        return false
    }
    
    
    @IBAction func handleTaskNameChange(_ sender: UITextField) {
        toggleAddButtonEnability()
    }
    
    @IBAction func handleAddCelenderChange(_ sender: UISwitch) {
        
    }
    @IBAction func handleTaskStartDateChange(_ sender: UIDatePicker) {
        taskStartDateLab.text = formatter.formatDate(sender.date)
        
        // Set end date minimum to one minute ahead the start date
        let dueDate = sender.date.addingTimeInterval(TimeInterval(60.00))
        taskEndDatePicker.minimumDate = dueDate
        taskEndDateLab.text = formatter.formatDate(dueDate)
    }
    
    @IBAction func handleTaskEndDateChange(_ sender: UIDatePicker) {
        taskEndDateLab.text = formatter.formatDate(sender.date)
        
        // Set start date maximum to one minute before the end date
        taskStartDatePicker.maximumDate = sender.date.addingTimeInterval(-TimeInterval(60.00))
    }
    
    @IBAction func handleTaskProgressChange(_ sender: UISlider) {
        let progress = Int(sender.value)
        taskProgressLab.text = "\(progress) %"
        taskProgressSliderLab.text = "\(progress) % Completed"
    }
    
    @IBAction func cancelTaskBut(_ sender: UIBarButtonItem) {
        dismissAddTaskPopOver()
    }
    
    @IBAction func saveTaskBut(_ sender: UIBarButtonItem) {
        
        if validate() {
                   let taskName = taskNameLab.text
                   let dueDate = taskEndDatePicker.date
                   let startDate = taskStartDatePicker.date
                   let progress = Float(taskProgressSlider.value)
            
            print(taskEndDatePicker.date)
            
                   let addNotificationFlag = Bool(addToCelender.isOn)
                   
                   guard let appDelegate =
                       UIApplication.shared.delegate as? AppDelegate else {
                           return
                   }
                   
                   let managedContext = appDelegate.persistentContainer.viewContext
                   let entity = NSEntityDescription.entity(forEntityName: "Task", in: managedContext)!
                   
                   var task = NSManagedObject()
                   
                   if editingMode {
                       task = (editingTask as? Task)!
                   } else {
                       task = NSManagedObject(entity: entity, insertInto: managedContext)
                   }
                   
                   if addNotificationFlag {
                    setNotify.setNotify(task: task as! Task, dueDate: dueDate, taskName: taskName!)
                   }else{
                    print("remove notification")
                    }
                   
                   task.setValue(taskName, forKeyPath: "name")
                   task.setValue(taskNoteView.text, forKeyPath: "notes")
                   task.setValue(startDate, forKeyPath: "startDate")
                   task.setValue(dueDate, forKeyPath: "dueDate")
                   task.setValue(addNotificationFlag, forKeyPath: "addNotification")
                   task.setValue(progress, forKey: "progress")
                   
                   selectedAssessment?.addToTasks((task as? Task)!)
                   
                   do {
                       try managedContext.save()
                       tasks.append(task)
                   } catch _ as NSError {
                       let alert = UIAlertController(title: "Error", message: "An error occured while saving the task.", preferredStyle: UIAlertController.Style.alert)
                       alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                       self.present(alert, animated: true, completion: nil)
                   }
               } else {
                   let alert = UIAlertController(title: "Error", message: "Please fill the required fields.", preferredStyle: UIAlertController.Style.alert)
                   alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                   self.present(alert, animated: true, completion: nil)
               }
               
               // Dismiss PopOver
               dismissAddTaskPopOver()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        toggleAddButtonEnability()
    }
    
}

   // MARK: - UITableViewDelegate
extension TaskAddViewController{
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
//            .becomeFirstResponder()
        }
        
        if indexPath.section == 0 && indexPath.row == 1 {
//            notesTextView.becomeFirstResponder()
        }
        if(indexPath.section == 1 && indexPath.row == 1) {
            startDatePickerVisible = !startDatePickerVisible
            tableView.reloadData()
        }
        if(indexPath.section == 1 && indexPath.row == 3) {
            dueDatePickerVisible = !dueDatePickerVisible
            tableView.reloadData()
        }
        
        // Section 2 contains task progress
        if(indexPath.section == 2 && indexPath.row == 0) {
            taskProgressVisible = !taskProgressVisible
            tableView.reloadData()
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         // Make Notes text view bigger: 80
        if indexPath.section == 0 && indexPath.row == 1 {
            return 80.0
        }
        
        if indexPath.section == 1 && indexPath.row == 2 {
            if startDatePickerVisible == false {
                return 0.0
            }
            return 200.0
        }
        
        if indexPath.section == 1 && indexPath.row == 4 {
            if dueDatePickerVisible == false {
                return 0.0
            }
            return 200.0
        }

        if indexPath.section == 2 && indexPath.row == 1 {
            if taskProgressVisible == false {
                return 0.0
            }
            return 130.0
        }
        
        return 50.0
    }
    
}
