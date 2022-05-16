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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        let todo = todos[indexPath.row]
        configure(cell, with: todo)
        return cell
    }
   
    // MARK: - Cell Content
    func configure(_ cell: UITableViewCell, with todo: ToDo) {
        cell.textLabel?.text = todo.title
        cell.detailTextLabel?.text = todo.isComplete ? "✅" : "☑️"
        cell.imageView?.image = todo.image
    }
}
