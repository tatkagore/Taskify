//
//  ListPresenter.swift
//  Taskify
//
//  Created by Tatiana Simmer on 13/02/2024.
//
import Foundation

protocol TasksListPresenter {
    func bind(displayer: TasksListDisplayer)
    func onViewDidLoad()
    func fetchTasks()
    var delegate: TasksListDelegate? { get set }
}

class TasksListsPresenterImpl: TasksListPresenter {
    weak var delegate: TasksListDelegate?
    weak var displayer: TasksListDisplayer?
    
    func bind(displayer: TasksListDisplayer) {
        self.displayer = displayer
    }
    
    func onViewDidLoad() {
        fetchTasks()
    }

    func fetchTasks() {
        // Construct a URL for the Tasks endpoint
        guard let url = URL(string: "https://api.airtable.com/v0/appJirijcolqzO7W1/To%20do?view=Grid%20view") else {
            let error = NSError(domain: "NetworkErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid server URL"])
            displayer?.showError(error)
            return
        }
        
        let token = "patE6HCjsncG4qwFC.d7a099f755280c3efad9c8f42d8282d25edc1ba63533edcbf32247bfd6a6eae6"
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue( "Bearer " + token, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                print(error)
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
                // Parse the JSON response directly into an array of TaskModel objects
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                
                // to see server response
                //                if let stringData = String(data: data, encoding: .utf8) {
                //                    print(stringData)
                //                } else {
                //                    print("Failed to convert data to UTF-8 string")
                //                }
                
                let tasksResponse = try decoder.decode(RecordsResponse.self, from: data)
                let tasks = tasksResponse.records
                DispatchQueue.main.async {
                    self.displayer?.showTasks(tasks)
                    print(tasks)
                }
            } catch {
                print("Unexpected error: \(error).")
                DispatchQueue.main.async {
                    self.displayer?.showError(APIError.authenticationError)
                }
            }
        }
        task.resume()
    }
}
