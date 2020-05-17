//
//  Formatter.swift
//  Project Planer
//
//  Created by Dilan Tharidu Sangeeth on 5/17/20.
//  Copyright © 2020 Dilan Tharidu Sangeeth. All rights reserved.
//

import Foundation

public class Formatter {
    // Helper to format date
    public func formatDate(_ date: Date) -> String {
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm"
        return dateFormatter.string(from: date)
    }
}
