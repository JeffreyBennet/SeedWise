//
//  SearchPlantViewController.swift
//  Sustainability
//
//  Created by Jeffrey Bennet on 3/3/23.
//

import Foundation

import Foundation
import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth


class SearchPlantViewController: UIViewController{
    @IBOutlet var temperature: UITextField!
    @IBOutlet var effort: UITextField!
    @IBOutlet var sunlight: UITextField!
    @IBOutlet var done: UIButton!
    @IBOutlet var errorLabel: UILabel!
    let db = Firestore.firestore()
    var data: [String] = []
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func buttonTapper() {
        if(temperature.text != "" && effort.text != "" && sunlight.text != ""){
            let integer = Int(temperature.text ?? "0") ?? 0
            var key = 0
            if integer <= 49 {
                key = 100
            } else if integer <= 59 {
                key = 200
            } else if integer <= 69 {
                key = 300
            } else if integer <= 79 {
                key = 400
            } else if integer <= 89{
                key = 500
            }
            if key == 0 {
                errorLabel.text = "Invalid entry"
                errorLabel.alpha = 1;
                return
            }
            let numTimesPerWeek = Int(effort.text ?? "0") ?? 0
            if numTimesPerWeek == 1 {
                key += 10
            } else if numTimesPerWeek == 2 {
                key += 20
            } else if numTimesPerWeek == 3 {
                key += 30
            }
            let sun = Int(sunlight.text ?? "0") ?? 0
            if sun == 1 {
                key += 1
            } else if sun == 2 {
                key += 2
            }
            print(key)
            print(String(key))
            let docRef = db.collection("Plant-Data").document(String(key))

            docRef.getDocument { [self] (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data()
                    var num = dataDescription?.count
                    var food: [String] = []
                    for data in dataDescription!.values{
                        food.append(data as! String)
                    }
                    self.data = food
                    self.performSegue(withIdentifier: "ChooseOptions", sender: self)
                } else {
                    print("Document does not exist")
                }
            }
            
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let firstVC = segue.destination as? ChooseViewControllers else { return }
        firstVC.data = data
    }
}
