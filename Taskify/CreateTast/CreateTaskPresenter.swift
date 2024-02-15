//
//  CreateTaskPresenter.swift
//  Taskify
//
//  Created by Tatiana Simmer on 15/02/2024.
//

import UIKit

// Protocol to define methods for the presenter
protocol CreateTaskPresenter {
    func bind(displayer: CreateTaskDisplayer)
    func didTapCreateTask(with model: TaskFields)
    var delegate: CreateTaskDelegate? { get set }
}

class CreateTaskPresenterImpl: CreateTaskPresenter {
    weak var delegate: CreateTaskDelegate?
    weak var displayer: CreateTaskDisplayer?
    let navigationController: UINavigationController
    
    func bind(displayer: CreateTaskDisplayer) {
        self.displayer = displayer
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func didTapCreateTask(with model: TaskFields) {
        
        // Construct a URL for the login endpoint
        
        guard let url = URL(string:"https://api.airtable.com/v0/appJirijcolqzO7W1/To%20do") else {
            let error = NSError(domain: "NetworkErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid server URL"])
            return
        }
        
        let token = "patE6HCjsncG4qwFC.d7a099f755280c3efad9c8f42d8282d25edc1ba63533edcbf32247bfd6a6eae6"
        
        // Create an HTTP request for create task
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue( "Bearer " + token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: model.toDoBefore)
        
        // Prepare request parameters
        let record: [String: Any] =
        [
            "Task" : model.task,
            "To do before" :dateString,
            "Priority":  model.priority
        ]
        let records: [[String: Any]] = [["fields": record]]
        
        let body: [String: Any] = ["records": records]
        
        do {
            // Serialize parameters to JSON and set as request body
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
            
        } catch {
            let error = NSError(domain: "NetworkErrorDomain", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to serialize request parameters"])
            delegate?.createTaskFailed(with: error)
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.displayer?.showError(error)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    self.displayer?.showError(APIError.invalidData)
                }
                return
            }
            do {
                // Parse the JSON response
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                if let stringData = String(data: data, encoding: .utf8) {
                    print(stringData)
                } else {
                    print("Failed to convert data to UTF-8 string")
                }
                
                let tasksResponse = try decoder.decode(TaskResponse.self, from: data)
                let tasks = tasksResponse.records
                if tasks.count == 1 {
                    DispatchQueue.main.async {
                        self.displayer?.showCreationTaskSuccessful()
                        self.navigationController.popViewController(animated: true)
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshTasks"), object: nil)
                    }
                } else {
                    self.displayer?.showError(APIError.invalidData)
                }
            } catch {
                delegate?.createTaskFailed(with: error)
            }
        }
        task.resume()
    }
}
