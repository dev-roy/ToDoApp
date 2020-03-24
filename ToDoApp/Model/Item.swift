//
//  Item.swift
//  ToDoApp
//
//  Created by Field Employee on 3/19/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import Foundation
import RealmSwift

class  Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var itemInfo: String = ""
    @objc dynamic var selectedIcon: String = ""
    @objc dynamic var dueDate: Date = Date()
    @objc dynamic var isDone: Bool = false
}
