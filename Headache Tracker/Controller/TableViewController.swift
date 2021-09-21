//
//  TableViewController.swift
//  Headache Tracker
//
//  Created by Nehal Jhala on 6/26/21.
//
import Foundation
import UIKit
import CoreData

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var tableDetails: [NSManagedObject] = []
    var headacheStartDateString = String()
    var duration = Int()
    var durationArr = [Int]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let persCont = HTPerCont()
        tableDetails = persCont.fetchDetails()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HTCell", for: indexPath) as! HTCell
        let rowHeadache = tableDetails[indexPath.row]
        let headacheStartDate = rowHeadache.value(forKey: "startTime") as? Date
        if (headacheStartDate != nil ) {
            let df = DateFormatter()
            df.dateFormat = "MM/dd/YY HH:MM"
            headacheStartDateString = df.string(from: headacheStartDate!)
        }
        let headacheEndDate = rowHeadache.value(forKey: "endTime") as? Date
        if (headacheEndDate != nil ) {
            let df = DateFormatter()
            df.dateFormat = "MM/dd/YY  HH:MM"
            //calculate duration of headache:
            let newDateMinutes = headacheEndDate!.timeIntervalSinceReferenceDate/60
            let oldDateMinutes = headacheStartDate!.timeIntervalSinceReferenceDate/60
            let timeDifference = ( Double(newDateMinutes - oldDateMinutes))
            duration = Int(timeDifference.rounded())
            durationArr.append(duration)
        }
        cell.startTime.text = "\(headacheStartDateString)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    //When details disclosure button is tapped(adding accessory):
    func tableView(_ tableView: UITableView,
                   accessoryButtonTappedForRowWith indexPath: IndexPath){
        let rowHeadache = tableDetails[indexPath.row]
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "toDetails") as! DetailsViewController
        nextViewController.modalPresentationStyle = .fullScreen
        nextViewController.temp = rowHeadache.value(forKey: "temp") as! Float
        nextViewController.humidity = rowHeadache.value(forKey: "humidity") as! Float
        nextViewController.uvi = rowHeadache.value(forKey: "uvi") as! Float
        nextViewController.windSpeed = rowHeadache.value(forKey: "windSpeed") as! Float
        nextViewController.startTimeDate = rowHeadache.value(forKey: "startTime") as!Date
        nextViewController.endTimeDate = rowHeadache.value(forKey: "endTime") as? Date
        nextViewController.lat = rowHeadache.value(forKey: "lat") as! Double
        nextViewController.lon = rowHeadache.value(forKey: "lon") as! Double
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            var context:NSManagedObjectContext!
            context = appDelegate.persistentContainer.viewContext
            context.delete(tableDetails[indexPath.row])
            tableDetails.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            do{
                try context.save()
            } catch let error as NSError {
                print(error, error.userInfo)
            }
        }
    }
}
