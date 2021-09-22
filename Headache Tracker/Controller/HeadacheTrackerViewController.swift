//
//  HeadacheTrackerViewController.swift
//  Headache Tracker
//
//  Created by Nehal Jhala on 6/26/21.
//
import Foundation
import UIKit
import CoreLocation
import CoreData

class HeadacheTrackerViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var startStopLabel: UILabel!
    @IBOutlet weak var tempAvgLabel: UILabel!
    @IBOutlet weak var humidityAvgLabel: UILabel!
    @IBOutlet weak var uviAvgLabel: UILabel!
    @IBOutlet weak var avgDurationLabel: UILabel!
    @IBOutlet weak var avgTimeLabel: UILabel!
    @IBOutlet weak var windSpeedAvgLabel: UILabel!
    
    var locationManager = CLLocationManager()
    var lat = Double()
    var lon = Double()
    var endTime = Date()
    let dataArray : [NSManagedObject] = []
    var humidityAvg = Float()
    var tempAvg = Float()
    var windSpeedAvg = Float()
    var uviAvg = Float()
    var timeAvg = String()
    var avgDuration = Int()
    var persCont = HTPerCont()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        if persCont.isRecordingInProgress() == true{
            startStopLabel.text = "START"
        } else {
            startStopLabel.text = "STOP"
        }
        doAnalysis()
        updateDashboard()
        setupLayout()
    }
    
    @IBAction func startStopButtonTapped(_ sender: Any) {
        if  persCont.isRecordingInProgress() == false{
            persCont.stopButtonTapped(endTime)
            startStopLabel.text = "START"
        }
        else {
            let client = HTClient()
            client.getJson(lat, lon) { [self] (json,error,success)  in
                if success == true{
                    DispatchQueue.main.async {
                        self.persCont.saveWeatherData(weather: json!, lat, lon)
                        doAnalysis()
                    }
                }
                else{
                    let alert = UIAlertController(title:"Unexpected Error", message: error?.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            startStopLabel.text = "STOP"
        }
    }
    
    @IBAction func historyButtonTapped(_ sender: Any) {
        //Segue to tableView
    }
    @IBAction func logOutButtonTapped(_ sender: Any) {
        //Segue to LoginView
    }
    
    //Analytics:
    func doAnalysis(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate //Singlton instance
        var context:NSManagedObjectContext!
        context = appDelegate.persistentContainer.viewContext
        var _: NSError? = nil
        let predicate = NSPredicate(format: "userName = %@" , appDelegate.currentUser)
        let fReq: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HeadacheData")
        fReq.returnsObjectsAsFaults = false
        fReq.predicate = predicate
        do {
            let headacheDataTable : [NSManagedObject] = try context.fetch(fReq) as! [NSManagedObject]
            var humiVar : Float = 0.0
            var tempVar : Float = 0.0
            var windSpVar : Float = 0.0
            var uviVar : Float = 0.0
            var timeResult = [0,0,0]
            var durationVar = 0
            if headacheDataTable.count == 0 {
                humidityAvg = 0
                tempAvg = 0
                uviAvg = 0
                windSpeedAvg = 0
                timeAvg = "None Yet"
                avgDuration = 0
            }
            else {
                for i in 0..<headacheDataTable.count{
                    //Avg weather condition:
                    let humidityFloat = headacheDataTable[i].value(forKey: "humidity")as! Float
                    humiVar += humidityFloat
                    let tempFloat = headacheDataTable[i].value(forKey: "temp")as! Float
                    let tempFahr = ((tempFloat - 273.15) * 9/5 + 32).rounded()
                    tempVar += tempFahr
                    let windSpeedFloat = headacheDataTable[i].value(forKey: "windSpeed")as! Float
                    windSpVar += windSpeedFloat
                    let uviFloat = headacheDataTable[i].value(forKey: "uvi")as! Float
                    uviVar += uviFloat
                    
                    //Average time:
                    let startTimeDate = headacheDataTable[i].value(forKey: "startTime")
                    if startTimeDate != nil  {
                        let sdt = startTimeDate as! Date
                        var calendar = Calendar.current
                        calendar.timeZone = TimeZone.current
                        let hour = calendar.component(.hour, from: sdt)
                        let minutes = calendar.component(.minute, from:sdt)
                        if hour == 00 {
                            timeResult[0] += 1
                        }
                        if hour <= 11  {
                            timeResult[0] += 1
                        }
                        if hour > 11 && hour < 18{
                            timeResult[1] += 1
                        }
                        if hour >= 18 {
                            timeResult[2] += 1
                        }
                    }
                    //calculate duration of headache:
                    var duration = Int()
                    let headacheEndDate = headacheDataTable[i].value(forKey: "endTime")
                    if (headacheEndDate != nil ) {
                        let df = DateFormatter()
                        df.dateFormat = "MM/dd/YY  HH:MM"
                        let newDateMinutes = (headacheEndDate! as AnyObject).timeIntervalSinceReferenceDate/60
                        let oldDateMinutes = (startTimeDate! as AnyObject).timeIntervalSinceReferenceDate/60
                        let timeDifference = ( Double(newDateMinutes - oldDateMinutes)) //in minutes
                        duration = Int(timeDifference.rounded())
                        durationVar += duration
                        print(duration)
                    }
                }
                //Weather avg:
                humidityAvg = humiVar / Float(headacheDataTable.count)
                humidityAvg = humidityAvg.rounded()
                tempAvg = tempVar / Float(headacheDataTable.count)
                tempAvg = tempAvg.rounded()
                windSpeedAvg = windSpVar / Float(headacheDataTable.count)
                windSpeedAvg = windSpeedAvg.rounded()
                uviAvg = uviVar / Float(headacheDataTable.count)
                uviAvg = uviAvg.rounded()
                
                //Time avg:
                let maxTime = timeResult.max()
                if timeResult[0] == maxTime{
                    timeAvg = "Morning"
                }
                if timeResult[1] == maxTime{
                    timeAvg = "Afternoon"
                }
                if timeResult[2] == maxTime{
                    timeAvg = "Evening"
                }
                avgDuration = (durationVar / headacheDataTable.count)
                print(avgDuration)
                updateDashboard()
                setupLayout()
            }
        } catch {
        }
    }
    
    func updateDashboard() {
        tempAvgLabel.text = "\(tempAvg) \nTemp(F)"
        humidityAvgLabel.text = "\(humidityAvg) \nHumidity"
        uviAvgLabel.text = "\(uviAvg) \nUVI"
        windSpeedAvgLabel.text = "\(windSpeedAvg) \nWind(MPH)"
        avgDurationLabel.text = "\(avgDuration) \nDuration\n(Mins)"
        avgTimeLabel.text = "Your Headache mostly occurs at \n\(timeAvg)"
    }
    
    func setupLayout(){
        let tempString:NSString = "\(tempAvgLabel.text!)" as NSString
        var tempMutableString = NSMutableAttributedString()
        let humidityString:NSString = "\(humidityAvgLabel.text!)" as NSString
        var humidityMutableString = NSMutableAttributedString()
        let windSpeedString:NSString = "\(windSpeedAvgLabel.text!)" as NSString
        var windSpeedMutableString = NSMutableAttributedString()
        let uviString:NSString = "\(uviAvgLabel.text!)" as NSString
        var uviMutableString = NSMutableAttributedString()
        let durationString:NSString = "\(avgDurationLabel.text!)" as NSString
        var durationMutableString = NSMutableAttributedString()
        let timeString:NSString = "\(avgTimeLabel.text!)" as NSString
        var timeMutableString = NSMutableAttributedString()
        
        tempMutableString = NSMutableAttributedString(string: tempString as String)
        tempMutableString.setAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30),NSAttributedString.Key.foregroundColor: UIColor.systemRed],range: NSMakeRange(0, 4))
        humidityMutableString = NSMutableAttributedString(string: humidityString as String)
        humidityMutableString.setAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30),NSAttributedString.Key.foregroundColor: UIColor.systemRed],range: NSMakeRange(0, 4))
        windSpeedMutableString = NSMutableAttributedString(string: windSpeedString as String)
        windSpeedMutableString.setAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30),NSAttributedString.Key.foregroundColor: UIColor.systemRed],range: NSMakeRange(0, 4))
        uviMutableString = NSMutableAttributedString(string:uviString as String)
        uviMutableString.setAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30),NSAttributedString.Key.foregroundColor: UIColor.systemRed],range: NSMakeRange(0, 4))
        durationMutableString = NSMutableAttributedString(string: durationString as String)
        durationMutableString.setAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30),NSAttributedString.Key.foregroundColor: UIColor.systemRed],range: NSMakeRange(0, 3))
        timeMutableString = NSMutableAttributedString(string: timeString as String)
        timeMutableString.setAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15),NSAttributedString.Key.foregroundColor: UIColor.systemGray5],range: NSMakeRange(0, 30))
        tempAvgLabel.attributedText = tempMutableString
        humidityAvgLabel.attributedText = humidityMutableString
        windSpeedAvgLabel.attributedText = windSpeedMutableString
        uviAvgLabel.attributedText = uviMutableString
        avgDurationLabel.attributedText = durationMutableString
        avgTimeLabel.attributedText = timeMutableString
    }
    
    //Get Location:
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied: // Setting option: Never
            print("LocationManager didChangeAuthorization denied")
        case .notDetermined: // Setting option: Ask Next Time
            print("LocationManager didChangeAuthorization notDetermined")
        case .authorizedWhenInUse: // Setting option: While Using the App
            print("LocationManager didChangeAuthorization authorizedWhenInUse")
            //  Request a one-time location information
            locationManager.requestLocation()
        case .authorizedAlways: // Setting option: Always
            print("LocationManager didChangeAuthorization authorizedAlways")
            //  Request a one-time location information
            locationManager.requestLocation()
        case .restricted: // Restricted by parental control
            print("LocationManager didChangeAuthorization restricted")
        default:
            print("LocationManager didChangeAuthorization")
        }
    }
    
    //  Handle the location information
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("LocationManager didUpdateLocations: numberOfLocation: \(locations.count)")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        locations.forEach { (location) in
            lat = location.coordinate.latitude
            lon = location.coordinate.longitude
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationManager didFailWithError \(error.localizedDescription)")
        if let error = error as? CLError, error.code == .denied {
            locationManager.stopMonitoringSignificantLocationChanges()
            return
        }
    }
}

