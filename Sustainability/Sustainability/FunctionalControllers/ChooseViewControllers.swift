//
//  ChooseViewControllers.swift
//  Sustainability
//
//  Created by Jeffrey Bennet on 3/4/23.
//

import Foundation

import Foundation
import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class ChooseViewControllers: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet var table: UITableView!
    @IBOutlet var done: UIButton!
    var data: [String] = []
    var selectedRows: [Int] = []
    let db = Firestore.firestore()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        self.table.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            //TODO: Return items count
        return data.count
        }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            var content = cell.defaultContentConfiguration()
            content.text = data[indexPath.item].capitalized
            
            cell.contentConfiguration = content
            return cell
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRows.append(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
           // cell.accessoryType = .none
            }
        var cnt = 0
               
               for c in selectedRows{
                   if c == indexPath.row{
                       selectedRows.remove(at: cnt)
                   }
                   cnt += 1
               }
    }
    
    @IBAction func tapped() {
        var plants: [String] = []
        for c in selectedRows {
            plants.append(data[c])
        }
        var property: [String] = []
        let id = Auth.auth().currentUser?.uid ?? ""
        let docRef = db.collection(Auth.auth().currentUser?.uid ?? "").document("Plants")
                docRef.getDocument(source: .server) { (document, error) in
                    if let document = document {
                        property = document.get("PlantsChosen") as! [String]
                        DispatchQueue.main.async { [self] in
                            var new: [String] = Array(combine(plants, property))
                            self.db.collection(Auth.auth().currentUser?.uid ?? "").document("Plants").setData(["PlantsChosen": new])
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    } else {
                        print("Document does not exist in cache")
                    }
                }
        
    }
    func combine<T>(_ arrays: Array<T>?...) -> Set<T> {
        return arrays.compactMap{$0}.compactMap{Set($0)}.reduce(Set<T>()){$0.union($1)}
    }
}
