//
//  SecondViewController.swift
//  ToDoApp
//
//  Created by Field Employee on 3/18/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit
import RealmSwift

class SecondViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var completedItemsTableView: UITableView!
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadItems()
    }
    
    func loadItems() {
        todoItems = realm.objects(Item.self)
        completedItemsTableView.reloadData()
    }

}

extension SecondViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompletedItemCell", for: indexPath) as! CompletedItemCell
        if let item = todoItems?[indexPath.row] {
            if item.isDone {
                cell.titleLabel.text = item.title
                cell.dueDateLabel.text = dateToString(date: item.dueDate)
                return cell
            }  else {
                cell.titleLabel.text = ""
                cell.dueDateLabel.text = ""
            }
        }
        return cell
    }
}
