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
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView
            .dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as! ToDoCell
        let todo = todos[indexPath.row]
        configure(cell, with: todo)
        return cell

    }
   
    // MARK: - Cell Content
    func configure(_ cell: ToDoCell, with todo: ToDo) {
        guard
            
            let stackView = cell.stackView,
            stackView.arrangedSubviews.count == 0
                
        else { return  }

        for index in 0 ..< todo.keys.count {
            let key = todo.capitalizedKeys[index]
            let value = todo.values[index]
            
            if let stringValue = value as? String {

                let label = UILabel()
                label.text = "\(key): \(stringValue)"
                stackView.addArrangedSubview(label)

            } else if let dateValue = value as? Date {

                let label = UILabel()
                label.text = "\(key): \(dateValue.formattedDate)"
                stackView.addArrangedSubview(label)

            } else if let boolValue = value as? Bool {

                let label = UILabel()
                label.text = "\(key): \(boolValue ? "✅" : "☑️")"
                stackView.addArrangedSubview(label)

            } else if let imageValue = value as? UIImage {

                let imageView = UIImageView(image: imageValue)
                let heightConstraint = NSLayoutConstraint(
                    item: imageView,
                    attribute: .height,
                    relatedBy: .equal,
                    toItem: nil,
                    attribute: .height,
                    multiplier: 1,
                    constant: 350
                )
                imageView.addConstraint(heightConstraint)
                imageView.contentMode = .scaleAspectFit
                stackView.addArrangedSubview(imageView)

            }
        }
        
        dump(stackView.arrangedSubviews)
    }
}
