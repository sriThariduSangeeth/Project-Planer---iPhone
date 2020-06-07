//
//  UserProfileViewController.swift
//  Project Planer
//
//  Created by Dilan Tharidu Sangeeth on 6/3/20.
//  Copyright © 2020 Dilan Tharidu Sangeeth. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var proUserName: UILabel!
    @IBOutlet weak var userNameSec: UIStackView!
    @IBOutlet weak var proEmail: UILabel!
    @IBOutlet weak var emilSec: UIStackView!
    @IBOutlet weak var proCompany: UILabel!
    @IBOutlet weak var companySec: UIStackView!
    
    var profileObj: GitProfile? = nil
    
    var url : String = "https://avatars1.githubusercontent.com/u/34954950?v=4"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getProfileDetails()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        
    }
    
    func getProfileDetails(){
        let cur = GitHubServices(UserName: "sriThariduSangeeth" )
            if CheckInternetConnection.connection(){
                cur.getProfileDetails{(result) in
                if let coun = result{
                    self.profileObj = coun[0]
                    self.fetchImage(from: self.profileObj!.profileAvatar) { (imageData) in
                        if let data = imageData {
                            // referenced imageView from main thread
                            // as iOS SDK warns not to use images from
                            // a background thread
                            DispatchQueue.main.async {
                                self.profileImage.image = UIImage(data: data)
                                self.setValueInLab()                           }
                        } else {
                            // show as an alert if you want to
                            print("Error loading image");
                        }
                    }
                }
            }

        //            print(self.projects.count)
        }
    }
    
    func setValueInLab(){
        
        if(profileObj?.profileName != "non"){
            proUserName.text = profileObj?.profileName
        }
        
        if(profileObj?.profileuserName != "non"){
            proUserName.text = profileObj?.profileuserName
        }else{
            userNameSec.isHidden = true
        }
        if(profileObj?.profileCompany != "non"){
            proCompany.text = profileObj?.profileCompany
        }else{
            companySec.isHidden = true
        }
        
        if(profileObj?.profileEmail != "non" ){
            proEmail.text = profileObj?.profileEmail
        }else{
            emilSec.isHidden = true
        }

    }

    func fetchImage(from urlString: String, completionHandler: @escaping (_ data: Data?) -> ()) {
        let session = URLSession.shared
        let url = URL(string: urlString)
            
        let dataTask = session.dataTask(with: url!) { (data, response, error) in
            if error != nil {
                print("Error fetching the image! 😢")
                completionHandler(nil)
            } else {
                completionHandler(data)
            }
        }
            
        dataTask.resume()
    }

}
