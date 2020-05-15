//
//  ViewController.swift
//  Todoey
//
//  Created by Abdelrahman on 5/14/20.
//  Copyright © 2020 Abdelrahman. All rights reserved.
//

import UIKit

class TodoeyListViewController: UITableViewController {
    let list = ["Drinking cofee with friends", "Playing Bubg", "Back to Angela", "Watching Othman"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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

