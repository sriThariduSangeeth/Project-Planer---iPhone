//
//  NotesPopoverController.swift
//  Project Planer
//
//  Created by Dilan Tharidu Sangeeth on 5/16/20.
//  Copyright © 2020 Dilan Tharidu Sangeeth. All rights reserved.
//

import Foundation
import UIKit

class NotesPopoverController: UIViewController {

    @IBOutlet weak var notesView: UITextView!
    var delegate : NoteViewControllerDelegate?
    
    @IBAction func dismissPopOver(_ sender: UIBarButtonItem) {
       
            delegate?.dismissPopover(strText: "dismiss")
            dismiss(animated: true, completion: nil)
        popoverPresentationController?.delegate?.popoverPresentationControllerDidDismissPopover?(popoverPresentationController!)
            
        
    }
    
    var notes: String? {
        didSet {
            configureView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    func configureView() {
        
        if let notes = notes {
            if let notesView = notesView {
                notesView.text = notes
            }
        }
    }
    
}

protocol NoteViewControllerDelegate{
    func dismissPopover( strText : String)
}
