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

// MARK: - UITableViewDataSource
extension ToDoItemTableViewController /*:UITableViewDelegate*/ {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return todo.keys.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let key = todo.capitalizedKeys[section]
        return key
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let value = todo.values[section]
        return value is Date ? 2 : 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let value = todo.values[section]
        let cell = getCellFor(indexPath: indexPath, with: value)
        return cell
    }
}

// MARK: - Cell Configurator
extension ToDoItemTableViewController {
    func getCellFor(indexPath: IndexPath, with value: Any?) -> UITableViewCell {

        if let stringValue = value as? String {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as! TextFieldCell
            cell.textField.text = stringValue
            return cell

        } else if let dateValue = value as? Date {

            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell") as! DateCell
                cell.setDate(dateValue)
                return cell

            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "DatePickerCell") as! DatePickerCell
                cell.datePicker.date = dateValue
                cell.datePicker.minimumDate = Date()
                return cell

            default:
                fatalError("Please add more prototype for Date Selection")
            }

        } else if let imageValuew = value as? UIImage {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell") as! ImageCell
            cell.largeImageView.image = imageValuew
            return cell

        } else if let boolValue = value as? Bool {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwtichCell") as! SwtichCell
            cell.switchVoew.isOn = boolValue
            return cell

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as! TextFieldCell
            cell.textField.text = ""
            return cell
        }
    }
}
