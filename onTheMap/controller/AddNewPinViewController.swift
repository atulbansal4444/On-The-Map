//
//  AddNewPinViewController.swift
//  onTheMap
//
//  Created by Atul Bansal on 13/05/18.
//  Copyright © 2018 Atul Bansal. All rights reserved.
//
import UIKit
import MapKit
class AddNewPinViewController: UIViewController,MKMapViewDelegate,UITextFieldDelegate{
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var indiicator: UIActivityIndicatorView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var map: MKMapView!
    var post = true
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        textField.delegate = self
        button.setTitle("SearchPlace", for: .normal)
    }

    @IBAction func cancelView(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
    func disableUi(bool:Bool){
        DispatchQueue.main.async {
        self.textField.isEnabled = !bool
        self.button.isEnabled = !bool
            if(bool){
                self.indiicator.startAnimating()
            }
            else {
                self.indiicator.stopAnimating()
            }
        }
    }
    @IBAction func buttonPressed(_ sender: Any) {
        if textField.text=="" || textField.text == " "{
            self.alert(message:"Enter The text", completionHandler: {self.disableUi(bool: false)})
            return
        }
        if ((sender as! UIButton).titleLabel?.text == "SearchPlace"){
             disableUi(bool: true)
            self.getCoodinate(location: textField.text!, completionHandler: { (error, coordinate) in
                if error != nil {
                    self.alert(message: error!, completionHandler: {self.disableUi(bool: false)})
                    return
                }
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                self.map.addAnnotation(annotation)
                let span=MKCoordinateSpan(latitudeDelta: 0.099, longitudeDelta: 0.092)
                let region=MKCoordinateRegion(center: coordinate, span: span)
                self.map.setRegion(region, animated: true)
                self.button.setTitle("Submit", for: .normal)
                self.textField.text=""
                self.textField.placeholder = "Enter Url"
                self.disableUi(bool: false)
            })
        }
        else {
            Network.PostStudentLocation(post: post, Coordinate: map.annotations[0].coordinate, url: textField.text!, http: "", completionandler: { (error) in
                if(error != nil){
                    self.alert(message: error!, completionHandler: {self.disableUi(bool: false)})
                }
                self.disableUi(bool: false)
                self.dismiss(animated: true, completion: nil)
                })
        }
    }
    func getCoodinate(location:String,completionHandler:@escaping (_ erro:String?,_ coordinate:CLLocationCoordinate2D)->()){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
              self.alert(message: "No internet Connection", completionHandler: {self.disableUi(bool: false)})
                return
            }
            completionHandler(nil, (placemarks?.first?.location?.coordinate)!)

        }
           )
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }

}
