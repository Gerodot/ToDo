//
//  ToDoTableViewController.swift
//  ToDo
//
//  Created by Gerodot on 5/16/22.
//

import UIKit

class ToDoTableViewController: UITableViewController {

    var todos = [ToDo]()


    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        todos = [
            ToDo(title: "Купить хлеб", image: UIImage(named: "bread")),
            ToDo(title: "Постричь Ладу", image: UIImage(named: "lada")),
            ToDo(title: "Подготовить презентацию", image: UIImage(named: "pitch"))
        ]

        tableView.layer.masksToBounds = false
        tableView.layer.shadowColor = UIColor.black.cgColor // any value you want
        tableView.layer.shadowOpacity = 1 // any value you want
        tableView.layer.shadowRadius = 10 // any value you want
        tableView.layer.shadowOffset = .init(width: 10, height: 10) // any value you want
    }

    // MARK: - UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return todos.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView
            .dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as! ToDoCell
        let todo = todos[indexPath.section]
        configure(cell, with: todo, indexPath: indexPath)
        return cell

    }

    // MARK: - Cell Content
    func configure(_ cell: ToDoCell, with todo: ToDo, indexPath: IndexPath) {
        guard
            let stackView = cell.stackView,
            stackView.arrangedSubviews.count == 0
        else { return }

        stackView.spacing = 0

        let horisontalStack = UIStackView ()
        horisontalStack.axis = .horizontal

        for index in 0 ..< todo.keys.count {
            let key = todo.capitalizedKeys[index]
            let value = todo.values[index]

            if let stringValue = value as? String {

                let label = UILabel()
                label.text = stringValue
                if key == "Notes" {
                    stackView.addArrangedSubview(label)
                } else {
                    horisontalStack.addArrangedSubview(label)
                }

            } else if let dateValue = value as? Date {

                let label = UILabel()
                label.text = dateValue.formattedDate
                horisontalStack.addArrangedSubview(label)

            } else if let boolValue = value as? Bool {
                
                // Configure button font
                let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium, scale: .large)

                // image in button
                let isChecked = NSTextAttachment()
                let isUnchecked = NSTextAttachment()
                isChecked.image = UIImage(systemName: "checkmark.square.fill", withConfiguration: symbolConfig)
                isUnchecked.image = UIImage(systemName: "square", withConfiguration: symbolConfig)

                // Button
                let button = UIButton()
                var imageValue = boolValue ? isChecked.image : isUnchecked.image
                button.setImage(imageValue, for: .normal)
                
                // Add action to button
                button.addAction(UIAction(title: "", handler: { action in
                    guard action.sender is UIButton else { return }
                    
                    self.todos[indexPath.section].isComplete.toggle()
                    imageValue = self.todos[indexPath.section].isComplete ? isChecked.image : isUnchecked.image
                    button.setImage(imageValue, for: .normal)
                    
                }), for: .touchUpInside)
                
                // Add button on first place in horisontal stack
                horisontalStack.insertArrangedSubview(button, at: 0)

            } else if let imageValue = value as? UIImage {

                // image scaling byaspect and clipping
                let imageView = UIImageView(image: imageValue)
                let heightConstraint = NSLayoutConstraint(
                    item: imageView,
                    attribute: .height,
                    relatedBy: .equal,
                    toItem: nil,
                    attribute: .height,
                    multiplier: 1,
                    constant: stackView.frame.width
                )
                imageView.addConstraint(heightConstraint)
                imageView.contentMode = .scaleAspectFill
                imageView.clipsToBounds = true
                imageView.layer.cornerRadius = 5
                stackView.addArrangedSubview(imageView)

            }
            
            // Add horisontal stack view in vertical stack
            horisontalStack.spacing = 10
            stackView.addArrangedSubview(horisontalStack)
            horisontalStack.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            horisontalStack.isLayoutMarginsRelativeArrangement = true
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
        segue.identifier == "ToDoItemSeguee",
            let selelctedIndex = tableView.indexPathForSelectedRow,
            let destination = segue.destination as? ToDoItemTableViewController
        else { return }

        destination.todo = todos[selelctedIndex.section].copy() as! ToDo
    }

    // MARK: - Actions
    @IBAction func unwind(_ segue: UIStoryboardSegue) {
        guard
        segue.identifier == "SaveSegue",
            let selecttedIndex = tableView.indexPathForSelectedRow,
            let source = segue.source as? ToDoItemTableViewController
        else { return }

        todos[selecttedIndex.section] = source.todo

        if let toDoCell = tableView.cellForRow(at: selecttedIndex) as? ToDoCell {
            if let stackView = toDoCell.stackView {
                stackView.arrangedSubviews.forEach { subview in
                    stackView.removeArrangedSubview(subview)
                    subview.removeFromSuperview()
                }
            }
            tableView.reloadRows(at: [selecttedIndex], with: .automatic)
        }
    }
}
