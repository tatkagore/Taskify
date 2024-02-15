//
//  StyledTextField.swift
//  Taskify
//
//  Created by Tatiana Simmer on 15/02/2024.
//

import UIKit

class StyledTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupStyle()
    }

    private func setupStyle() {
        self.backgroundColor = .white
        self.layer.cornerRadius = 5.0 // Add rounded corners with a radius of 10
        self.layer.borderColor = UIColor(hex: "0077B6").cgColor // Set border color
        self.layer.borderWidth = 1.0 // Set border width
        self.font = UIFont(name: "Helvetica", size: 16) // Set font
        self.textColor = .black // Set text color
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftViewMode = .always // Add left padding
        self.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
    }
}
