//
//  SignUpViewController.swift
//  Headache Tracker
//
//  Created by Nehal Jhala on 6/26/21.
//

import UIKit
import CoreData

class SignUpViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var genderTF: UITextField!
    @IBOutlet weak var weightTF: UITextField!
    @IBOutlet weak var heightTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    var agePickerView = UIPickerView()
    var heightPickerView = UIPickerView()
    var genderPickerView = UIPickerView()
    
    var genderData = ["Male", "Female", "Non Binary", "Prefer Not to Say"]
    var ageData = ["15 - 25 years", "26 - 40 years", "41 - 60 years", "above 60"]
    var heightData = ["4.9","5.0","5.1", "5.2", "5.3", "5.4", "5.5", "5.6","5.7", "5.8", "5.9", "5.10", "5.11", "6.0", "6.1", "6.2","6.3","6.4","6.5","6.6"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        genderPickerView.dataSource = self
        genderPickerView.delegate = self
        heightPickerView.dataSource = self
        heightPickerView.delegate = self
        agePickerView.dataSource = self
        agePickerView.delegate = self
        genderTF.inputView = genderPickerView
        heightTF.inputView = heightPickerView
        ageTF.inputView = agePickerView
        genderPickerView.tag = 1
        heightPickerView.tag = 2
        agePickerView.tag = 3
        
    }
    
    //keyboard settings:
    override func viewWillAppear(_ animated: Bool) {
        subscribeToKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
    }
    
    @objc func keyboardWillHide(_notification:Notification) {
    }
    
    //pickerview settings:
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag{
        case 1:
            return genderData.count
        case 2:
            return heightData.count
        case 3:
            return ageData.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag{
        case 1:
            return genderData[row]
        case 2:
            return heightData[row]
        case 3:
            return ageData[row]
        default:
            return "Data not found."
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        switch pickerView.tag{
        case 1:
            genderTF.text = genderData[row]
            genderTF.resignFirstResponder()
        case 2:
            heightTF.text = heightData[row]
            heightTF.resignFirstResponder()
        case 3:
            ageTF.text = ageData[row]
            ageTF.resignFirstResponder()
        default:
            return
        }
    }
    
    // For pressing return on the keyboard to dismiss keyboard:
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userNameTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        weightTF.resignFirstResponder()
        return true
    }
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        userNameTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        genderTF.resignFirstResponder()
        weightTF.resignFirstResponder()
        heightTF.resignFirstResponder()
        ageTF.resignFirstResponder()
        
        let weightInt = Int("\(weightTF.text!)")
        if weightInt ?? 0 <= 100{
            let alert = UIAlertController(title: "Alert", message: "Weight is too less.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            present(alert, animated: true, completion: nil)
            return
        }
        
        if userNameTF.text != nil,
           passwordTF.text != nil,
           weightTF.text != nil,
           heightTF.text != nil,
           ageTF.text != nil{
            
            //persistent container
            let appDelegate = UIApplication.shared.delegate as! AppDelegate //Singlton instance
            var context:NSManagedObjectContext!
            context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
            let newUser = NSManagedObject(entity: entity!, insertInto: context)
            
            //give alert if username is already used:
            if userAlreadyExists() == true{
                
                let alert = UIAlertController(title: "Sorry", message: "Username already exists.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                present(alert, animated: true, completion: nil)
                return
            }
            
            //save in coredata:
            newUser.setValue(userNameTF.text, forKey: "userName")
            newUser.setValue(passwordTF.text, forKey: "password")
            newUser.setValue(Int(ageTF.text!), forKey: "age")
            newUser.setValue(Int(heightTF.text!), forKey: "height")
            newUser.setValue(Int(weightTF.text!), forKey: "weight")
            do {
                try context.save()
            } catch {
            }
            self.dismiss(animated: true, completion: nil)
            return
        }
    }
    
    //check if user already exists:
    func userAlreadyExists()-> Bool{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate //Singlton instance
        var context:NSManagedObjectContext!
        context = appDelegate.persistentContainer.viewContext
        var _: NSError? = nil
        let predicate = NSPredicate(format: "userName = %@", userNameTF.text!)
        let fReq: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fReq.returnsObjectsAsFaults = false
        fReq.predicate = predicate
        do {
            let result : [Any] = try context.fetch(fReq)
            print(result)
            if result.count >= 1{
                print("user found")
                return true
            }
        } catch {
        }
        print("user not found")
        return false
    }
}
