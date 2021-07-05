//
//  SignUpViewController.swift
//  Headache Tracker
//
//  Created by Nehal Jhala on 6/26/21.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
//    var users: [User]!{
//        let object = UIApplication.shared.delegate
//        let appDelegate = object as! AppDelegate
//        return appDelegate.users
//    }

    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var genderTF: UITextField!
    @IBOutlet weak var weightTF: UITextField!
    @IBOutlet weak var heightTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTF.text = ""
        passwordTF.text = ""
        genderTF.text = ""
        heightTF.text = ""
        weightTF.text = ""
        ageTF.text = ""
        
        
    }
    
    //keyboard settings:
    override func viewWillAppear(_ animated: Bool) {
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //stop listening to keyboard events:
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if ageTF.isFirstResponder  {
            view.frame.origin.y = -300
        }
        if heightTF.isFirstResponder  {
            view.frame.origin.y = -300
        }
//        if weightTF.isFirstResponder  {
//            view.frame.origin.y = -300
//        }
    }
    
    @objc func keyboardWillHide(_notification:Notification) {
        if ageTF.isFirstResponder  {
            view.frame.origin.y = 0
        }
        if heightTF.isFirstResponder  {
            view.frame.origin.y = 0
        }
//        if weightTF.isFirstResponder  {
//            view.frame.origin.y = 0
//        }
    }
    
    
    // For pressing return on the keyboard to dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        userNameTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        genderTF.resignFirstResponder()
        weightTF.resignFirstResponder()
        heightTF.resignFirstResponder()
        ageTF.resignFirstResponder()
        return true
    }
    
    
    @IBAction func registerButtonTapped(_ sender: Any) {
        userNameTF.resignFirstResponder()
        passwordTF.resignFirstResponder()
        genderTF.resignFirstResponder()
        weightTF.resignFirstResponder()
        heightTF.resignFirstResponder()
        ageTF.resignFirstResponder()
        
        var newUser = User(userName: userNameTF.text!, password: passwordTF.text!, gender: genderTF.text!, age: ageTF.text!, height: heightTF.text!, weight: weightTF.text!)
        
        if userNameTF != nil,
           passwordTF != nil,
           weightTF != nil,
           heightTF != nil,
           ageTF != nil{
            
            let object = UIApplication.shared.delegate
            let appDelegate = object as! AppDelegate
            appDelegate.users.append(newUser)

            print("\(appDelegate.users)")
            print("registration completed")
            self.navigationController?.popViewController(animated: true)

//            self.dismiss(animated: true, completion: nil)
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//
//            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "goToLogin") as! LoginViewController
//            self.present(nextViewController, animated:true, completion:nil)
            return
            
        }
    }
    
    

}
