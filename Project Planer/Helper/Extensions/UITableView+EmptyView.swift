//
//  UITableView+EmptyView.swift
//  Project Planer
//
//  Created by Dilan Tharidu Sangeeth on 5/8/20.
//  Copyright © 2020 Dilan Tharidu Sangeeth. All rights reserved.
//

import UIKit

extension UITableView {
    
    func hasRowAtIndexPath(indexPath: NSIndexPath) -> Bool {
           return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
       }
    
    func triggerEmptyMessage( _ message: String) {
         let messageBacground = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
         messageBacground.text = message
         messageBacground.textColor = UIColor.white
         messageBacground.numberOfLines = 0;
         messageBacground.textAlignment = .center;
         messageBacground.font = UIFont(name: "System", size: 15)
         messageBacground.sizeToFit()
         
         self.backgroundView = messageBacground;
     }
    
    func restore() {
        self.backgroundView = nil
    }
}
