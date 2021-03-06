//
//  MyDashBoardContoller.swift
//  Project Planer
//
//  Created by Dilan Tharidu Sangeeth on 5/7/20.
//  Copyright © 2020 Dilan Tharidu Sangeeth. All rights reserved.
//

import UIKit

class MyDashBoardContoller : UIViewController ,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var defCount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var defects = [Defects]()
    var userName : String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userName = UserDefaults.standard.value(forKey: "userName") as! String
        getDefectsList()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getDefectsList()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        self.defCount.text = String(self.defects.count)
    }
    
    func getDefectsList1() {
           
        let s1 = Defects(repo: "TestAndroid", commit: "Create SetValue and set Arry", defect: "ArrayIndexOutOfBoundsException" , className :"test.java")
        let s2 = Defects(repo: "TestAndroid", commit: "create Application add simple operation", defect: "ArithmeticException" , className :"test.java")
        defects += [s1,s2]
        self.defCount.text = String(defects.count)
        
        self.tableView.reloadData()
    }
    
    func getDefectsList() {
        defects = []
        let cur = GitCMServices(UserName: self.userName! )
        if CheckInternetConnection.connection(){
            cur.getDefectsList{(result) in
                if let coun = result{
                   DispatchQueue.main.async {
                        self.defects = coun
                        self.defCount.text = String(self.defects.count)
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
    }
    
      // MARK: - Table View
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           if defects.count == 0 {
               self.tableView.triggerEmptyMessage("No Technical defects found !")
           } else {
               self.tableView.restore()
           }
                   
        return defects.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let Dcell = tableView.dequeueReusableCell(withIdentifier: "dCell", for: indexPath) as! DefectViewCell
       
        Dcell.repo.text = defects[indexPath.row].getRepoName()
        Dcell.commitM.text = defects[indexPath.row].getCommitMessage()
        Dcell.defect.text = defects[indexPath.row].getdefect()
        Dcell.className.text = defects[indexPath.row].getClassName()
        
     
    
       
       // Card(cell) styles
       Dcell.isUserInteractionEnabled = false
       Dcell.contentView.backgroundColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.00)
       Dcell.contentView.layer.cornerRadius = 10.0
       Dcell.contentView.layer.borderWidth = 1.0
       Dcell.contentView.layer.borderColor = UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.00).cgColor
       Dcell.contentView.layer.masksToBounds = false
       
       return Dcell
    }
    
    
}
