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

class TasksListViewController: UIViewController {
    let presenter: TasksListPresenter = TasksListsPresenterImpl()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blue
        presenter.onViewDidLoad()
    }
}

