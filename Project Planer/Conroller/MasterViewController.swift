//
//  MasterViewController.swift
//  Project Planer
//
//  Created by Dilan Tharidu Sangeeth on 5/16/20.
//  Copyright © 2020 Dilan Tharidu Sangeeth. All rights reserved.
//

import UIKit
import CoreData
import EventKit

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet var assessmentTable: UITableView!
    @IBOutlet weak var hideMasterView: UIBarButtonItem!
    
    let setCelenderEvent: SetCelenderEvent = SetCelenderEvent()
    
    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let eventStore = EKEventStore()
    var eventDeleted = false
    
    let calculations: Calculations = Calculations()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        //When swap master view auto select first cell in table view first time
        autoSelectTableRow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    
    
    @IBAction func hideMaster(_ sender: UIBarButtonItem) {
        //Hide master view button click
        self.splitViewController?.toggleMasterView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let object = entityFetchedController.object(at: indexPath)
            self.performSegue(withIdentifier: "showAssessmentDetails", sender: object)
        }
    }
    
    
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // transfer data between segue when call segue using identifier this function will automatically trigger.
        
        if segue.identifier == "addAssessment" {
            if let controller = segue.destination as? UIViewController {
                controller.popoverPresentationController!.delegate = self
                controller.preferredContentSize = CGSize(width: 320, height: 450)
            }
        }
        
        if segue.identifier == "editAssessment" {
            let controller = (segue.destination as! UINavigationController).topViewController as! AssessmentAddViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = entityFetchedController.object(at: indexPath)
                controller.editingAssessment = object as Assessment
            }else{
                controller.editingAssessment = sender as! Assessment
            }
        }
        
        if segue.identifier == "showAssessmentDetails" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = entityFetchedController.object(at: indexPath)
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.selectedAssessment = object as Assessment
            }
        }
    }
    
  
    // MARK: - Fetched entity controller
    
    var entityFetchedController :  NSFetchedResultsController<Assessment>{
        
        if _entityFetchedController != nil {
            return _entityFetchedController!
        }
        self.managedObjectContext = context
        
        let fetchRequest: NSFetchRequest<Assessment> = Assessment.fetchRequest()
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "startDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Master")
        aFetchedResultsController.delegate = self
        _entityFetchedController = aFetchedResultsController
        
        do {
            try _entityFetchedController!.performFetch()
        } catch {
             let nserror = error as NSError
             fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        // update UI
        autoSelectTableRow()
        return _entityFetchedController!
    }
    
    var _entityFetchedController: NSFetchedResultsController<Assessment>? = nil
    
    
    // MARK: - below methods performance every individual changes in table view
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
            case .insert:
                tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
            case .delete:
                tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
            default:
                return
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .insert:
                tableView.insertRows(at: [newIndexPath!], with: .fade)
                // update UI
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.autoSelectTableRow()
                }
                autoCloseMasterView()
            case .delete:
                tableView.deleteRows(at: [indexPath!], with: .fade)
                eventDeleted = setCelenderEvent.deleteEventInCelender(assessment: (anObject as! Assessment))            
            case .update:
                AssessCellSetup(tableView.cellForRow(at: indexPath!)! as! AssessmentTableViewCell, withAssessment: anObject as! Assessment)
                editChangeDetailView(object: anObject)
            case .move:
                AssessCellSetup(tableView.cellForRow(at: indexPath!)! as! AssessmentTableViewCell, withAssessment: anObject as! Assessment)
                tableView.moveRow(at: indexPath!, to: newIndexPath!)
                // update UI
                autoSelectTableRow()
            default:
                return
        }
    }

    func autoCloseMasterView(){
        self.splitViewController?.toggleMasterView()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func editChangeDetailView(object: Any){
        self.performSegue(withIdentifier: "showAssessmentDetails", sender: object)
    }
    
    func autoSelectTableRow() {
        // this function will select first cell in table view and navigate to detail view
        let indexPath = IndexPath(row: 0, section: 0)
        if tableView.hasRowAtIndexPath(indexPath: indexPath as NSIndexPath) {
        
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
            
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = entityFetchedController.object(at: indexPath)
                self.performSegue(withIdentifier: "showAssessmentDetails", sender: object)
            }
        } else {
            let empty = {}
            self.performSegue(withIdentifier: "showAssessmentDetails", sender: empty)
        }
    }
    
    func showPopoverFrom(cell: AssessmentTableViewCell, forButton button: UIButton, forNotes notes: String) {
        
        // this function will open Assessment note view by clicking note view button
        let buttonFrame = button.frame
        var showRect = cell.convert(buttonFrame, to: assessmentTable)
        showRect = assessmentTable.convert(showRect, to: view)
        showRect.origin.y -= 5
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "NotesPopoverController") as? NotesPopoverController
        controller?.modalPresentationStyle = .popover
        controller?.preferredContentSize = CGSize(width: 300, height: 250)
        controller?.notes = notes
        
        if let popoverPresentationController = controller?.popoverPresentationController {
            popoverPresentationController.permittedArrowDirections = .up
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = showRect
            
            if let popoverController = controller {
                present(popoverController, animated: true, completion: nil)
            }
        }
    }

    
    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return entityFetchedController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        let sectionInfo = entityFetchedController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "aCell", for: indexPath) as! AssessmentTableViewCell
        
        let assessment = entityFetchedController.object(at: indexPath)
        AssessCellSetup(cell, withAssessment: assessment)
        cell.cellDelegate = self
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.darkGray
        cell.contentView.layer.cornerRadius = 10.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.00).cgColor
        cell.contentView.layer.masksToBounds = false
        cell.selectedBackgroundView = bgColorView
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
           // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = editActionCell(at : indexPath)
        let delete = deleteActionCell(at : indexPath)
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
    
    override func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        autoSelectTableRow()
    }
    
    func editActionCell(at indexPath: IndexPath) -> UIContextualAction{
        
        let action = UIContextualAction(style: .normal, title: "Edit"){
            (action,view, completion) in
            let object = self.entityFetchedController.object(at: indexPath)
            self.performSegue(withIdentifier: "editAssessment", sender: object)
        }
        action.backgroundColor = .lightGray
        action.image = UIImage.init(named: "Edit")
        return action
    }
    
    func deleteActionCell(at indexPath: IndexPath) -> UIContextualAction{
        let action = UIContextualAction(style: .destructive, title: "Delete"){
            (action,view, completion) in
            
            let context = self.entityFetchedController.managedObjectContext
            context.delete(self.entityFetchedController.object(at: indexPath))

            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        action.backgroundColor = .red
        action.image = UIImage.init(named: "Trash")
        return action
    }
    
    
    // MARK: - SET ASSESSMENT view CELLS
    
    func AssessCellSetup(_ cell: AssessmentTableViewCell, withAssessment assessment: Assessment) {
        let assessmentProgress = calculations.getProjectProgress(assessment.tasks!.allObjects as! [Task])
        cell.commonInit(assessment.name, taskProgress: CGFloat(assessmentProgress), marksVal: assessment.marks as Float, dueDate: assessment.dueDate as Date , notes: assessment.notes , value: assessment.value , addCalender: assessment.addToCalendar)
    }
}


extension MasterViewController: AssessmentTableViewCellDelegate {
    func customCell(cell: AssessmentTableViewCell, sender button: UIButton, data: String) {
        self.showPopoverFrom(cell: cell, forButton: button, forNotes: data)
    }
}
