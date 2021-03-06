//
//  DetailViewController.swift
//  Project Planer
//
//  Created by Dilan Tharidu Sangeeth on 5/15/20.
//  Copyright © 2020 Dilan Tharidu Sangeeth. All rights reserved.
//

import UIKit
import CoreData
import EventKit

class DetailViewController: UIViewController, NSFetchedResultsControllerDelegate,  UIPopoverPresentationControllerDelegate , UITableViewDelegate, UITableViewDataSource, NoteViewControllerDelegate {
    
    
   
    
    @IBOutlet weak var taskTable: UITableView!
    @IBOutlet weak var assessmentProgressBar: CircularProgressBar!
    @IBOutlet weak var dayProgressBar: CircularProgressBar!
    @IBOutlet weak var assessmentNameLab: UILabel!
    @IBOutlet weak var dueDateLab: UILabel!
    @IBOutlet weak var priorityLab: UILabel!
    @IBOutlet weak var assessmentDetailView: UIView!
    @IBOutlet weak var addTaskBut: UIBarButtonItem!
    @IBOutlet weak var editTaskBut: UIBarButtonItem!
    @IBOutlet weak var deleteTaskBut: UIBarButtonItem!
    @IBOutlet weak var ModuleNameLab: UILabel!
    
    @IBOutlet weak var taskTavleView: UIView!
    
    
    @IBOutlet var blurView: UIVisualEffectView!
    
    
    let formatter: Formatter = Formatter()
    let calculations: Calculations = Calculations()
    let colours: Colours = Colours()
    let now = Date()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    
    var selectedAssessment: Assessment? {
        didSet {
//            // Update the view.
            setUpDetailView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure the view
        blurView.bounds = self.view.bounds
        
        if selectedAssessment == nil {
            assessmentDetailView.isHidden = true
            assessmentProgressBar.isHidden = true
            dayProgressBar.isHidden = true
            addTaskBut.isEnabled = false
            editTaskBut.isEnabled = false
            deleteTaskBut.isEnabled = false
            taskTable.rowHeight = 0
            taskTable.triggerEmptyMessage("Add a new Assessment to manage Tasks")
     
        }
        setUpDetailView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Set the default selected row
        let indexPath = IndexPath(row: 0, section: 0)
        if taskTable.hasRowAtIndexPath(indexPath: indexPath as NSIndexPath) {
            taskTable.selectRow(at: indexPath, animated: true, scrollPosition: .bottom)
        }
    }
    

    func setUpDetailView(){
        // Update the user interface for the detail item.
        if let assessment = selectedAssessment {
            if let nameLabel = assessmentNameLab {
                nameLabel.text = assessment.name
            }
            if let moduleN = ModuleNameLab{
                moduleN.text = assessment.module
            }
            if let dueDateLabel = dueDateLab {
                dueDateLabel.text = "Due Date: \(formatter.formatDate(assessment.dueDate as Date))"
            }
            if let marksLabel = priorityLab {
                marksLabel.text = "Marks : \(assessment.marks) %"
            }
            
            let tasks = (assessment.tasks!.allObjects as! [Task])
            let assessmentProgress = calculations.getProjectProgress(tasks)
            let daysLeftProgress = 100 - calculations.getRemainingTimePercentage(assessment.startDate as Date, end: assessment.dueDate as Date)
            var daysRemaining = self.calculations.getDateDiff(self.now, end: assessment.dueDate as Date)
            
            if daysRemaining < 0 {
                daysRemaining = 0
            }
            
            DispatchQueue.main.async {
                let colours = self.colours.getProgressGradient(assessmentProgress)
                self.assessmentProgressBar?.customSubtitle = "Completed"
                self.assessmentProgressBar?.startGradientColor = colours[0]
                self.assessmentProgressBar?.endGradientColor = colours[1]
                self.assessmentProgressBar?.progress = CGFloat(assessmentProgress) / 100
            }
            
            DispatchQueue.main.async {
                let colours = self.colours.getProgressGradient(daysLeftProgress , negative: false)
                self.dayProgressBar?.customTitle = "\(daysRemaining)"
                self.dayProgressBar?.customSubtitle = "Days Left"
                self.dayProgressBar?.startGradientColor = colours[0]
                self.dayProgressBar?.endGradientColor = colours[1]
                self.dayProgressBar?.progress =  CGFloat(daysLeftProgress) / 100
                
            }
        }
    }
    
   

    // MARK: - Segues
    
    @IBAction func AddTaskBut(_ sender: UIBarButtonItem) {
        //open add Task segue
         self.performSegue(withIdentifier: "addTask", sender: self)
     }
     
     @IBAction func EditTaskBut(_ sender: UIBarButtonItem) {
        //open edit Task segue
        self.performSegue(withIdentifier: "editTask", sender: self)
     }
    
    @IBAction func deleteAction(_ sender: UIBarButtonItem) {
        // configure delete part
        self.taskTable.isEditing = !self.taskTable.isEditing
        if (self.taskTable.isEditing){
            sender.title = "Done"
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // transfer data between segue when call segue using identifier this function will automatically trigger.
        
        if segue.identifier == "addTask" {
            let controller = (segue.destination as! UINavigationController).topViewController as! TaskAddViewController
            controller.selectedAssessment = selectedAssessment
            if let controller = segue.destination as? UIViewController {
                controller.popoverPresentationController?.delegate = self
                controller.preferredContentSize = CGSize(width: 320, height: 500)
            }
        }

        if segue.identifier == "showProjectNotes" {
            let controller = segue.destination as! NotesPopoverController
            controller.notes = selectedAssessment!.notes
            if let controller = segue.destination as? UIViewController {
                controller.popoverPresentationController!.delegate = self
                controller.preferredContentSize = CGSize(width: 300, height: 250)
            }
        }

        if segue.identifier == "editTask" {
            if let indexPath = taskTable.indexPathForSelectedRow {
                let object = fetchedResultsController.object(at: indexPath)
                let controller = (segue.destination as! UINavigationController).topViewController as! TaskAddViewController
                controller.editingTask = object as Task
                controller.selectedAssessment = selectedAssessment
            }
        }
    }
    

    
    func dismissPopover(strText: String) {
        animateOut(pointView: self.blurView)
    }
    
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController<Task> {
           if _fetchedResultsController != nil {
               return _fetchedResultsController!
           }
            
            self.managedObjectContext = context
           
           let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
           
           // Set the batch size to a suitable number.
           fetchRequest.fetchBatchSize = 20
           
           if selectedAssessment != nil {
            // Setting a predicate
            let predicate = NSPredicate(format: "%K == %@", "assessment", selectedAssessment!)
               fetchRequest.predicate = predicate
           }

           // Edit the sort key as appropriate.
           let sortDescriptor = NSSortDescriptor(key: "startDate", ascending: false)
           fetchRequest.sortDescriptors = [sortDescriptor]

            // Edit the section name key path and cache name if appropriate.
            // nil for section name key path means "no sections".
           let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "\(UUID().uuidString)-project")
           aFetchedResultsController.delegate = self
           _fetchedResultsController = aFetchedResultsController
           
           do {
               try _fetchedResultsController!.performFetch()
           } catch {
               let nserror = error as NSError
               fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
           }
           
           return _fetchedResultsController!
       }
    
    var _fetchedResultsController: NSFetchedResultsController<Task>? = nil
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        taskTable.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            taskTable.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            taskTable.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            taskTable.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            taskTable.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            configureCell(taskTable.cellForRow(at: indexPath!)! as! TaskTableViewCell, withTask: anObject as! Task, index: indexPath!.row)
        case .move:
            configureCell(taskTable.cellForRow(at: indexPath!)! as! TaskTableViewCell, withTask: anObject as! Task, index: indexPath!.row)
            taskTable.moveRow(at: indexPath!, to: newIndexPath!)
        default:
            return
        
        }
        setUpDetailView()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        taskTable.endUpdates()
    }

    
    func configureCell(_ cell: TaskTableViewCell, withTask task: Task, index: Int) {
        //print("Related Project", task.project)
        cell.commonInit(task.name, taskProgress: CGFloat(task.progress), startDate: task.startDate as Date, dueDate: task.dueDate as Date, notes: task.notes, taskNo: index + 1)
    }
    
    // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        
        if sectionInfo.numberOfObjects == 0 {
            editTaskBut.isEnabled = false
            deleteTaskBut.isEnabled = false
            taskTable.triggerEmptyMessage("No tasks available for this Assessment")
        }
        
        return sectionInfo.numberOfObjects
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = taskTable.dequeueReusableCell(withIdentifier: "tCell", for: indexPath) as! TaskTableViewCell
        let task = fetchedResultsController.object(at: indexPath)
        configureCell(cell, withTask: task, index: indexPath.row)
        cell.cellDelegate = self
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.darkGray
        cell.contentView.backgroundColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.00)
        cell.contentView.layer.cornerRadius = 10.0
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.00).cgColor
        cell.contentView.layer.masksToBounds = false
        cell.selectedBackgroundView = bgColorView
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = fetchedResultsController.managedObjectContext
            context.delete(fetchedResultsController.object(at: indexPath))
            
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Show note Segues
    
    func showPopoverFrom(cell: TaskTableViewCell, forButton button: UIButton, forNotes notes: String) {
        let buttonFrame = button.frame
        var showRect = cell.convert(buttonFrame, to: taskTable)
        showRect = taskTable.convert(showRect, to: view)
        showRect.origin.y -= 5
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "NotesPopoverController") as? NotesPopoverController
        controller?.delegate = self
        controller?.modalPresentationStyle = .popover
        controller?.preferredContentSize = CGSize(width: 300, height: 250)
        controller?.notes = notes
        
        if let popoverPresentationController = controller?.popoverPresentationController {
            popoverPresentationController.permittedArrowDirections = .up
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = showRect
            
            if let popoverController = controller {
                animateIn(pointView: self.blurView)
                present(popoverController, animated: true, completion: nil)
            }
        }
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
    
    func animateIn(pointView: UIView){
           
        let masterView = self.view!
        let backgroundView = self.taskTavleView!
        backgroundView.addSubview(pointView)
           
        pointView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        pointView.alpha = 0
        pointView.center = masterView.center
           
        UIView.animate(withDuration: 0.3, animations: {
            pointView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            pointView.alpha = 1
        })
           
    }
       
       func animateOut(pointView: UIView){
           UIView.animate(withDuration: 0.3, animations: {
               pointView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
               pointView.alpha = 0
           }, completion: { _ in
               pointView.removeFromSuperview()
           })
       }
       
}

extension DetailViewController: TaskTableViewCellDelegate {
    func viewNotes(cell: TaskTableViewCell, sender button: UIButton,  data: String) {
        self.showPopoverFrom(cell: cell, forButton: button, forNotes: data)
    }
}
