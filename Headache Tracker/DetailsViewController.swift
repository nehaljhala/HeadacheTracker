//
//  DetailsViewController.swift
//  Headache Tracker
//
//  Created by Nehal Jhala on 7/21/21.
//

import UIKit
import CoreData
import MapKit
import CoreLocation

class DetailsViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var tableDetails: [NSManagedObject] = []
    var detailsText = String()
    let locationManager = CLLocationManager()
    var lon = Double()
    var lat = Double()
    var temp = Float ()
    var humidity = Float ()
    var uvi = Float ()
    var windSpeed = Float ()
    var startTimeDate = Date()
    var endTimeDate:Date?
    var duration = Int()
    var tempFahr = Float()
    
    @IBOutlet weak var tempLabel1: UILabel!
    @IBOutlet weak var humiLabel1: UILabel!
    @IBOutlet weak var uviLabel1: UILabel!
    @IBOutlet weak var windSpeedLabel1: UILabel!
    @IBOutlet weak var tempLabel2: UILabel!
    @IBOutlet weak var humiLabel2: UILabel!
    @IBOutlet weak var uviLabel2: UILabel!
    @IBOutlet weak var windSpeedLabel2: UILabel!
    @IBOutlet weak var durationLabel1: UILabel!
    @IBOutlet weak var durationLabel2: UILabel!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var mapViewMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDuration()
        tempLabel1.text = "Temperature"
        tempFahr = ((temp - 273.15) * 9/5 + 32).rounded()
        tempLabel2.text = "\(tempFahr) F"
         print(temp)
        humiLabel1.text = "Humidity"
        humiLabel2.text = "\(humidity)"
        
        uviLabel1.text = "UVI"
        uviLabel2.text = "\(uvi)"
        
        windSpeedLabel1.text = "Wind Speed"
        windSpeedLabel2.text = "\(windSpeed) MPH"
        
        durationLabel1.text = "Duration"
        durationLabel2.text = "\(duration) Mins"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        let region = MKCoordinateRegion.init(center: CLLocationCoordinate2D(latitude: lat, longitude: lon), latitudinalMeters: 4000, longitudinalMeters: 4000)
        mapViewMap.setRegion(region, animated: true)
    }
    
    
    @IBAction func okTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getDuration() {
        let headacheStartDate = startTimeDate as Date?
        if (headacheStartDate != nil ) {
            let df = DateFormatter()
            df.dateFormat = "MM/dd/YY HH:MM"
        }

        if endTimeDate == nil{
            duration = 0
        }
        else {
            let df = DateFormatter()
            df.dateFormat = "MM/dd/YY  HH:MM"

            //calculate duration of headache:
            let newDateMinutes = endTimeDate!.timeIntervalSinceReferenceDate/60
            let oldDateMinutes = startTimeDate.timeIntervalSinceReferenceDate/60
            let timeDifference = ( Double(newDateMinutes - oldDateMinutes))
            duration = Int(timeDifference.rounded()) //in minutes
            print(duration)
        }
    }
}
