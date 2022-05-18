//
//  ToDoItemTableViewController.swift
//  ToDo
//
//  Created by Gerodot on 5/16/22.
//

import UIKit

class ToDoItemTableViewController: UITableViewController{

    // MARK: - Properites
    var todo = ToDo()
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
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let value = todo.values[indexPath.section]
        if let cell = tableView.cellForRow(at: indexPath) {
            return cell.isHidden ? 0 : UITableView.automaticDimension
        } else {
            return UITableView.automaticDimension //value is Date && indexPath.row == 1 ? 0 :
        }
    }

    func getCellFor(indexPath: IndexPath, with value: Any?) -> UITableViewCell {

        if let stringValue = value as? String {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as! TextFieldCell
            cell.textField.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
            cell.textField.section = indexPath.section
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
                cell.datePicker.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
                cell.datePicker.date = dateValue
                cell.datePicker.section = indexPath.section
                cell.datePicker.minimumDate = Date()
                return cell

            default:
                fatalError("Please add more prototype for Date Selection")
            }

        } else if let imageValue = value as? UIImage {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell") as! ImageCell
            cell.largeImageView.image = imageValue
            return cell

        } else if let boolValue = value as? Bool {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwtichCell") as! SwtichCell
            cell.switchVoew.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
            cell.switchVoew.section = indexPath.section
            cell.switchVoew.isOn = boolValue
            return cell

        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as! TextFieldCell
            cell.textField.addTarget(self, action: #selector(textFieldValueChanged(_:)), for: .editingChanged)
            cell.textField.section = indexPath.section
            cell.textField.text = ""
            return cell
        }
    }
}

// MAKR: - UITableViewDelegate
extension ToDoItemTableViewController /*:UITableViewDelegate*/ {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let value = todo.values[indexPath.section]

        if value is Date {
            
            // TODO: Implement show/hide date picker
            
        } else if value is UIImage {

            let alert = UIAlertController(title: "Choose Source", message: nil, preferredStyle: .actionSheet)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)

            let imagePicker = SectionImagePickerController()
            imagePicker.delegate = self
            imagePicker.section = indexPath.section

            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let cameraAction = UIAlertAction(title: "Camera", style: .default) {
                    acion in
                    imagePicker.sourceType = .camera
                    self.present(imagePicker, animated: true)
                }
                alert.addAction(cameraAction)
            }

            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) {
                    acion in
                    imagePicker.sourceType = .photoLibrary
                    self.present(imagePicker, animated: true)
                }
                alert.addAction(photoLibraryAction)
            }
            
            alert.addAction(cancel)

            present(alert, animated: true)
        }
    }
}

// MARK: - Cell Configurator
extension ToDoItemTableViewController {
    @objc func datePickerValueChanged (_ sender: SectionDatePicker) {
        let section = sender.section!
        let key = todo.keys[section]
        let value = sender.date
        todo.setValue(value, forKey: key)
        let labelIndexPath = IndexPath(row: 0, section: section)
        tableView.reloadRows(at: [labelIndexPath], with: .automatic)
    }
    
    @objc func imageValueChaned(_ sender: SectionImagePickerController) {
        let key = todo.keys[sender.section!]
        let value = sender
    }

    @objc func switchValueChanged(_ sender: SectionSwich) {
        let key = todo.keys[sender.section!]
        let value = sender.isOn
        todo.setValue(value, forKey: key)
    }

    @objc func textFieldValueChanged(_ sender: SectionTextField) {
        let key = todo.keys[sender.section!]
        let text = sender.text ?? ""
        todo.setValue(text, forKey: key)
    }
}

// MARK: - Cell Configurator
extension ToDoItemTableViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        dismiss(animated: true)
        guard
            let image = info[.originalImage] as? UIImage,
            let sectionPicker = picker as? SectionImagePickerController,
            let section = sectionPicker.section
        else { return }
        
        let key = todo.keys[section]
        todo.setValue(image, forKey: key)
        let indexPath = IndexPath(row: 0, section: section)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
extension ToDoItemTableViewController: UINavigationControllerDelegate {
    
}


