//
//  ViewController.swift
//  Todoey
//
//  Created by Abdelrahman on 5/14/20.
//  Copyright © 2020 Abdelrahman. All rights reserved.
//

import UIKit

class TodoeyListViewController: UITableViewController {
    var list = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent(K.itmePListKey)
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveData()
    }
    @IBAction func additemBtn(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newItem = Item()
            newItem.title = textField.text!
            self.list.append(newItem)
            self.saveData()
        }
        alert.addAction(addAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    
    // MARK:- TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellID, for: indexPath)
        let item = list[indexPath.row]
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    // MARK:- TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        list[indexPath.row].done = !list[indexPath.row].done
        saveData()
    }


    func saveData() {
             let encoder = PropertyListEncoder()
               do {
                   let data = try encoder.encode(list)
                   try data.write(to: dataFilePath!)
               }catch {
                   print("Error encoding list \(error)")
               }
               tableView.reloadData()
    }
    func retrieveData() {
        if let data =  try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                list = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error Decoding items \(error)")
            }
        }
    }
}


