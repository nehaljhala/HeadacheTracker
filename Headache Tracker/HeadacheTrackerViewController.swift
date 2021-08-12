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
    struct Response: Codable {
        var current: Weather
    }
    struct Weather: Codable {
        var temp: Float
        var humidity: Float
        var uvi: Float
        var wind_speed: Float
    }
    
    struct Response2: Codable {
        var list: [AirPollutionList]
    }
    
    struct AirPollutionList : Codable {
        var main : AirPollution
    }
    
    struct AirPollution : Codable {
        var aqi: Float
    }
    
    @IBOutlet weak var startStopButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var startStopLabel: UILabel!
    @IBOutlet weak var tempAvgLabel: UILabel!
    @IBOutlet weak var humidityAvgLabel: UILabel!
    @IBOutlet weak var uviAvgLabel: UILabel!
    @IBOutlet weak var aqiAvgLabel: UILabel!
    @IBOutlet weak var avgDurationLabel: UILabel!
    @IBOutlet weak var avgTimeLabel: UILabel!
    @IBOutlet weak var windSpeedAvgLabel: UILabel!
    
    
    var locationManager = CLLocationManager()
    var lat = Double()
    var lon = Double()
    var endTime = Date()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate //Singlton instance
    let dataArray : [NSManagedObject] = []
    var humidityAvg = Float()
    var tempAvg = Float()
    var windSpeedAvg = Float()
    var uviAvg = Float()
    var aqiAvg = Float()
    var timeAvg = String()
    var avgDuration = Int()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if isRecordingInProgress() == true{
            startStopLabel.text = "START"
        } else {
            startStopLabel.text = "STOP"
        }
        doAnalysis()
        tempAvgLabel.text = "\(tempAvg) \nTemp \n(F)"
        humidityAvgLabel.text = "\(humidityAvg) \nHumidity"
        uviAvgLabel.text = "\(uviAvg) \nUVI"
        windSpeedAvgLabel.text = "\(windSpeedAvg) \nWind \n(MPH) "
        aqiAvgLabel.text = "\(aqiAvg) \nAQI"
        avgTimeLabel.text = "\(timeAvg) \nTime"
        avgDurationLabel.text = "\(avgDuration) \nDuration \n(Mins)"
        
    }
    
    
    //get location:
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
            // Location updates are not authorized.
            // To prevent forever looping of `didFailWithError` callback
            locationManager.stopMonitoringSignificantLocationChanges()
            return
        }
    }
    
    
    @IBAction func startStopButtonTapped(_ sender: Any) {
        print("in start button tapped")
        if  isRecordingInProgress() == false{
            stopButtonTapped()
            startStopLabel.text = "START"
        }
        else {
            getJson() { (json) in
                // print(json)
                self.saveWeatherData(weather: json)
            }
            getJson2() { (json) in
                // print(json)
            }
            startStopLabel.text = "STOP"
        }
    }
    
    func isRecordingInProgress()-> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate //Singlton instance
        var context:NSManagedObjectContext!
        context = appDelegate.persistentContainer.viewContext
        var _: NSError? = nil
        let predicate = NSPredicate(format: "userName = %@ and endTime = nil", appDelegate.currentUser )
        let fReq: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HeadacheData")
        fReq.returnsObjectsAsFaults = false
        fReq.predicate = predicate
        do {
            let result = try context.fetch(fReq)
            if result.count == 0{
                return true
            }
            
        }
        catch{
        }
        return false
    }
    
    func stopButtonTapped() {
        //record time
        print("in stop function")
        endTime = Date()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate //Singlton instance
        var context:NSManagedObjectContext!
        context = appDelegate.persistentContainer.viewContext
        var _: NSError? = nil
        let predicate = NSPredicate(format: "userName = %@ and endTime = nil", appDelegate.currentUser )
        let fReq: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HeadacheData")
        fReq.returnsObjectsAsFaults = false
        fReq.predicate = predicate
        do {
            let result : [Any] = try context.fetch(fReq)
            if result.count == 0{
                print("no empty endtime")
                return
            }
            else {
                print("got one empty endtime")
                let updateRecord = result[0] as! NSManagedObject
                updateRecord.setValue(endTime, forKey: "endTime")
                try context.save()
                print("record updated")
            }
        } catch{
        }
    }
    
    
    //save weather data in Coredata:
    func saveWeatherData(weather:Response){
        var context:NSManagedObjectContext!
        context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "HeadacheData", in: context)
        let newData = NSManagedObject(entity: entity!, insertInto: context)
        newData.setValue(weather.current.temp, forKey: "temp")
        newData.setValue(weather.current.uvi, forKey: "uvi")
        newData.setValue(weather.current.humidity, forKey: "humidity")
        newData.setValue(weather.current.wind_speed, forKey: "windSpeed")
        newData.setValue(appDelegate.currentUser, forKey: "userName")
        newData.setValue(lat, forKey: "lat")
        newData.setValue(lon, forKey: "lon")
        newData.setValue(Date(), forKey: "startTime")
        
        do {
            try context.save()
            print("save successful")
        } catch {
        }
    }
    
    
    func getJson(completion: @escaping (Response)-> ()) {
        let urlString =  "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&appid=f263544bb99e65fba638f5938cbe8ef7"
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) {data, res, err in
                if let data = data {
                    do {
                        let json: Response = try JSONDecoder().decode(Response.self, from: data)
                        completion(json)
                    }catch let error {
                        print("api error" + error.localizedDescription)
                    }
                }
            }.resume()
        }
    }
    
    func getJson2(completion: @escaping (Response2)-> ()) {
        let urlString1 = "https://api.openweathermap.org/data/2.5/air_pollution?lat=\(lat)&lon=\(lon)&appid=f263544bb99e65fba638f5938cbe8ef7"
        if let url = URL(string: urlString1) {
            URLSession.shared.dataTask(with: url) {data, res, err in
                if let data = data {
                    do {
                        print("in json 2")
                        let json: Response2 = try JSONDecoder().decode(Response2.self, from: data)
                        completion(json)
                    }catch let error {
                        print("api error" + error.localizedDescription)
                    }
                }
            }.resume()
        }
    }
    
    
    @IBAction func historyButtonTapped(_ sender: Any) {
        //send data to tableView
    }
    @IBAction func logOutButtonTapped(_ sender: Any) {
        //go back to loginView
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
            var aqiVar : Float = 0.0
            var timeResult = [0,0,0]
            var durationVar = 0
            
            if headacheDataTable.count == 0 {
                humidityAvg = 0
                tempAvg = 0
                uviAvg = 0
                aqiAvg = 0
                windSpeedAvg = 0
                timeAvg = ""
                avgDuration = 0
            }
            else {
                for i in 0..<headacheDataTable.count{
                    //avg weather condition:
                    let humidityFloat = headacheDataTable[i].value(forKey: "humidity")as! Float
                    humiVar += humidityFloat
                    let tempFloat = headacheDataTable[i].value(forKey: "temp")as! Float
                    tempVar += tempFloat
                    let windSpeedFloat = headacheDataTable[i].value(forKey: "windSpeed")as! Float
                    windSpVar += windSpeedFloat
                    let uviFloat = headacheDataTable[i].value(forKey: "uvi")as! Float
                    uviVar += uviFloat
                    let aqiFloat = headacheDataTable[i].value(forKey: "aqi")as! Float
                    aqiVar += aqiFloat
                    
                    //average time:
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
                        let timeDifference = ( Double(newDateMinutes - oldDateMinutes))/60 //in minutes
                        duration = Int(timeDifference.rounded())
                        durationVar += duration
                        print(duration)
                    }
                }
                
                humidityAvg = humiVar / Float(headacheDataTable.count)
                humidityAvg = humidityAvg.rounded()
                tempAvg = tempVar / Float(headacheDataTable.count)
                tempAvg = tempAvg.rounded()
                windSpeedAvg = windSpVar / Float(headacheDataTable.count)
                windSpeedAvg = windSpeedAvg.rounded()
                uviAvg = uviVar / Float(headacheDataTable.count)
                uviAvg = uviAvg.rounded()
                aqiAvg = aqiVar / Float(headacheDataTable.count)
                aqiAvg = aqiAvg.rounded()
        
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
            }
        } catch {
        }
    }
}
