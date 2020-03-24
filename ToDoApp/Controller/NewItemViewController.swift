//
//  NewItemViewController.swift
//  ToDoApp
//
//  Created by Field Employee on 3/19/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit
import RealmSwift
import iOSDropDown

protocol UpdateInformation {
    func updateTableView()
}

class NewItemViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var dueDatePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var imageSelector: DropDown!
    var todoItems: Results<Item>?
    let realm = try! Realm()
    var delegate: UpdateInformation?
    var isEdited = false
    var itemToEdit: Item?
    var selectedIcon: String?
    
    // MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        if isEdited {
            guard let itemToEdit = itemToEdit else { return }
            titleTextField.text = itemToEdit.title
            descriptionTextField.text = itemToEdit.itemInfo
            dueDatePicker.minimumDate = itemToEdit.dueDate
            dueDatePicker.date = itemToEdit.dueDate
            imageSelector.text = itemToEdit.selectedIcon
        } else {
            saveButton.isEnabled = false
            [titleTextField, descriptionTextField].forEach({ $0.addTarget(self, action: #selector(editingChanged), for: .editingChanged) })
            dueDatePicker.minimumDate = Date()
        }
         dueDatePicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
        imageSelector.optionArray = ["‼️","📎", "✏️", "🕒"]
        imageSelector.addTarget(self, action: #selector(selectImagePressed), for: .editingDidBegin)
        imageSelector.arrowSize = 10
        imageSelector.arrowColor = .label
        imageSelector.selectedRowColor = .lightGray
        imageSelector.didSelect{(selectedText , index , id) in
            self.selectedIcon = selectedText
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    // MARK: - Handlers
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let title = titleTextField.text else { return }
        guard let description = descriptionTextField.text else { return }
        if isEdited {
            try! realm.write {
                itemToEdit?.title = title
                itemToEdit?.itemInfo = description
                itemToEdit?.dueDate = dueDatePicker.date
                itemToEdit?.selectedIcon = selectedIcon ?? "📁"
                delegate?.updateTableView()
            }
        } else {
            do {
                try realm.write {
                    let newItem = Item()
                    newItem.title = title
                    newItem.itemInfo = description
                    newItem.dueDate = dueDatePicker.date
                    newItem.selectedIcon = selectedIcon ?? "📁"
                    realm.add(newItem)
                    delegate?.updateTableView()
                }
            } catch {
                print("error")
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        guard
            let title = titleTextField.text, !title.isEmpty,
            let description = descriptionTextField.text, !description.isEmpty
        else {
            saveButton.isEnabled = false
            return
        }
        saveButton.isEnabled = true
    }
    
    @objc func datePickerChanged(picker: UIDatePicker) {
        view.endEditing(true)
    }
    
    @objc func selectImagePressed() {
        view.endEditing(true)
    }
}

extension NewItemViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleTextField {
            textField.resignFirstResponder()
            descriptionTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
}
