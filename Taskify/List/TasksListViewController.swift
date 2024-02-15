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

class TasksListViewController: UIViewController {
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
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTasks(_:)), name: Notification.Name(rawValue: "refreshTasks"), object: nil)
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
        navigationItem.rightBarButtonItem = addButton

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
    
    @objc func refreshTasks(_ notification: Notification) {
        self.presenter.fetchTasks()
    }
    @objc func addTask() {
           let createTaskViewController = CreateTaskViewController(navigationController: self.navigationController!)
           self.navigationController?.pushViewController(createTaskViewController, animated: true)
       }
}

extension TasksListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

extension TasksListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        let detailViewController = DetailViewController(task: task, navigationController: self.navigationController!)
        self.navigationController?.pushViewController(detailViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TasksListViewController: TasksListDisplayer {
    func showTasks(_ tasks: [Record]) {
        
        DispatchQueue.main.async { [weak self] in
            self?.tasks = tasks
            self?.tableView.reloadData()
        }
    }
    func showError(_ error: Error) {
        print("Error fetching tasks: \(error)")
    }
}
