//
//  SetNotificationCelender.swift
//  Project Planer
//
//  Created by Dilan Tharidu Sangeeth on 6/1/20.
//  Copyright © 2020 Dilan Tharidu Sangeeth. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

public class SetNotificationCelender: UIViewController, UNUserNotificationCenterDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()
    let formatter: Formatter = Formatter()
    
    public func setNotify(task: Task , dueDate : Date , taskName:String){
        notificationCenter.getNotificationSettings { (notificationSettings) in
        switch notificationSettings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization(compltion: { (success) in
                guard success else { return }
                print("Scheduling Notifications")
                // Schedule Local Notification
                self.scheduleLocalNotification("Task Deadline Missed!", subtitle: "Task: \(taskName)", body: "You missed the deadline for the task '\(taskName)' which was due on \(self.formatter.formatDate(dueDate)).", date: dueDate)
                print("Scheduled Notifications")
                    })
            case .authorized:
                // Schedule Local Notification
                self.scheduleLocalNotification("Task Deadline Missed!", subtitle: "Task: \(taskName)", body: "You missed the deadline for the task '\(taskName)' which was due on \(self.formatter.formatDate(dueDate)).", date: dueDate)
                print("Scheduled Notifications")
            case .denied:
                print("Application Not Allowed to Display Notifications")
            case .provisional:
                print("Application Not Allowed to Display Notifications")
            default:
                return
            }
        }
    }
    
    func scheduleLocalNotification(_ title: String, subtitle: String, body: String, date: Date) {
        // Create Notification Content
        let notificationContent = UNMutableNotificationContent()
      
        // Configure Notification Content
        notificationContent.title = title
        notificationContent.subtitle = subtitle
        notificationContent.body = body
        notificationContent.categoryIdentifier = "alarm"
        notificationContent.sound = .default
        
        // Add Trigger
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)
        
        // Add Request to User Notification Center
        notificationCenter.add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }
    
    func requestAuthorization(compltion: @escaping (_ success: Bool) -> ()) {
        // Request Authorization
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }
            compltion(success)
        }
    }
}
