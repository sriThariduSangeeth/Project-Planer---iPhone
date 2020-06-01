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
                    
//                       notificationCenter.getNotificationSettings { (notificationSettings) in
//                           switch notificationSettings.authorizationStatus {
//                           case .notDetermined:
//                               self.requestAuthorization(completionHandler: { (success) in
//                                   guard success else { return }
//                                   print("Scheduling Notifications")
//                                   // Schedule Local Notification
//                                   self.scheduleLocalNotification("Task Deadline Missed!", subtitle: "Task: \(taskName!)", body: "You missed the deadline for the task '\(taskName!)' which was due on \(self.formatter.formatDate(dueDate)).", date: dueDate)
//                                   print("Scheduled Notifications")
//                               })
//                           case .authorized:
//
//                               // Schedule Local Notification
//                               self.scheduleLocalNotification("Task Deadline Missed!", subtitle: "Task: \(taskName!)", body: "You missed the deadline for the task '\(taskName!)' which was due on \(self.formatter.formatDate(dueDate)).", date: dueDate)
//                               print("Scheduled Notifications")
//                           case .denied:
//                               print("Application Not Allowed to Display Notifications")
//                           case .provisional:
//                               print("Application Not Allowed to Display Notifications")
//                           }
//                       }
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
    
//    func scheduleLocalNotification(_ title: String, subtitle: String, body: String, date: Date) {
//        // Create Notification Content
//        let notificationContent = UNMutableNotificationContent()
//        let identifier = "\(UUID().uuidString)"
//
//        // Configure Notification Content
//        notificationContent.title = title
//        notificationContent.subtitle = subtitle
//        notificationContent.body = body
//
//        // Add Trigger
//        // let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 20.0, repeats: false)
//        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
//        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
//
//        // Create Notification Request
//        let notificationRequest = UNNotificationRequest(identifier: identifier, content: notificationContent, trigger: trigger)
//
//        // Add Request to User Notification Center
//        notificationCenter.add(notificationRequest) { (error) in
//            if let error = error {
//                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
//            }
//        }
//    }
//
//    func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
//        // Request Authorization
//        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
//            if let error = error {
//                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
//            }
//            completionHandler(success)
//        }
//    }
    
    
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
        
        // Section 1 contains start date(index: 0), end date(index: 1) and add to callender(inddex: 1) rows
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
