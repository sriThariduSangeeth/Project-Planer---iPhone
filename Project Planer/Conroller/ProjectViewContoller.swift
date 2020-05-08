//
//  ProjectViewContoller.swift
//  Project Planer
//
//  Created by Dilan Tharidu Sangeeth on 5/7/20.
//  Copyright © 2020 Dilan Tharidu Sangeeth. All rights reserved.
//

import UIKit

class ProjectViewContoller : UIViewController ,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var projects = [Repository]()
    var userName : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.userName = (UserDefaults.standard.value(forKey: "userName") as? String)!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        getProjectList()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    func getProjectList13() {
        
        let s1 = Repository(id: 1, name: "test repo 1", date: "2020/03/03")
        let s2 = Repository(id: 1, name: "test repo 2", date: "2020/03/04")
        let s3 = Repository(id: 1, name: "test repo 3", date: "2020/03/05")
        let s4 = Repository(id: 1, name: "test repo 4", date: "2020/03/06")
        
        projects += [s1,s2,s3,s4]
    }
    
    func getProjectList() {
        projects = []
        let cur = GitHubServices(UserName: "sriThariduSangeeth" )
        if CheckInternetConnection.connection(){
            cur.getReposList{(result) in
                if let coun = result{
                   DispatchQueue.main.async {
                        self.projects = coun
                        print(coun)
                        self.tableView.reloadData()
                    }
                }
            }

            print(self.projects.count)
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           if projects.count == 0 {
               self.tableView.triggerEmptyMessage("No Projects found !")
           } else {
               self.tableView.restore()
           }
                   
        return projects.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let Hcell = tableView.dequeueReusableCell(withIdentifier: "hCell", for: indexPath) as! ProjectViewCell
          
        Hcell.repoName.text = projects[indexPath.row].getRepoName()
        Hcell.repoDate.text = projects[indexPath.row].getRepoDate()
        Hcell.taskCount.text = "0"
          
          // Card(cell) styles
          Hcell.isUserInteractionEnabled = false
          Hcell.contentView.backgroundColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.00)
          Hcell.contentView.layer.cornerRadius = 10.0
          Hcell.contentView.layer.borderWidth = 1.0
          Hcell.contentView.layer.borderColor = UIColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 1.00).cgColor
          Hcell.contentView.layer.masksToBounds = false
          
          return Hcell
       }
    
    
}
