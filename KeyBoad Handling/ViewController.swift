//
//  ViewController.swift
//  KeyBoad Handling
//
//  Created by Admin on 1/11/19.
//  Copyright © 2019 Admin. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var textFieldA: UITextField!
    @IBOutlet weak var textFieldB: UITextField!
    @IBOutlet weak var textFieldC: UITextField!
    @IBOutlet weak var constraintContentHeight: NSLayoutConstraint!
    
    var activeField: UITextField?
    var lastOffset: CGPoint!
    var keyboardHeight: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        activeField = textField
        lastOffset = self.scrollView.contentOffset
        print(lastOffset.x)
        print(lastOffset.y)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        activeField?.resignFirstResponder()
        activeField = nil
        return true
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if keyboardHeight != nil {
            return
        }
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            print(constraintContentHeight)
            UIView.animate(withDuration: 0.3) {
                self.constraintContentHeight.constant += self.keyboardHeight!
            }
            let distanceToBottom = self.scrollView.frame.size.height - (activeField?.frame.origin.y)! - (activeField?.frame.size.height)!
            print(constraintContentHeight)
            print(scrollView.frame.size.height)
            print(activeField?.frame.origin.y)
            print(activeField?.frame.size.height)
            print(distanceToBottom)
            let collapseSpace = keyboardHeight! - distanceToBottom
            print(keyboardHeight)
            print(collapseSpace)
            print(scrollView.contentOffset.x)
            print(scrollView.contentOffset.y)
            if collapseSpace < 0 {
                return
            }
            UIView.animate(withDuration: 0.3) {
                self.scrollView.contentOffset = CGPoint(x: self.lastOffset.x, y: collapseSpace + 10)
            }
        }
        
    }
   
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.constraintContentHeight.constant -= self.keyboardHeight!
            self.scrollView.contentOffset = self.lastOffset
        }
        keyboardHeight = nil
    }
}
