//
//  AssessmentAddViewController.swift
//  Project Planer
//
//  Created by Dilan Tharidu Sangeeth on 5/16/20.
//  Copyright © 2020 Dilan Tharidu Sangeeth. All rights reserved.
//
import Foundation
import UIKit
import CoreData
import EventKit

class AssessmentAddViewController: UITableViewController, UIPopoverPresentationControllerDelegate, UITextViewDelegate {
    
    var assessments: [NSManagedObject] = []
    var datePickerVisible = false
    var marksAchiveVisible = false
    var editingMode: Bool = false
    let now = Date();
    let setCelenderEvent: SetCelenderEvent = SetCelenderEvent()
    
    let formatter: Formatter = Formatter()
    
    @IBOutlet weak var assessmentName: UITextField!
    @IBOutlet weak var moduleName: UITextField!
    @IBOutlet weak var assessmentNote: UITextView!
    @IBOutlet weak var assessmentValue: UITextField!
    @IBOutlet weak var addToCalender: UISwitch!
    @IBOutlet weak var dueDateLab: UILabel!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var marksLab: UILabel!
    @IBOutlet weak var markprogress: UISlider!
    @IBOutlet weak var AddAssessmentBut: UIBarButtonItem!
    @IBOutlet weak var CancelAssessmentBut: UIBarButtonItem!

    
    
    
    var editingAssessment: Assessment? {
        didSet {
            // Update the view.
            editingMode = true
            configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dueDatePicker.minimumDate = now
        
        if !editingMode {
            // Set initial end date to one hour ahead of current time
            var time = Date()
            time.addTimeInterval(TimeInterval(60.00 * 60.00))
            dueDateLab.text = formatter.formatDate(time)
            
            // Settings the placeholder for notes UITextView
            assessmentNote.delegate = self
            assessmentNote.text = "Notes"
            assessmentNote.textColor = UIColor.darkGray
        }
        
        configureView()
        toggleAddButtonEnability()
    }
    
    
    
    func configureView() {
        
        if editingMode {
            self.navigationItem.title = "Edit Assessment"
            self.navigationItem.rightBarButtonItem?.title = "Edit"
        }
        
        if let assessment = editingAssessment{
            if let assessName = assessmentName {
                assessName.text = assessment.name
            }
            if let assessModule = moduleName{
                assessModule.text = assessment.module
            }
            if let assessNote = assessmentNote {
                assessNote.text = assessment.notes
            }
            if let assessValue = assessmentValue{
                assessValue.text = "\(Int(assessment.value))"
            }
            if let addToCalendarSwitch = addToCalender{
                addToCalendarSwitch.setOn((editingAssessment?.addToCalendar)!, animated: true)
            }
            if let marksLabText = marksLab{
                marksLabText.text = "\(NSString(format: "%.2f", assessment.marks) as String) %"
            }
            if let progressBar = markprogress{
                progressBar.value = assessment.marks
            }
            if let endDate = dueDateLab {
                endDate.text = formatter.formatDate(assessment.dueDate as Date)
            }
            if let endDatePicker = dueDatePicker {
                endDatePicker.date = assessment.dueDate as Date
            }
        }
    }
    
    // Handles the add button enable state
     func toggleAddButtonEnability() {
         if validate() {
             AddAssessmentBut.isEnabled = true;
         } else {
             AddAssessmentBut.isEnabled = false;
         }
     }
    
    // Check if the required fields are empty or not
    func validate() -> Bool {
        if !(assessmentName.text?.isEmpty)! && !(assessmentNote.text == "Notes") && !(assessmentNote.text?.isEmpty)! && !(moduleName.text?.isEmpty)! {
            return true
        }
        return false
    }
    
    @IBAction func handleAssessmentNameChange(_ sender: Any) {
        toggleAddButtonEnability()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        toggleAddButtonEnability()
    }
    
    func textViewDidChange(_ textView: UITextView) {
          toggleAddButtonEnability()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Notes"
            textView.textColor = UIColor.lightGray
        }
        toggleAddButtonEnability()
    }
    
    @IBAction func chnageMarkProgress(_ sender: UISlider) {
        let progress = Int(sender.value)
        marksLab.text = "\(progress) %"
    }
    
    @IBAction func handleDateChange(_ sender: UIDatePicker) {
        dueDateLab.text = formatter.formatDate(sender.date)
    }
    
    @IBAction func cancelAssessmentAction(_ sender: UIBarButtonItem) {
        dismissAddProjectPopOver()
    }
    
    @IBAction func assessmentValueChangeAction(_ sender: UITextField) {
    }
    
    @IBAction func saveAssessmentAction(_ sender: UIBarButtonItem) {
        addButClickEventHandle()
    }
    
    
    // Add Assessment when click add button
    func addButClickEventHandle(){
        if validate() {
            
            var calendarIdentifier = ""
            var addedToCalendar = false
            var eventDeleted = false
            let addToCalendarFlag = Bool(addToCalender.isOn)
            
            let assessmentNameText = assessmentName.text
            let moduleNameText = moduleName.text
            let endDate = dueDatePicker.date
            let notes = assessmentNote.text
            let value = (assessmentValue.text! as NSString).floatValue
            let marks = Float(markprogress.value)
            
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Assessment", in: managedContext)!
            var assessment = NSManagedObject()
            
            if editingMode {
                assessment = (editingAssessment)!
            } else {
                assessment = NSManagedObject(entity: entity, insertInto: managedContext)
            }
            
            if addToCalendarFlag {
                if editingMode {
                    if let assessment = editingAssessment {
                        if !assessment.addToCalendar {
                            calendarIdentifier = setCelenderEvent.addEventToCalender(assessmentNameText!, endDate: endDate)
                        }
                    }
                } else {
                    calendarIdentifier = setCelenderEvent.addEventToCalender(assessmentNameText!, endDate: endDate)
                }
                if calendarIdentifier != "" {
                    addedToCalendar = true
                }
                
            }else{
                if editingMode {
                    if let assessmentE = editingAssessment {
                        if assessmentE.addToCalendar {
                            eventDeleted = setCelenderEvent.deleteEventInCelender(assessment: assessmentE)
                        }
                    }
                }
            }
                
            // Handle event creation state
            if eventDeleted {
                addedToCalendar = false
            }
                
            assessment.setValue(assessmentNameText, forKeyPath: "name")
            assessment.setValue(moduleNameText, forKey: "module")
            assessment.setValue(notes, forKeyPath: "notes")
            assessment.setValue(value, forKey: "value")
            assessment.setValue(marks, forKey: "marks")
                
            if editingMode {
                assessment.setValue(editingAssessment?.startDate, forKeyPath: "startDate")
            } else {
                assessment.setValue(now, forKeyPath: "startDate")
            }
                
            assessment.setValue(endDate, forKeyPath: "dueDate")
            assessment.setValue(addedToCalendar, forKeyPath: "addToCalendar")
            assessment.setValue(calendarIdentifier, forKey: "calendarIdentifier")

            do {
                try managedContext.save()
                assessments.append(assessment)
            } catch _ as NSError {
                let alert = UIAlertController(title: "Error", message: "An error occured while saving the assessment.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            //validate else
            } else{
                let alert = UIAlertController(title: "Error", message: "Please fill the required fields.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        
        // Dismiss PopOver
        dismissAddProjectPopOver()
    }
    
    // Dismiss Popover
    func dismissAddProjectPopOver() {
        dismiss(animated: true, completion: nil)
        popoverPresentationController?.delegate?.popoverPresentationControllerDidDismissPopover?(popoverPresentationController!)
    }
    

}


    // MARK: - UITableViewDelegate
extension AssessmentAddViewController {

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            assessmentName.becomeFirstResponder()
        }
        if indexPath.section == 0 && indexPath.row == 1 {
            moduleName.becomeFirstResponder()
        }

        if indexPath.section == 0 && indexPath.row == 2 {
            assessmentNote.becomeFirstResponder()
        }

         //Section 1 contains end date(inddex: 0) and add to callender(inddex: 1) rows
        if(indexPath.section == 1 && indexPath.row == 1) {
            datePickerVisible = !datePickerVisible
            tableView.reloadData()
        }
        
        if(indexPath.section == 2 && indexPath.row == 0) {
            marksAchiveVisible = !marksAchiveVisible
            tableView.reloadData()
        }
        tableView.beginUpdates()
        tableView.endUpdates()

    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        // Make Notes text view bigger: 80
        if indexPath.section == 0 && indexPath.row == 2 {
            return 80.0
        }
        
        if indexPath.section == 1 && indexPath.row == 2 {
            if datePickerVisible == false {
                return 0.0
            }
            return 200.0
        }
        
        if indexPath.section == 2 && indexPath.row == 1 {
            if marksAchiveVisible == false{
                return 0.0
            }
            return 130.0
        }


        return 50.0
    }
}
