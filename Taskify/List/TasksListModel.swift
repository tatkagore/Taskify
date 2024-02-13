//
//  ListModel.swift
//  Taskify
//
//  Created by Tatiana Simmer on 13/02/2024.
//

import Foundation

struct RecordFields: Codable {
    let toDoBefore: String
    let priority: String
    let task: String
    let done: Bool?
    
    enum CodingKeys: String, CodingKey {
        case toDoBefore = "To do before"
        case priority = "Priority"
        case task = "Task"
        case done = "Done"
    }
}

struct Record: Codable {
    let id: String
    let createdTime: String
    let fields: RecordFields
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdTime
        case fields
    }
    
    func getDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.date(from: createdTime)
    }
}


struct RecordsResponse: Codable {
    let records: [Record]
}

