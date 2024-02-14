//
//  ListViewController.swift
//  Taskify
//
//  Created by Tatiana Simmer on 13/02/2024.
//

import UIKit

protocol TasksListDisplayer: AnyObject {
    func showTasks(_ tasks: [Record])
    func showError(_ error: Error)
}

protocol TasksListDelegate: AnyObject {
    
}

class TasksListViewController: UIViewController, UITableViewDelegate {
    let presenter: TasksListPresenter = TasksListsPresenterImpl()
    var tasks: [Record] = []
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        presenter.bind(displayer: self)
        presenter.onViewDidLoad()
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        setTableViewDelegates()
        tableView.backgroundColor = UIColor.systemBackground
        tableView.rowHeight = 100
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    func setTableViewDelegates() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension TasksListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(tasks.count)
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskTableViewCell
        let task = tasks[indexPath.row]
        cell.taskLabel.text = task.fields.task
        cell.priorityLabel.text = task.fields.priority
        cell.dueDateLabel.text = task.fields.toDoBefore
        return cell
    }
}

extension TasksListViewController: TasksListDisplayer {
    func showTasks(_ tasks: [Record]) {
        
        DispatchQueue.main.async { [weak self] in
            print("HERE")
            self?.tasks = tasks
            self?.tableView.reloadData()
        }
    }
    
    func showError(_ error: Error) {
        print(error)
    }
}
