//
//  ViewController.swift
//  Todoey
//
//  Created by Abdelrahman on 5/14/20.
//  Copyright © 2020 Abdelrahman. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoeyListViewController: SwipeTableViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    var todoeyItems: Results<Item>?
    let realm = try! Realm()
    var selectedCategory: Category?  {
        didSet {
            retrieveData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.searchTextField.backgroundColor = .white
    }
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            if let hexColor = selectedCategory?.cellColor, let uiColor = UIColor(hexString: hexColor) {
                navBarAppearance.titleTextAttributes = [.foregroundColor: ContrastColorOf(uiColor , returnFlat: true) ]
                navBarAppearance.largeTitleTextAttributes = [.foregroundColor: ContrastColorOf(uiColor , returnFlat: true)]
                navBarAppearance.backgroundColor = uiColor
                guard let navBar = navigationController?.navigationBar else {
                    fatalError("Navigation controller doesn't exist.")}
                navBar.standardAppearance = navBarAppearance
                navBar.scrollEdgeAppearance = navBarAppearance
                navBar.tintColor = ContrastColorOf(uiColor, returnFlat: true)
                searchBar.barTintColor = uiColor
            }
            
        }
        
    }
    
    @IBAction func additemBtn(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error Saving data\(error)")
                }
            }
            self.tableView.reloadData()
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
        return todoeyItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoeyItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            if let color = UIColor(hexString: selectedCategory!.cellColor)?.darken(byPercentage: CGFloat(indexPath.row)/CGFloat(todoeyItems!.count)) {
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
        } else {
            cell.textLabel?.text = "No Items has been added yet"
        }
        return cell
    }
    // MARK:- TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let item = todoeyItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status \(error)")
            }
        }
        tableView.reloadData()
    }
    
    // MARK:- CoreData methods
    
    func retrieveData() {
        
        todoeyItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        tableView.reloadData()
    }
    override func updateModel(at indexPath: IndexPath) {
        if let itemForDeletion = self.todoeyItems?[indexPath.row] {
            do{
                try self.realm.write {
                    self.realm.delete(itemForDeletion)
                }
            } catch {
                print("Error deleting cell \(error)")
            }
        }
    }
}
// MARK:- Serach Bar Delegate Methods
extension TodoeyListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text?.count != 0 {
            todoeyItems = todoeyItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
                       tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            retrieveData()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            retrieveData()
        } else {
            todoeyItems = selectedCategory?.items.filter("title CONTAINS[cd] %@", searchText).sorted(byKeyPath: "dateCreated", ascending: true)
            tableView.reloadData()
        }
    }
}


