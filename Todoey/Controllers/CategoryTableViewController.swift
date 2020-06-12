//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Abdelrahman on 6/10/20.
//  Copyright © 2020 Abdelrahman. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    var list = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.retrieveData()
        }
    }

    @IBAction func addCategoryBtnPressed(_ sender: UIBarButtonItem) {
        var editText = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (alertAction) in
            let newCategory = Category(context: self.context)
            newCategory.name = editText.text!
            self.list.append(newCategory)
            self.saveData()
        }
        alert.addAction(action)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        alert.addTextField { (textField) in
            textField.placeholder = "Create New Category"
            editText = textField
        }
        present(alert, animated: true, completion: nil)
    }
    
    
    // MARK: - Table view data source methods


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.categoryCell, for: indexPath)
        let categoryItem = list[indexPath.row]
        cell.textLabel?.text = categoryItem.name
        return cell
    }
    // MARK:- Table view delegate methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: K.toItemsSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoeyListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = list[indexPath.row]
        }
    }
    
    // MARK:- Data manipulation methods
    func saveData() {
        do {
            try context.save()
        } catch {
           print("Error saving data \(error)")
        }
        tableView.reloadData()
    }
    func retrieveData() {
        let request:NSFetchRequest<Category> = Category.fetchRequest()
        do {
            list = try context.fetch(request)
        } catch {
            print("Error retrieving data from context \(error)")
        }
        tableView.reloadData()
    }

}
