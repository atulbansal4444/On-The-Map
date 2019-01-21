//
//  MapViewController.swift
//  onTheMap
//
//  Created by Atul Bansal on 12/05/18.
//  Copyright © 2018 Atul Bansal. All rights reserved.
//

import UIKit
import MapKit
class MapViewController: BaseViewController,MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.map.delegate = self
        Network.GetStudentData(completionandler: {error in
            if error==nil {
                self.PlaceData()
            }
            
        })
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.PlaceData()
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation)-> MKAnnotationView?
    {
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: "pin") as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    func PlaceData(){
             let annotions = StudentInfo.getAllPins()
        DispatchQueue.main.async {
            self.map.removeAnnotations(self.map.annotations)
            self.map.addAnnotations(annotions)
        }
        
    }
    @IBAction func addCall(_ sender: Any) {
     super.addPin()
    }
    @IBAction func logoutCall(_ sender: Any) {
        super.logoutOut(completionandler: {err in
            if err != nil{
                self.alert(message: err!, completionHandler: {})
                return
            }
              self.dismiss(animated: true, completion: nil)
        })
    }
    @IBAction func refreshCall(_ sender: Any) {
        super.reload { (error) in
            if(error==nil){
                self.PlaceData()
            }
            else {
                super.alert(message: error!, completionHandler: {})
            }
        }
    }
    
}
extension MapViewController{
    
}
