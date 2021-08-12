//
//  LoginViewController.swift
//  Headache Tracker
//
//  Created by Nehal Jhala on 6/26/21.
//

import UIKit
import CoreData

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        userNameTF.text = ""
        //        passwordTF.text = ""
        
    }
    
    //keyboard settings:
    override func viewWillAppear(_ animated: Bool) {
        subscribeToKeyboardNotifications()
        //print("login view will appear")
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
    }
    
    @objc func keyboardWillHide(_notification:Notification) {
    }
    
    // For pressing return on the keyboard to dismiss keyboard:
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        userNameTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        return true
    }
    
    //login:
    @IBAction func loginButtonTapped(_ sender: Any){
        userNameTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        var loginSuccessful = Bool()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate //Singlton instance
        var context:NSManagedObjectContext!
        context = appDelegate.persistentContainer.viewContext
        var _: NSError? = nil
        let predicate = NSPredicate(format: "userName = %@ and password = %@", userNameTF.text!, passwordTF.text!)
        let fReq: NSFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        fReq.returnsObjectsAsFaults = false
        fReq.predicate = predicate
        do {
            let result : [Any] = try context.fetch(fReq)
            if result.count >= 1{
                loginSuccessful = true
                let object = UIApplication.shared.delegate as! AppDelegate
                object.currentUser = userNameTF.text!
            }
        } catch {
        }
        if loginSuccessful == true{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "headacheTracker") as! HeadacheTrackerViewController
            nextViewController.modalPresentationStyle = .fullScreen
            self.present(nextViewController, animated:true, completion:nil)
            return
        }
        
        //throw error:
        if loginSuccessful == false{
            let alert = UIAlertController(title:"Ooops", message: "Login Unsuccessful.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SignUp") as! SignUpViewController
        nextViewController.modalPresentationStyle = .fullScreen
        self.present(nextViewController, animated:true, completion:nil)
    }
}

