//
//  ToDoItemTableViewController.swift
//  ToDo
//
//  Created by Gerodot on 5/16/22.
//

import UIKit

class ToDoItemTableViewController: UITableViewController {

    // MARK: - Properites
    var todo = ToDo() {
        didSet {
            dump(todo)
        }
    }
    // MARK: - UIVewController
    override func viewDidLoad() {
        super.viewDidLoad()
        todo.isComplete.toggle()
    }
}
