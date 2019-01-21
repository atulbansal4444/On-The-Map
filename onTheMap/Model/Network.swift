//
//  File.swift
//  onTheMap
//
//  Created by Atul Bansal on 12/05/18.
//  Copyright © 2018 Atul Bansal. All rights reserved.
//

import Foundation
import UIKit
import MapKit
class Network{
    
    static func GetStudentData(completionandler:@escaping (_ error:String?)->()){
        let url = URL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100&order=-updatedAt")!
        let rqst = NSMutableURLRequest(url: url)
        rqst.addValue(Constant.AppConstant.appID_Key_Value, forHTTPHeaderField: Constant.AppConstant.appID_Key)
        rqst.addValue(Constant.AppConstant.Parse_API_Value, forHTTPHeaderField: Constant.AppConstant.Parse_API_Key)
        URLSession.shared.dataTask(with: rqst as URLRequest, completionHandler: { (data, response, error) in
            if error != nil {
                completionandler(error?.localizedDescription)
                return
            }
            do{
             let data2 = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
             let arrayOfResult = data2["results"] as! [[String:Any]]
            StudentInfo.arrayOfStudents=[Student]()
            for result in arrayOfResult{
                StudentInfo.arrayOfStudents.append(Student(dict: result))
            }
                completionandler(nil)
                print(data2)
            }
            catch{
                completionandler("error")
                print("eroor")
            }
            }).resume()
        
    }
    
    static func checkLogin(name:String,password:String,completionandler:@escaping (_ error:String?,_ loginKey:String?)->()){
        let rqst = NSMutableURLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        rqst.httpBody = "{\"udacity\": {\"username\": \"\(name)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        rqst.addValue("application/json", forHTTPHeaderField: "Content-Type")
        rqst.addValue("application/json", forHTTPHeaderField: "Accept")
        rqst.httpMethod = "POST"
        URLSession.shared.dataTask(with: rqst as URLRequest, completionHandler: { (data, response, error) in
            if error != nil {
                completionandler(error?.localizedDescription,nil)
                return
            }
            let data2 = data?.subdata(in: Range(5..<data!.count))
            let jsonData = try! JSONSerialization.jsonObject(with: data2!, options: .allowFragments) as! [String:Any]
            if (jsonData["status"] as? Double) != nil{
                completionandler("Invalid login",nil);
                return
            }
            let data3 = jsonData["account"] as! [String:Any]
            completionandler(nil,data3["key"] as! String)
            
            
        }).resume()
        

    }
    
    static func getFirstLastName(loginId:String,completionandler:@escaping (_ error:String?)->()){
        let url=URL(string: "https://www.udacity.com/api/users/\(loginId)")
        let rqst = NSMutableURLRequest(url: url!)
        rqst.addValue(Constant.AppConstant.appID_Key_Value, forHTTPHeaderField: Constant.AppConstant.appID_Key)
        rqst.addValue(Constant.AppConstant.Parse_API_Value, forHTTPHeaderField: Constant.AppConstant.Parse_API_Key)
        rqst.addValue("application/json", forHTTPHeaderField: "Accept")
        rqst.addValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: rqst as URLRequest, completionHandler: { (data, response, error) in
            if error != nil {
                completionandler(error?.localizedDescription)
                 return
            }
            let data2 = data?.subdata(in: Range(5..<data!.count))
            let jsonData = try! JSONSerialization.jsonObject(with: data2!, options: .allowFragments) as! [String:Any]
            if let userData = jsonData["user"] as? [String:Any] ,let last = userData["last_name"]  as? String , let first =  userData["first_name"] as? String{
                StudentInfo.firstName = first
                StudentInfo.lastName = last
            }
            completionandler(nil)
            
        }).resume()
        
        
    }
    
    static func PostStudentLocation(post:Bool,Coordinate:CLLocationCoordinate2D,url:String?,http: String, completionandler: @escaping (_ error: String?)-> ())
    {
        let objID = post ? "" : StudentInfo.objID
        let rqst = NSMutableURLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation/\(objID)")!)
        rqst.addValue(Constant.AppConstant.appID_Key_Value, forHTTPHeaderField: Constant.AppConstant.appID_Key)
        rqst.addValue(Constant.AppConstant.Parse_API_Value, forHTTPHeaderField: Constant.AppConstant.Parse_API_Key)
        rqst.httpBody = "{\"uniqueKey\": \"\(StudentInfo.StudentId)\", \"firstName\": \"\(StudentInfo.firstName)\", \"lastName\": \"\(StudentInfo.lastName)\",\"mapString\": \"\("")\", \"mediaURL\": \"\(url!)\",\"latitude\": \(Coordinate.latitude) , \"longitude\":  \(Coordinate.longitude)}".data(using: String.Encoding.utf8)
         rqst.addValue("application/json", forHTTPHeaderField: "Content-Type")
         rqst.httpMethod = post ? "POST" : "PUT" ;
        let session = URLSession.shared
        let task = session.dataTask(with: rqst as URLRequest) { data, response, error in
            if error != nil
            {
                completionandler(error?.localizedDescription)
            return
            }
            if (post){
            let data = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:Any]
              StudentInfo.objID = data["objectId"] as! String
            }
            completionandler(nil)
            
        }.resume()
        
    }
    static func loagoutCalled(completionandler:@escaping (_ error:String?)->()){
        
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completionandler(error?.localizedDescription)
                return
            }
            completionandler(nil)
        }
        task.resume()
        
    }
    
    
    
}
