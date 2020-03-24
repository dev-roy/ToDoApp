//
//  ItemCell.swift
//  ToDoApp
//
//  Created by Field Employee on 3/18/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit
import SwipeCellKit

class ItemCell: SwipeTableViewCell {
    
    // MARK: - Properties
    @IBOutlet weak var checkbox: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var itemInfoLabel: UILabel!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var iconLabel: UILabel!
    
    // MARK: - Init
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
