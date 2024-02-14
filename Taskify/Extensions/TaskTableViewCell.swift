//
//  File.swift
//  Taskify
//
//  Created by Tatiana Simmer on 13/02/2024.
//

import Foundation
import UIKit

class TaskTableViewCell: UITableViewCell {
    static let identifier = "TaskCell"
    var tasks: [Record] = []

    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let taskLabel = UILabel()
    let priorityLabel = UILabel()
    let dueDateLabel = UILabel()
    let calendarIcon = UIImageView(image: UIImage(systemName: "calendar"))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        containerView.addSubview(taskLabel)
        containerView.addSubview(priorityLabel)
        containerView.addSubview(dueDateLabel)
        contentView.addSubview(calendarIcon) // Add the calendar icon to the content view
        contentView.addSubview(containerView)
        
        configureTaskLabel()
        configurePriorityLabel()
        configureDueDateLabel()
        setLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLabelConstraints() {
        taskLabel.translatesAutoresizingMaskIntoConstraints = false
        priorityLabel.translatesAutoresizingMaskIntoConstraints = false
        dueDateLabel.translatesAutoresizingMaskIntoConstraints = false
        calendarIcon.translatesAutoresizingMaskIntoConstraints = false

        calendarIcon.tintColor = .black

        NSLayoutConstraint.activate([
                 taskLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                 taskLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                 taskLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20), // Adjust to your layout
                 
                 priorityLabel.topAnchor.constraint(equalTo: taskLabel.bottomAnchor, constant: 4),
                 priorityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
                 
                 dueDateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
                 dueDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16), // Adjust to your layout
                 
                 calendarIcon.centerYAnchor.constraint(equalTo: dueDateLabel.centerYAnchor), // Align the center of the calendar icon vertically with the due date label
                 calendarIcon.trailingAnchor.constraint(equalTo: dueDateLabel.leadingAnchor, constant: -8) // Set the calendar icon to the left of the due date label with a spacing of 8 points
             ])
    }
    
    func configureTaskLabel() {
        taskLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        taskLabel.numberOfLines = 0
        taskLabel.lineBreakMode = .byWordWrapping
        taskLabel.adjustsFontSizeToFitWidth = true
        taskLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
    }
    
    func configurePriorityLabel() {
        priorityLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        priorityLabel.numberOfLines = 0
        priorityLabel.adjustsFontSizeToFitWidth = true
    }
    
    func configureDueDateLabel() {
        dueDateLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        dueDateLabel.numberOfLines = 0
        dueDateLabel.adjustsFontSizeToFitWidth = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let margin: CGFloat = 10
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin))
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor(ciColor: .gray).withAlphaComponent(0.5).cgColor
        
    }
}
