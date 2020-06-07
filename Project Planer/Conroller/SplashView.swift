//
//  SplashView.swift
//  Project Planer
//
//  Created by Dilan Tharidu Sangeeth on 5/7/20.
//  Copyright © 2020 Dilan Tharidu Sangeeth. All rights reserved.
//

import UIKit

class SplashView: UIViewController{
    
    let logoImage = UIImageView(image: UIImage(named: "AppLogo")!)
    let splashView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        splashView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1.0)
        view.addSubview(splashView)
        splashView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)

        logoImage.contentMode = .scaleAspectFit
        splashView.addSubview(logoImage)
        
        logoImage.frame = CGRect(x: splashView.frame.midX - 50, y: splashView.frame.midY - 50, width: 100, height: 100)

    }

    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.default
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.scaleDownAnimation()
        }
    
    }
    
    func scaleDownAnimation()
    {
        UIView.animate(withDuration: 0.5 , animations:  {
            self.logoImage.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        })
        {(success) in
            self.scaleUpAnimation()
        }
    }
    
    func scaleUpAnimation() {
        UIView.animate(withDuration: 0.35, delay: 0.1 , options: .curveEaseIn, animations:  {
            self.logoImage.transform = CGAffineTransform(scaleX: 5, y:  5)
        })
        {(success) in
            self.removeSplashScreen()
        }
    }
    
        
    // MARK: - MOVE To LoginViewController
    
    func removeSplashScreen() {
        splashView.removeFromSuperview()
//        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Login", bundle: Bundle.main)
            guard let vc = storyboard.instantiateViewController(withIdentifier: "loginStory") as? LoginViewController else {
                print("Could not find view controller")
                return
            }
            self.present(vc, animated: true, completion: nil)
        }
    }
}
