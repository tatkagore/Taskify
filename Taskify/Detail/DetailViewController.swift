//
//  DetailViewController.swift
//  Taskify
//
//  Created by Tatiana Simmer on 14/02/2024.
//


import UIKit

protocol DetailDisplayer: AnyObject {
    func showError(_ error: Error)
    func taskDeletedSuccessfully()
}
protocol DetailDelegate: AnyObject {
    
}

class DetailViewController: UIViewController {
//    let navigationController = UINavigationController()
    let presenter: DetailPresenter
    
    var task: Record?
    
    init(task: Record? = nil, navigationController: UINavigationController) {
        self.task = task
        self.presenter = DetailPresenterImpl(navigationController: navigationController)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.text = "Your task is:"
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        titleLabel.sizeToFit()
        return titleLabel
    }()
    
    let taskNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dueDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let priorityLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let deleteButton: StyledButton = {
        let button = StyledButton(type: .system)
        button.setTitle("Delete task", for: .normal)
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.titleView = titleLabel
        setupUI()
        
        if let task = task {
            taskNameLabel.text = task.fields.task
            dueDateLabel.text = "Deadline is ⏰: \(task.fields.toDoBefore)"
            priorityLabel.text = "Priority👷🏻‍♀️: \(task.fields.priority)"
        }
        presenter.bind(displayer: self)
    }
    
    @objc func deleteButtonTapped() {
        guard let task = task else {
            return
        }
        presenter.deleteTask(with: task)
    }
}

extension DetailViewController: DetailDisplayer {
    func showError(_ error: Error) {
        print("Error fetching tasks: \(error)")
    }
    
    func taskDeletedSuccessfully() {
        print("tesk was deleted")
    }
}

extension DetailViewController {
    private func setupUI() {
        view.addSubview(taskNameLabel)
        view.addSubview(dueDateLabel)
        view.addSubview(priorityLabel)
        view.addSubview(deleteButton)
        NSLayoutConstraint.activate([
            taskNameLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            taskNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            taskNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            dueDateLabel.topAnchor.constraint(equalTo: taskNameLabel.bottomAnchor, constant: 10),
            dueDateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            dueDateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            priorityLabel.topAnchor.constraint(equalTo: dueDateLabel.bottomAnchor, constant: 10),
            priorityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            priorityLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            deleteButton.topAnchor.constraint(equalTo: priorityLabel.bottomAnchor, constant: 50),
            deleteButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            deleteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
}
