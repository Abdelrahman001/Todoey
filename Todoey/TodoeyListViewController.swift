//
//  ViewController.swift
//  Todoey
//
//  Created by Abdelrahman on 5/14/20.
//  Copyright © 2020 Abdelrahman. All rights reserved.
//

import UIKit

class TodoeyListViewController: UITableViewController {
    var list = ["Drinking cofee with friends", "Playing Bubg", "Back to Angela", "Watching Othman"]
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        list = defaults.array(forKey: K.itmeListDefultsKey) as! [String]
    }
    @IBAction func additemBtn(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            self.list.append(textField.text!)
            self.defaults.set(self.list, forKey: K.itmeListDefultsKey)
            self.tableView.reloadData()
        }
        alert.addAction(addAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addTextField { (alertTextField) in
            textField.placeholder = "Create New Item"
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
        cell.textLabel?.text = list[indexPath.row]
        return cell
    }
    // MARK:- TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark  {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
    }
}

