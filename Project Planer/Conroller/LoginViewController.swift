//
//  LoginViewController.swift
//  Project Planer
//
//  Created by Dilan Tharidu Sangeeth on 5/7/20.
//  Copyright © 2020 Dilan Tharidu Sangeeth. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController{
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var userName: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var logInBut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.password.isSecureTextEntry = true;
        self.hideKeyboardWhenTappedAround()
        
    
        self.showKeyboardWhenTapTextField(ScrollView: scrollView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserDefaults.standard.removeObject(forKey: "userName")
        UserDefaults.standard.removeObject(forKey: "pass")
    }
    
    
    @IBAction func loginAction(_ sender: Any) {
        if(userName.text == "sriThariduSangeeth"){
            navigateInsideToDashboard()
        }else{
            let alert = UIAlertController(title: "Invalid", message: "Invalid User name and Password", preferredStyle: UIAlertController.Style.alert)
                      alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func navigateInsideToDashboard (){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "mainStory") as? TabViewController else {
            print("Could not find view controller")
            return
        }
        
        UserDefaults.standard.set(userName.text, forKey: "userName")
        UserDefaults.standard.set(password.text, forKey: "pass")
       
        self.present(vc, animated: true, completion: nil)
    }
    
}
