//
//  ViewController.swift
//  onTheMap
//
//  Created by Atul Bansal on 11/05/18.
//  Copyright © 2018 Atul Bansal. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController,UITextFieldDelegate{
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email.delegate = self
        password.delegate = self
        indicator.hidesWhenStopped = true
        indicator.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        email.text = ""
        password.text = ""
    }
    func showIndicator(show:Bool){
            DispatchQueue.main.async {
                if show{
                    self.indicator.startAnimating()
                }
                else {
                    self.indicator.stopAnimating()
                }
            }
    }
    func disableUI(bool:Bool){
        DispatchQueue.main.async {
            self.email.isEnabled = !bool
            self.loginBtn.isEnabled = !bool
            self.password.isEnabled = !bool
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    @IBAction func login(_ sender: Any) {
        if email.text == "" || email.text == " " || password.text == ""{
            alert(message: "Please enter ", completionHandler: {})
            return
        }
      self.disableUI(bool: true)
      showIndicator(show: true)
       Network.checkLogin(name: email.text!, password: password.text!, completionandler: {error,loginID in
        if error != nil{
            self.disableUI(bool: false)
            self.showIndicator(show: false)
            self.alert(message: error!, completionHandler: {})
           return
        }
        StudentInfo.StudentId = loginID!
        Network.getFirstLastName(loginId: loginID!, completionandler: {error in
            if error == nil {
                let view = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as! UITabBarController
                self.disableUI(bool: false)
                self.showIndicator(show: false)
                DispatchQueue.main.async {
                    self.present(view, animated: true, completion: nil) }
            }
            else {
            
                 self.disableUI(bool: false)
                self.showIndicator(show: false)
                self.alert(message: error!, completionHandler: {})
            }
        })
        
       })
    }
    
    func alert(message:String , completionHandler:@escaping()->())
    {
        DispatchQueue.main.async {
            
            
            let alertview = UIAlertController(title: "", message: message, preferredStyle: .alert)
            alertview.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: {
                action in
                completionHandler()
            }))
            self.present(alertview, animated: true, completion: nil)
        }
    }
    
}



