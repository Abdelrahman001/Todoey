//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Abdelrahman on 6/10/20.
//  Copyright © 2020 Abdelrahman. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {
    var list: Results<Category>?
    
    @IBOutlet weak var addItem: UIBarButtonItem!
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveData()
      
    }

    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 13.0, *) {
                  let navBarAppearance = UINavigationBarAppearance()
                  navBarAppearance.configureWithOpaqueBackground()
                  navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
                  navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
                  navBarAppearance.backgroundColor = .red
                  navigationController?.navigationBar.standardAppearance = navBarAppearance
                  navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
              }
              
    }
    @IBAction func addCategoryBtnPressed(_ sender: UIBarButtonItem) {
        var editText = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (alertAction) in
            let newCategory = Category()
            newCategory.name = editText.text!
            newCategory.cellColor = UIColor.randomFlat().hexValue()
            self.save(category: newCategory)
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
        return list?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let category = list?[indexPath.row] {
            cell.textLabel?.text = category.name
            guard let categoryColor =  UIColor(hexString: category.cellColor) else {fatalError() }
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }

        return cell
    }
    // MARK:- Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.toItemsSegue, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoeyListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = list?[indexPath.row]
            destinationVC.title = list?[indexPath.row].name
        }
    }
    
    // MARK:- Data manipulation methods
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving data \(error)")
        }
        tableView.reloadData()
    }
    
    func retrieveData() {
        list = realm.objects(Category.self).sorted(byKeyPath: "name", ascending: true)
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {

        if let categoryForDeletion = self.list?[indexPath.row] {
            do{
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting cell \(error)")
            }
        }
    }
}


