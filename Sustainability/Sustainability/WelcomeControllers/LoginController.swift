//
//  LoginController.swift
//  Sustainability
//
//  Created by Jeffrey Bennet on 3/3/23.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class LoginController: UIViewController{
    @IBOutlet var email: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var login: UIButton!
    @IBOutlet var errorLabel: UILabel!
    let auth = Auth.auth()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email.layer.cornerRadius = 20
        password.layer.cornerRadius = 20
        login.layer.cornerRadius = 20
        email.returnKeyType = .done
        email.autocorrectionType = .no
        email.autocapitalizationType = .words
        password.returnKeyType = .done
        password.autocorrectionType = .no
        password.autocapitalizationType = .words
    }
    
    @IBAction func buttonTapped() {
        email.resignFirstResponder()
        password.resignFirstResponder()
        if email.text != "" && password.text != ""{
            if let email = email.text, let password = password.text {
                print(password)
                print(email)
                   Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                       if let e = error{
                        self.handleError(e)
                        self.errorLabel.alpha = 1
                        return
                       } else {
                           let id = Auth.auth().currentUser?.uid ?? ""
                           let docRef = self.db.collection(id).document("UserInfo")
                           docRef.getDocument(source: .server) { [self] (document, error) in
                               if let document = document {
                                   var text  = document.get("Name")
                                   var string = text as! String
                                   print("here" + string)
                                   DispatchQueue.main.async {
                                       Constants.name = text as! String
                                       self.performSegue(withIdentifier: "LoginToChat", sender: self)
                                   }
                               } else {
                                   print("Document does not exist in cache")
                               }
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

extension LoginController{
}

extension LoginController{
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
