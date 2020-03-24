//
//  Utilities.swift
//  ToDoApp
//
//  Created by Field Employee on 3/20/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import Foundation

func dateToString(date: Date) -> String {
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd"
    let formattedDate = df.string(from: date)
    return formattedDate
}

