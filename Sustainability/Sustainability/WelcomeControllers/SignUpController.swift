//
//  SignUpController.swift
//  Sustainability
//
//  Created by Jeffrey Bennet on 3/3/23.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class SignUpController: UIViewController{
    @IBOutlet var email: UITextField!
    @IBOutlet var name: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var signUp: UIButton!
    @IBOutlet var errorLabel: UILabel!
    let auth = Auth.auth()
    let db  = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email.layer.cornerRadius = 20
        password.layer.cornerRadius = 20
        signUp.layer.cornerRadius = 20
        email.returnKeyType = .done
        email.autocorrectionType = .no
        email.autocapitalizationType = .words
        password.returnKeyType = .done
        password.autocorrectionType = .no
        password.autocapitalizationType = .words
        email.becomeFirstResponder()
        password.becomeFirstResponder()
        email.delegate = self
        password.delegate = self
        
    }
    
    @IBAction func buttonTapped() {
        email.resignFirstResponder()
        password.resignFirstResponder()
        if email.text != "" && password.text != "" && name.text != ""{
            //errorLabel.alpha = 0
            if let email = self.email.text, let password = self.password.text , let name = name.text{
                print(password)
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    
                    if let e = error {
                        print(e);
                        print("here")
                        self.handleError(e)
                        self.errorLabel.alpha = 1
                    } else {
                        Constants.new = true
                        self.db.collection(Auth.auth().currentUser?.uid ?? "").document("UserInfo").setData(["Name": name])
                        self.db.collection(Auth.auth().currentUser?.uid ?? "").document("Plants").setData(["PlantsChosen": []])
                        DispatchQueue.main.async {
                            Constants.name = name
                            self.performSegue(withIdentifier: "SignUpToChat" , sender: self)
                        }
                        }
                    }
                }
                
            }
            
    
            else {
                errorLabel.text = "Please fill in required fields"
                self.errorLabel.alpha = 1
            }
    }
}

extension SignUpController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension SignUpController{
    func handleError(_ error: Error) {
        if let errorCode = AuthErrorCode.Code(rawValue: error._code) {
                    switch errorCode {
                       case .wrongPassword:
                        errorLabel.text = "WRONG PASSWORD"
                       case .invalidEmail:
                        errorLabel.text = "INVALID EMAIL"
                       // ... other cases
                       default:
                        errorLabel.text = "UNKOWN ERROR"
                       }
                    }
            
            
        }
}
