//
//  DateCell.swift
//  ToDo
//
//  Created by Gerodot on 5/17/22.
//

import UIKit

class DateCell: UITableViewCell {
    @IBOutlet var label: UILabel!
    
    func setDate (_ date: Date) {
        label.text = date.formattedDate
    }
}
