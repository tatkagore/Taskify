//
//  CreatTaskViewController.swift
//  Taskify
//
//  Created by Tatiana Simmer on 15/02/2024.
//

import UIKit

protocol CreateTaskDisplayer: AnyObject {
    func showError(_ error: Error)
    func showCreationTaskSuccessful()
}

// Protocol to define methods for handling CreatTask-related events
protocol CreateTaskDelegate: AnyObject {
    func createTaskFailed(with error: Error)
}


class CreateTaskViewController: UIViewController, CreateTaskDelegate, CreateTaskDisplayer {
    
    init(navigationController: UINavigationController) {
        self.presenter = CreateTaskPresenterImpl(navigationController: navigationController)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let priorities = ["Low", "Medium", "High"]
    var segmentedControl: UISegmentedControl!
    
    
    
    let taskTextField: StyledTextField = {
        let textField = StyledTextField()
        textField.placeholder = "Write your task here..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocapitalizationType = .none
        return textField
    }()
    
    let priorityTextField: StyledTextField = {
        let textField = StyledTextField()
        textField.placeholder = "Task priority"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocapitalizationType = .none
        return textField
    }()
    
    let deadlineDatePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        return datePicker
    }()
    
    let createTaskButton: StyledButton = {
        let button = StyledButton(type: .system)
        button.setTitle("Create task", for: .normal)
        button.addTarget(self, action: #selector(createTaskButtonTapper), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var presenter: CreateTaskPresenter
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        segmentedControl = UISegmentedControl(items: priorities)
        
        let segmentedControlWidth = view.bounds.width - 40
        let segmentedControlHeight: CGFloat = 30
        segmentedControl.frame = CGRect(x: 20, y: 100, width: segmentedControlWidth, height: segmentedControlHeight)
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        view.addSubview(segmentedControl)

        presenter.delegate = self
        presenter.bind(displayer: self)
        setUpConstraints()
    }
    
    //MARK: Create SegmentedControl
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        let selectedPriority = priorities[sender.selectedSegmentIndex]
        print("Selected priority: \(selectedPriority)")
    }
    
    //MARK: Create DatePicker
    @objc func datePickerValueChanged() {
        let selectedDate = deadlineDatePicker.date
    }
    
    //MARK: Create Task
    @objc func createTaskButtonTapper() {
        guard let taskName = taskTextField.text, !taskName.isEmpty
        else {
            return
        }
        let datePicker = deadlineDatePicker.date
        
        
        let createTaskModel = TaskFields(
            toDoBefore: datePicker,
            priority: priorities[segmentedControl.selectedSegmentIndex],
            task: taskName,
            done: false)
        presenter.didTapCreateTask(with: createTaskModel)
    }
}

extension CreateTaskViewController {
    // MARK: - Auto Layout
    
    func setUpConstraints() {
        // Create a stack view to stack the text fields vertically
        let stackView = UIStackView(arrangedSubviews: [taskTextField, deadlineDatePicker, segmentedControl, createTaskButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            // Center the stack view vertically
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            // Center the stack view horizontally
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            deadlineDatePicker.widthAnchor.constraint(equalTo: stackView.widthAnchor, constant: -120)
        ])
    }
}

extension CreateTaskViewController {
    func showError(_ error: Error) {}
    
    func createTaskFailed(with error: Error) {
        print("Creation error: \(error.localizedDescription)")
    }
    
    func showCreationTaskSuccessful() {
        print("Creation is successful")
    }
}
