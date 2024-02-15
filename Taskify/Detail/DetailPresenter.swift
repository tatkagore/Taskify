//
//  DetailPresenter.swift
//  Taskify
//
//  Created by Tatiana Simmer on 14/02/2024.
//

import Foundation
import UIKit

protocol DetailPresenter {
    func bind(displayer: DetailDisplayer)
    func deleteTask(with task: Record)
    var delegate: DetailDelegate? { get set }
}

class DetailPresenterImpl: DetailPresenter {
    let navigationController: UINavigationController
    weak var delegate: DetailDelegate?
    weak var displayer: DetailDisplayer?
    
    func bind(displayer: DetailDisplayer) {
        self.displayer = displayer
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func deleteTask(with task: Record) {
        guard let url = URL(string: "https://api.airtable.com/v0/appJirijcolqzO7W1/To%20do/\(task.id)") else {
            let error = NSError(domain: "NetworkErrorDomain", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid server URL"])
            displayer?.showError(error)
            return
        }
        
        let token = "patE6HCjsncG4qwFC.d7a099f755280c3efad9c8f42d8282d25edc1ba63533edcbf32247bfd6a6eae6"
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
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
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let deletionResponse = try decoder.decode(DeletionResponse.self, from: data)
                if deletionResponse.deleted {
                    DispatchQueue.main.async {
                        self.displayer?.taskDeletedSuccessfully()
                        self.navigationController.popViewController(animated: true)
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "refreshTasks"), object: nil)
                    }
                } else {
                    DispatchQueue.main.async {
                        self.displayer?.showError(APIError.unknownError )
                    }
                }
            }
            catch {
                print("Unexpected error: \(error).")
                DispatchQueue.main.async {
                    self.displayer?.showError(APIError.authenticationError)
                }
            }
        }
        task.resume()
    }
}
