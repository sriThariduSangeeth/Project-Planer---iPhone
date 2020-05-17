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
    
    var assessment: [NSManagedObject] = []
    var datePickerVisible = false
    var editingMode: Bool = false
    let now = Date();
    
    let formatter: Formatter = Formatter()
    
    @IBOutlet weak var assessmentName: UITextField!
    @IBOutlet weak var moduleName: UITextField!
    @IBOutlet weak var assessmentNote: UITextView!
    @IBOutlet weak var addToCalender: UISwitch!
    @IBOutlet weak var dueDateLab: UILabel!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var marksLab: UILabel!
    @IBOutlet weak var markprogress: UISlider!
    
    var editingProject: Assessment? {
        didSet {
            // Update the view.
            editingMode = true
            configureView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configureView() {
        
    }
    
    @IBAction func handleAssessmentNameChange(_ sender: Any) {
    }
    
    @IBOutlet weak var handleProgressChange: UISlider!
    
    
    @IBAction func handleDateChange(_ sender: UIDatePicker) {
    }
    
    @IBAction func cancelAssessmentAction(_ sender: UIBarButtonItem) {
    }
    
    
    @IBAction func saveAssessmentAction(_ sender: UIBarButtonItem) {
    }
    
    // Dismiss Popover
    func dismissAddProjectPopOver() {
        dismiss(animated: true, completion: nil)
        popoverPresentationController?.delegate?.popoverPresentationControllerDidDismissPopover?(popoverPresentationController!)
    }
    
    
}
