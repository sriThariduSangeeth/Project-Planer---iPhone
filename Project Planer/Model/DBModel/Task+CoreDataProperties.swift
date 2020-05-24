//
//  Task+CoreDataProperties.swift
//  Project Planer
//
//  Created by Dilan Tharidu Sangeeth on 5/19/20.
//  Copyright © 2020 Dilan Tharidu Sangeeth. All rights reserved.
//

import Foundation
import CoreData


extension Task{
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }
    
    @NSManaged public var addNotification: Bool
    @NSManaged public var dueDate: NSDate
    @NSManaged public var name: String
    @NSManaged public var notes: String
    @NSManaged public var startDate: NSDate
    @NSManaged public var progress: Float
    @NSManaged public var assessment: Assessment
    
}
