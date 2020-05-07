//
//  HideKeyBoard.swift
//  Project Planer
//
//  Created by Dilan Tharidu Sangeeth on 5/7/20.
//  Copyright © 2020 Dilan Tharidu Sangeeth. All rights reserved.
//

import UIKit

private var outerConstraint : NSLayoutConstraint? = nil
private var outerStackView : UIStackView? = nil
private var scrollView : UIScrollView? = nil

extension UIViewController{
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showKeyboardWhenTapTextField(ScrollView: UIScrollView){
         
         scrollView = ScrollView
         
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)),
                                                        name: UIResponder.keyboardWillShowNotification, object: nil)
     }
    
    @objc func keyboardWillShow(notification: Notification){
        
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let keyboardEndFrame = view.convert(keyboardScreenEndFrame, to: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification{
            scrollView?.contentInset = UIEdgeInsets.zero
        }else{
            scrollView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardEndFrame.height, right: 0)
        }
        
        scrollView?.scrollIndicatorInsets = scrollView!.contentInset
    }
}

