//
//  FirstViewController.swift
//  ToDoApp
//
//  Created by Field Employee on 3/18/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
//import M13Checkbox

class FirstViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var itemsTableView: UITableView!
    var todoItems: Results<Item>?
    let realm = try! Realm()
    let currentDate = Date()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func loadItems() {
        todoItems = realm.objects(Item.self)
        itemsTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createNewItem" {
            let newItemVC = segue.destination as! NewItemViewController
            newItemVC.delegate = self
        }
    }
    
    func dateToString(date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        let formattedDate = df.string(from: date)
        return formattedDate
    }
    
    @objc func checkboxClicked(_ sender: UIButton) {
        let indexPath = sender.tag
        if let item = todoItems?[indexPath] {
            try! realm.write {
                item.isDone = !item.isDone
            }
            sender.isSelected = !sender.isSelected
        }
    }
}

// MARK: - Extensions
extension FirstViewController: UITableViewDelegate, UITableViewDataSource, SwipeTableViewCellDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        cell.delegate = self
        cell.selectionStyle = .none
        if let item = todoItems?[indexPath.row] {
            if item.isDone {
                cell.checkbox.isSelected = true
            }
            cell.checkbox.tag = indexPath.row
            cell.checkbox.addTarget(self, action: #selector(checkboxClicked(_ :)), for: .touchUpInside)
            cell.titleLabel.text = item.title
            cell.itemInfoLabel.text = item.itemInfo
            cell.iconLabel.text = item.selectedIcon
            if item.dueDate < currentDate {
                cell.dueDateLabel.textColor = UIColor.red
                cell.dueDateLabel.text = dateToString(date: item.dueDate)
            } else {
                cell.dueDateLabel.text = dateToString(date: item.dueDate)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
            guard orientation == .right else { return nil }

            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                // handle action by updating model with deletion
                if let itemForDeletion = self.todoItems?[indexPath.row] {
                    try! self.realm.write {
                        self.realm.delete(itemForDeletion)
                    }
                }
            }

    //        // customize the action appearance
    //        deleteAction.image = UIImage(named: "delete")

            return [deleteAction]
        }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newItemVC = storyboard.instantiateViewController(identifier: "NewItemViewController") as! NewItemViewController
        newItemVC.isEdited = true
        newItemVC.itemToEdit = todoItems?[indexPath.row]
        newItemVC.delegate = self
        present(newItemVC, animated: true, completion: nil)
    }
    
}

extension FirstViewController: UpdateInformation {
    func updateTableView() {
        loadItems()
    }
}
