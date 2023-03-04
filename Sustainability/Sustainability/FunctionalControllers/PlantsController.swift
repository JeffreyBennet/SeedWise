//
//  PlantsController.swift
//  Sustainability
//
//  Created by Jeffrey Bennet on 3/4/23.
//

import Foundation
import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class PlantsController: UIViewController{
    @IBOutlet var label: UILabel!
    @IBOutlet var instructions: UITextView!
    var plant = ""
    let db = Firestore.firestore()
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        instructions.sizeToFit()
        let docRef = db.collection("Plant-Data").document(plant)
        docRef.getDocument(source: .server) { [self] (document, error) in
            if let document = document {
                var text  = document.get("0")
                DispatchQueue.main.async {
                    self.instructions.text = text as! String
                }
            } else {
                print("Document does not exist in cache")
            }
            label.text = plant
            
        }
        
        
        
    }
    
    @IBAction func back(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
