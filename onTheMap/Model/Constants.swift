//
//  Constants.swift
//  onTheMap
//
//  Created by Atul Bansal on 12/05/18.
//  Copyright © 2018 Atul Bansal. All rights reserved.
//

import Foundation
import MapKit
struct Constant{
    
    struct AppConstant{
        static let Parse_API_Key = "X-Parse-REST-API-Key"
        static let appID_Key = "X-Parse-Application-Id"
        static let Parse_API_Value = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let appID_Key_Value = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    }
    
}
struct StudentInfo{
static var StudentId = ""
static var firstName = ""
static var lastName = ""
static var objID = ""
static var arrayOfStudents=[Student]()
    static func getAllPins()->[MKPointAnnotation]{
        var mkannotions = [MKPointAnnotation]()
        for student in arrayOfStudents{
        let annoation = MKPointAnnotation()
        annoation.coordinate = CLLocationCoordinate2D(latitude: student.latitute, longitude: student.longitute)
        annoation.subtitle = student.url
        annoation.title = student.name
        mkannotions.append(annoation)
        }
        return mkannotions
    }
}
struct Student{
    var name=""
    var longitute:Double=0.0
    var latitute:Double=0.0
    var url=""
    init(dict:[String:Any]) {
        self.name = "\(dict["firstName"] as? String ?? "" ) \(dict["lastName"] as? String ?? "") "
        self.latitute = (dict["latitude"] as? Double) ?? 0
//) (dict["latitude"] as! String)
        self.longitute = (dict["longitude"] as? Double) ?? 0
        self.url = dict["mediaURL"] as? String ?? ""
    }
    func points()->MKPointAnnotation
    {
        let annoation = MKPointAnnotation()
        annoation.coordinate = CLLocationCoordinate2D(latitude: latitute, longitude: longitute)
        annoation.subtitle = self.url
        annoation.title = self.name
        return annoation
    }
}
