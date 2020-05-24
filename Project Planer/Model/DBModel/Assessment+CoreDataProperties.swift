//
//  Assessment+CoreDataProperties.swift
//  Project Planer
//
//  Created by Dilan Tharidu Sangeeth on 5/17/20.
//  Copyright © 2020 Dilan Tharidu Sangeeth. All rights reserved.
//

import Foundation
import CoreData


extension Assessment {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Assessment> {
        return NSFetchRequest<Assessment>(entityName: "Assessment")
    }

    @NSManaged public var addToCalendar: Bool
    @NSManaged public var dueDate: NSDate
    @NSManaged public var name: String
    @NSManaged public var module: String
    @NSManaged public var notes: String
    @NSManaged public var value: Float
    @NSManaged public var marks: Float
    @NSManaged public var startDate: NSDate
    @NSManaged public var calendarIdentifier: String?
    @NSManaged public var tasks: NSSet?

}

// MARK: Generated accessors for tasks
extension Assessment {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: Task)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: Task)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)

}
