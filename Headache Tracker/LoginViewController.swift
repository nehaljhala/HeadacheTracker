//
//  LoginViewController.swift
//  Headache Tracker
//
//  Created by Nehal Jhala on 6/26/21.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var users: [User]{
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.users
    }
    
    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTF.text = ""
        passwordTF.text = ""
        
    }
    
    //keyboard settings:
    override func viewWillAppear(_ animated: Bool) {
        subscribeToKeyboardNotifications()
        print("login view will appear")
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
        print(userNameTF.text ?? String())
        print(passwordTF.text ?? String())
        userNameTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        
        for member in users{
            print("starting to loop")
            if userNameTF.text == member.userName && passwordTF.text == member.password{
                print("conditions match")
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "headacheTracker") as! HeadacheTrackerViewController
                self.present(nextViewController, animated:true, completion:nil)
                print("running after opening view controller")
                return
            }
        }
        
        //throw error:
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nVC = storyBoard.instantiateViewController(withIdentifier: "showError") as! ErrorViewController
        self.present(nVC, animated:true, completion:nil)
        
    }
     
    
    @IBAction func signUpTapped(_ sender: Any) {
        
    }
    
    
}

