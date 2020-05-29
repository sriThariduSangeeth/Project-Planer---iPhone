//
//  UISplitView+MasterView.swift
//  Project Planer
//
//  Created by Dilan Tharidu Sangeeth on 5/30/20.
//  Copyright © 2020 Dilan Tharidu Sangeeth. All rights reserved.
//

import UIKit

extension UISplitViewController {
    func toggleMasterView() {
        let barButtonItem = self.displayModeButtonItem
        UIApplication.shared.sendAction(barButtonItem.action!, to: barButtonItem.target, from: nil, for: nil)
    }
}
