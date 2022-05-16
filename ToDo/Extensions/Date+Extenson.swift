//
//  Date.swift
//  ToDo
//
//  Created by Gerodot on 5/17/22.
//

import Foundation

extension Date {
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
}
