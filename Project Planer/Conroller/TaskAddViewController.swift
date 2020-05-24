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
    
    var dueDatePickerVisible = false
    var startDatePickerVisible = false
    var taskProgressVisible = false
    
    
    // Dismiss Popover
    func dismissAddProjectPopOver() {
        dismiss(animated: true, completion: nil)
    popoverPresentationController?.delegate?.popoverPresentationControllerDidDismissPopover?(popoverPresentationController!)
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
