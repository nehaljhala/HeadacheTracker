//
// HTPersistence.swift
//  Headache Tracker
//
//  Created by Nehal Jhala on 9/18/21.
//
import UIKit
import Foundation
import CoreData

class HTPerCont{
    var loginSuccessful = Bool()
    func loginCall(_ userName: String, _ password: String) -> Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate //Singlton instance
        var context:NSManagedObjectContext!
        context = appDelegate.persistentContainer.viewContext
        var _: NSError? = nil
        let predicate = NSPredicate(format: "userName = %@ and password = %@", userName, password)
        let fReq: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fReq.returnsObjectsAsFaults = false
        fReq.predicate = predicate
        do {
            let result : [Any] = try context.fetch(fReq)
            if result.count >= 1{
                loginSuccessful = true
                let object = UIApplication.shared.delegate as! AppDelegate
                object.currentUser = userName
            } else {
                loginSuccessful = false
            }
        } catch let error as NSError {
        }
        return loginSuccessful
    }
    
    func saveUserDetails(_ userName: String, _ password:String, _ age:String, _ height:String, _ weight:Int) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate //Singlton instance
        var context:NSManagedObjectContext!
        context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        newUser.setValue(userName, forKey: "userName")
        newUser.setValue(password, forKey: "password")
        newUser.setValue(age, forKey: "age")
        newUser.setValue(height, forKey: "height")
        newUser.setValue(weight, forKey: "weight")
        do {
            try context.save()
        } catch {
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
        catch let error as NSError{
        }
        return false
    }
    
    //Record time:
    func stopButtonTapped(_ endTime: Date) {
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
                return
            }
            else {
                let updateRecord = result[0] as! NSManagedObject
                updateRecord.setValue(endTime, forKey: "endTime")
                try context.save()
            }
        } catch let error as NSError{
            print(error, error.userInfo)
        }
    }    
    
    func saveWeatherData(weather:Response, _ lat: Double, _ lon: Double){
        var context:NSManagedObjectContext!
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
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
        } catch let error as NSError{
            print(error, error.userInfo)
        }
    }
    
    func fetchDetails ()-> [NSManagedObject]{
        var context:NSManagedObjectContext!
        let appDelegate = UIApplication.shared.delegate as! AppDelegate //Singlton instance
        context = appDelegate.persistentContainer.viewContext
        var _: NSError? = nil
        let predicate = NSPredicate(format: "userName = %@" , appDelegate.currentUser)
        let fReq: NSFetchRequest = NSFetchRequest<NSManagedObject>(entityName: "HeadacheData")
        fReq.returnsObjectsAsFaults = false
        fReq.predicate = predicate
        var tableDetails = [NSManagedObject]()
        do {
            tableDetails = try context.fetch(fReq)
        } catch let error as NSError {
            print(error, error.userInfo)
        }
        return tableDetails
    }
}
