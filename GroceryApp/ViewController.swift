//
//  ViewController.swift
//  GroceryApp
//
//  Created by Reyhaan Alim on 17/03/2022.
//

import UIKit
import Firebase

protocol ViewControllerDelegate: AnyObject {
    func addNewGrocery(title: String, description: String)
    func loadData()
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var groceryItems: [GroceryModel] = [GroceryModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        loadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _ = segue.destination as? AddViewController {
            let destinationVC = segue.destination as! AddViewController
            destinationVC.delegate = self
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groceryItems.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroceryItem", for: indexPath)
        let item = groceryItems[indexPath.row]
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.description
        if item.isComplete {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let grocery = groceryItems[indexPath.row]
        if grocery.isComplete {
            grocery.isComplete = false
        } else {
            grocery.isComplete = true
        }
        
        let groceryUpdate: [String: Any] = ["title": grocery.title, "description": grocery.description, "isComplete": grocery.isComplete]
        Database.database().reference().child("groceries").updateChildValues(["\(grocery.key)": groceryUpdate])
        tableView.reloadData()
    }
    
    func loadData() {
        let query = Database.database().reference().child("groceries").queryOrderedByKey()
        query.observeSingleEvent(of: .value) { snapshot in
            var newGroceries:[GroceryModel] = [GroceryModel]()
            for item in snapshot.children {
                guard let snapshot = item as? DataSnapshot else { continue }
                guard let groceryValue = snapshot.value as? [String: Any] else { continue }
                guard let groceryTitle = groceryValue["title"]  as? String else { continue }
                guard let groceryDescription = groceryValue["description"]  as? String else { continue }
                let groceryIsComplete = groceryValue["isComplete"] as? Bool
                let grocery = GroceryModel(key: snapshot.key, title: groceryTitle, description: groceryDescription, isComplete: groceryIsComplete ?? false)
                newGroceries.append(grocery)
            }
            self.groceryItems = newGroceries
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }

    @IBAction func addButtonDidTouch(_ sender: Any) {
        performSegue(withIdentifier: "AddSegue", sender: nil)
    }
    
}

extension ViewController: ViewControllerDelegate {
    func addNewGrocery(title: String, description: String) {
        guard let groceryKey = Database.database().reference().child("groceries").childByAutoId().key else { return }
        let grocery = ["title": title, "description": description]
        Database.database().reference().child("groceries").updateChildValues(["\(groceryKey)": grocery])
        loadData()
    }
}
