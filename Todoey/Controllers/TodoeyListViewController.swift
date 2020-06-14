//
//  ViewController.swift
//  Todoey
//
//  Created by Abdelrahman on 5/14/20.
//  Copyright © 2020 Abdelrahman. All rights reserved.
//

import UIKit
import CoreData

class TodoeyListViewController: UITableViewController {
    var list = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var selectedCategory: Category?  {
        didSet {
            retrieveData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    @IBAction func additemBtn(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
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
    
    // MARK:- CoreData methods
    
    func saveData() {
        do {
            try context.save()
        }catch {
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    
    func retrieveData(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        let categoryPrediacte = NSPredicate(format: "parentCategory.name MATCHES[cd] %@", selectedCategory!.name!)
        if let additionalpredicate = predicate {
             request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPrediacte,additionalpredicate])
        } else {
            request.predicate = categoryPrediacte
        }
        do {
            list = try context.fetch(request)
        } catch {
            print("Error Fetching Data from persistent container \(error)")
        }
        tableView.reloadData()
    }
}
// MARK:- Serach Bar Delegate Methods
extension TodoeyListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
      
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.count != 0 {
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            retrieveData()
        } else {
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
            retrieveData(with: request, predicate: predicate)
        }
    }
}

