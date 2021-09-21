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
    var heightData = ["4.9","5.0","5.1", "5.2", "5.3", "5.4", "5.5", "5.6","5.7", "5.8", "5.9", "5.10", "5.11", "6.0", "6.1", "6.2","6.3","6.4","6.5","6.6, 6.7"]
    
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
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        userNameTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        genderTF.resignFirstResponder()
        weightTF.resignFirstResponder()
        heightTF.resignFirstResponder()
        ageTF.resignFirstResponder()
        //Alert - If weight is inaccurate:
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
            //Alert - If username is already used:
            let hTPersistence = HTPerCont()
            let userAlreadyExist = hTPersistence.loginCall(userNameTF.text!, passwordTF.text!)
            print("user already exist is", userAlreadyExist)
            if userAlreadyExist == true{
                let alert = UIAlertController(title: "Sorry", message: "Username already exists.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                present(alert, animated: true, completion: nil)
                return
            }
            else{
                print(userNameTF.text!, passwordTF.text!, ageTF.text!, heightTF.text!, weightTF.text!)
                hTPersistence.saveUserDetails(userNameTF.text!, passwordTF.text!, String(ageTF.text!), String(heightTF.text!), (Int(weightTF.text!)!))
                self.dismiss(animated: true, completion: nil)
                return
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userNameTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        weightTF.resignFirstResponder()
        return true
    }
    
    //Keyboard Settings:
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
    
    //Pickerview Settings:
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
}
