//
//  BaseViewController.swift
//  onTheMap
//
//  Created by Atul Bansal on 13/05/18.
//  Copyright © 2018 Atul Bansal. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    func addPin(){
        if(StudentInfo.objID != ""){
        self.alert( completionHandler: { bool in
            let view = self.storyboard?.instantiateViewController(withIdentifier: "addpin") as! AddNewPinViewController
               view.post = bool
          self.present(view, animated: true, completion: nil)
        })
        }
        else {
            let view = self.storyboard?.instantiateViewController(withIdentifier: "addpin") as! AddNewPinViewController
            self.present(view, animated: true, completion: nil)
        }
    }
    func alert(completionHandler: @escaping(_ post:Bool)-> ())
    {
        DispatchQueue.main.async
            {
                let alert = UIAlertController(title: "Please Select", message:"", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "add new pin", style: .default, handler: {
                    action in
                    completionHandler(true)
                }))
                
                alert.addAction(UIAlertAction(title: "Rewrite Pin", style: .default, handler: {
                    action in
                    completionHandler(false)

                }))
                self.present(alert, animated: true, completion: nil)
        }
    }
    func reload(Completion:@escaping(_ err:String?)->()){
        Network.GetStudentData { (error) in
            Completion(error)
        }
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
    func logoutOut(completionandler:@escaping (_ error:String?)->())  {
        DispatchQueue.main.async {
            UIApplication.shared.beginIgnoringInteractionEvents() }
        Network.loagoutCalled(completionandler: { (err) in
            DispatchQueue.main.async {
                UIApplication.shared.endIgnoringInteractionEvents()
            }

            completionandler(err)
       })
    }
}
