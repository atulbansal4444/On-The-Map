//
//  StudentTableViewController.swift
//  onTheMap
//
//  Created by Atul Bansal on 12/05/18.
//  Copyright © 2018 Atul Bansal. All rights reserved.
//

import UIKit

class StudentTableViewController: BaseViewController,UITableViewDelegate  ,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentInfo.arrayOfStudents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! StudentTableViewCell
        cell.name.text = StudentInfo.arrayOfStudents[indexPath.row].name
        cell.url.text = StudentInfo.arrayOfStudents[indexPath.row].url
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = StudentInfo.arrayOfStudents[indexPath.row].url
        if UIApplication.shared.canOpenURL(URL(string: url)!) {
            UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: { (success) in
                print("Open url : \(success)")
            })
        }
        else {
            alert(message: "can not open url ", completionHandler: {})
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        table.reloadData()
    }
    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
}
    @IBAction func refrestCall(_ sender: Any) {
        super.reload { (error) in
            if(error==nil){
                DispatchQueue.main.async {
                    self.table.reloadData()
                }
            }
            else {
                super.alert(message: error!, completionHandler: {})
            }
        }
    
    }
    @IBAction func logoutCall(_ sender: Any) {
        super.logoutOut(completionandler: {err in
            if err != nil{
                self.alert(message: err!, completionHandler: {})
                return
            }
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil) }
        })
    }
    @IBAction func addCall(_ sender: Any) {
//self.dismiss(animated: true, completion: nil)
     super.addPin()
    }
    
}
extension StudentTableViewController{
    
}
