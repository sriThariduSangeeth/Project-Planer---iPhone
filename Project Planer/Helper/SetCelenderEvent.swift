//
//  SetCelenderEvent.swift
//  Project Planer
//
//  Created by Dilan Tharidu Sangeeth on 6/1/20.
//  Copyright © 2020 Dilan Tharidu Sangeeth. All rights reserved.
//

import Foundation
import EventKit
import UIKit

public class SetCelenderEvent: UIViewController {
    
    let eventStore = EKEventStore()
    var calendarIdentifier = ""
    var eventDeleted = false
    let now = Date();
    
       // MARK: - SET Event
    
    public func addEventToCalender(_ projectName: String , endDate: Date) -> String {
        if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
            eventStore.requestAccess(to: .event, completion: {
                granted, error in
                self.calendarIdentifier = self.createEvent(self.eventStore, title: projectName, startDate: self.now, endDate: endDate)
               
                })
        } else {
            self.calendarIdentifier = createEvent(self.eventStore, title: projectName, startDate: now, endDate: endDate)
        }
        
        return calendarIdentifier
    }
    
    // MARK: - DELETE Event

    public func deleteEventInCelender(assessment : Assessment) -> Bool{
        if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
            eventStore.requestAccess(to: .event, completion: { (granted, error) -> Void in
                self.eventDeleted = self.deleteEvent(self.eventStore, eventIdentifier: assessment.calendarIdentifier!)
            })
        } else {
            eventDeleted = deleteEvent(eventStore, eventIdentifier: assessment.calendarIdentifier!)
        }
        
        return eventDeleted
    }
    
    // Creates an event in the EKEventStore
    func createEvent(_ eventStore: EKEventStore, title: String, startDate: Date, endDate: Date) -> String {
        let event = EKEvent(eventStore: eventStore)
        var identifier = ""
        
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        do {
            try eventStore.save(event, span: .thisEvent)
            identifier = event.eventIdentifier
        } catch {
            let alert = UIAlertController(title: "Error", message: "Calendar event could not be created!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        return identifier
    }
    
    
    // Removes an event from the EKEventStore
    func deleteEvent(_ eventStore: EKEventStore, eventIdentifier: String) -> Bool {
        var sucess = false
        let eventToRemove = self.eventStore.event(withIdentifier: eventIdentifier)
        if eventToRemove != nil {
            do {
                try eventStore.remove(eventToRemove!, span: .thisEvent)
                sucess = true
            } catch {
                let alert = UIAlertController(title: "Error", message: "Calendar event could not be deleted!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                sucess = false
            }
        }
        return sucess
    }
}


