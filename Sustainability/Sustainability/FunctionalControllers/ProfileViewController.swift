//
//  ProfileViewController.swift
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

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet var name: UILabel!
    @IBOutlet var table: UITableView!
    let db = Firestore.firestore()
    var plants: [String] = []
    var currPlant = 0
    override func viewDidLoad() {
        
        table.delegate = self
        table.dataSource = self
        //loadData()
        name.text = Constants.name
        print(plants)
        DispatchQueue.main.async {
            self.table.reloadData()
        }
    }
    func loadData(){
        plants = []
        let docRef = db.collection(Auth.auth().currentUser?.uid ?? "").document("Plants")
        docRef.getDocument(source: .server) { [self] (document, error) in
            if let document = document {
                    let p = document.get("PlantsChosen") as! [String]
                    for pl in p {
                        print(pl)
                        self.plants.append(pl)
                    }
                    DispatchQueue.main.async {
                        self.table.reloadData()
                    }
                
            } else {
                print("Document does not exist in cache")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.loadData()
             self.table.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     //   print(plants)
        return plants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cells1", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = plants[indexPath.item].capitalized
        
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currPlant = indexPath.row
        performSegue(withIdentifier: "Plant", sender: "Self")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let firstVC = segue.destination as? PlantsController else { return }
        firstVC.plant = plants[currPlant]
    }
}
