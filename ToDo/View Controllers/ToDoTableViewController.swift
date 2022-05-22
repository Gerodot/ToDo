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
            ToDo(title: "Постричь Ладу", isComplete: true, image: UIImage(named: "lada")),
            ToDo(title: "Подготовить презентацию", image: UIImage(named: "pitch"))
        ]
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
        configure(cell, with: todo)
        return cell

    }

    // MARK: - Cell Content
    func configure(_ cell: ToDoCell, with todo: ToDo) {
        guard
            let stackView = cell.stackView,
            stackView.arrangedSubviews.count == 0
        else { return }
        
        let horisontalStack = UIStackView ()
        horisontalStack.axis = .horizontal
        
        for index in 0 ..< todo.keys.count {
            let key = todo.capitalizedKeys[index]
            let value = todo.values[index]

            if let stringValue = value as? String {

                let label = UILabel()
                label.text = "\(key): \(stringValue)"
                horisontalStack.addArrangedSubview(label)

            } else if let dateValue = value as? Date {

                let label = UILabel()
                label.text = "\(key): \(dateValue.formattedDate)"
                horisontalStack.addArrangedSubview(label)

            } else if let boolValue = value as? Bool {
                
                let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium, scale: .large)

                // image in label expertiment
                let isChecked = NSTextAttachment()
                let isUnchecked = NSTextAttachment()
                isChecked.image = UIImage(systemName: "checkmark.square.fill", withConfiguration: symbolConfig)
                isUnchecked.image = UIImage(systemName: "square", withConfiguration: symbolConfig)
                let label = UILabel()
                label.attributedText = boolValue ? NSAttributedString(attachment: isChecked) : NSAttributedString(attachment: isUnchecked)
                label.textColor = .systemBlue
                horisontalStack.addArrangedSubview(label)
                
                
                // Button Experiment
                let imageValue = boolValue ? isChecked.image : isUnchecked.image
                let button = UIButton()
                button.setImage(imageValue, for: .normal)
                horisontalStack.addArrangedSubview(button)

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
            stackView.addArrangedSubview(horisontalStack)
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
